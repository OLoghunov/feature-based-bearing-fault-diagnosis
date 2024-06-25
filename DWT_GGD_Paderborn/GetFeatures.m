function fts = GetFeatures(signal)
    %% TIME DOMAIN
    % peak value
    %     
%     signalPeak = max(signal);
%     
%     % shape factor
%     %     
%     shapeFactor = rms(signal)/mean(abs(signal));

    
    %% WAVELET DOMAIN
    % decomposition level of signal
    %
    i = 5; 
    levels = [1 2];
    ftsOnLevel = 2;

    fts = zeros(1, length(levels) * ftsOnLevel);
    normalizedCoefs = cell(1, length(levels));

    % wavelet coefficients
    %
    [c,l] = wavedec(signal,i,"sym3");
    
    detCoefs = detcoef(c,l,levels);
%     approx = appcoef(c,l,"db2");

    for i = 1:length(levels)
        approx = cell2mat(detCoefs(i));

        wave_norm = (approx - min(approx)) / ( max(approx) - min(approx));
        wave_norm = wave_norm + 0.00001;
        wave_norm = rmoutliers(wave_norm, 'median');
        wave_norm = wave_norm';

        normalizedCoefs(i) = {wave_norm};
    end

    % energy of the wavelet coefficients
    %
%     waveletEnergy = wenergy(c, l);


    %% STATISTICAL ANALYSIS
    % distribution
    %
    for i = 1:length(normalizedCoefs)
%         pd(i) = fitdist(cell2mat(normalizedCoefs(i)), 'normal');
        pd = fitGGD(cell2mat(normalizedCoefs(i)));

        fts(ftsOnLevel * i - 1) = pd.a;
        fts(ftsOnLevel * i) = pd.b;
%         fts(ftsOnLevel * i) = pd.m;
    end
end

