function [pd, signalPeak, meanSignal, shapeFactor,... 
    impulseFactor, ck, deviation, skew, kurt, crestFactor,... 
    clearanceFactor, specPeak, meanFreq, medianFreq, waveletEnergy,...
    norm_PP, wave_norm, vg] = GetFeatures(signal)
    %% TIME DOMAIN
    % peak value
    signalPeak = max(signal);

    % mean signal value
    meanSignal = mean(signal);
    
    % shape factor
    shapeFactor = rms(signal)/mean(abs(signal));
    
    % impulse factor
    impulseFactor = signalPeak/abs(mean(signal));
     
    % ck
    ck = mean((signal - meanSignal).^4)/(rms(signal)^4);
    
    % standard deviation
    deviation = std(signal);
    
    % skewness
    skew = skewness(signal);
 
    % kurtosis
    kurt = kurtosis(signal);
 
    % crest factor
    crestFactor = signalPeak/sqrt(mean(signal.^2));
 
    % clearance factor
    clearanceFactor = signalPeak/(mean(sqrt(abs(signal)))^2);
    
    %% FREQUENCY DOMAIN
    % spectrum
    spectrum = pspectrum(signal);
    
    % spectrum peak
    specPeak = max(spectrum);
    
    % mean frequency
    meanFreq = meanfreq(signal, 12000);
    
    % median frequency
    medianFreq = medfreq(signal, 12000);
    

    %% WAVELET DOMAIN
    % decomposition level of signal
    %
    i = 5; 

    % wavelet coefficients
    %
    [c,l] = wavedec(signal,i,"sym3");
    
    [cd1,cd2,cd3,cd4,cd5] = detcoef(c,l,[1 2 3 4 5]);
%     approx = appcoef(c,l,"db2");
    approx = cd4;

    wave_norm = (approx - min(approx)) / ( max(approx) - min(approx));
    wave_norm = wave_norm + 0.00001;
    wave_norm = rmoutliers(wave_norm, 'median');
    wave_norm = wave_norm';
    
    % energy of the wavelet coefficients
    %
    waveletEnergy = wenergy(c, l);


    %% PTP ANALYSIS
    Fs = 64e3;
    prom = 0.025;
    [PKS_DE, ~] = findpeaks(signal, Fs, 'MinPeakProminence', prom);
    [VLS_DE, ~] = findpeaks(-signal, Fs, 'MinPeakProminence', prom);
    VLS_DE = -VLS_DE;

    Lp = length(PKS_DE);
    Lv = length(VLS_DE);
    if Lp > Lv
        PKS_DE = PKS_DE(1:Lv);
    else
        VLS_DE = VLS_DE(1:Lp);
    end
    PP = PKS_DE - VLS_DE;

    norm_PP = (PP - min(PP)) / ( max(PP) - min(PP));
    norm_PP = norm_PP + 0.00001;
    norm_PP = rmoutliers(norm_PP, 'median');
    norm_PP = transpose(norm_PP);
    
    % For statistical analysis
    %
    pd = fitdist(wave_norm, 'normal');

    %% NVG
    vg = fast_NVG(signal, 1:length(signal));
end

