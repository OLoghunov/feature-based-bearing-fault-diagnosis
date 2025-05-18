function fts = get_features(signal)
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
    fts_on_level = 2;

    fts = zeros(1, length(levels) * fts_on_level);
    normalized_coefs = cell(1, length(levels));

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

        normalized_coefs(i) = {wave_norm};
    end

    % energy of the wavelet coefficients
    %
%     waveletEnergy = wenergy(c, l);


    %% STATISTICAL ANALYSIS
    % distribution
    %
    for i = 1:length(normalized_coefs)
%         pd(i) = fitdist(cell2mat(normalizedCoefs(i)), 'normal');
        pd = fit_GGD(cell2mat(normalized_coefs(i)));

        fts(fts_on_level * i - 1) = pd.a;
        fts(fts_on_level * i) = pd.b;
%         fts(ftsOnLevel * i) = pd.m;
    end
end

