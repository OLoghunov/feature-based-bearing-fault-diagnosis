function fts = get_features(signal, fs, rpm)
    %% PREPROCESSING

%     % Bearing Parameters (Table 1)
%     Nb = 8;
%     Bd = 6.75e-3;
%     Pd = 28.55e-3;
%     phi = 0;
% 
%     bpfo = (Nb/2) * (1 - (Bd/Pd)*cos(phi)) * (rpm/60);
%     bpfi = (Nb/2) * (1 + (Bd/Pd)*cos(phi)) * (rpm/60);
% 
%     % Bands around BPFO/BPFI ±20%
%     [b, a] = butter(4, [0.8*bpfo, 1.2*bpfo]/(fs/2), 'bandpass');
%     bpfo_signal = filtfilt(b, a, signal);
%     [b, a] = butter(4, [0.8*bpfi, 1.2*bpfi]/(fs/2), 'bandpass');
%     bpfi_signal = filtfilt(b, a, signal);

    %%

    wp = wpdec(signal, 3, 'db4');
    
    % Energy of 8 nodes at 3rd level
    wavelet_features = zeros(1,8);
    for i = 0:7
        node_coefs = wpcoef(wp, [3 i]);
        wavelet_features(i+1) = sum(node_coefs.^2); % Энергия узла
    end
% 
%     [P1, f] = pwelch(signal, [], [], [], fs);
%     
%     % BPFO Harmonic Search (1-3 harmonics)
%     bpfo_harmonics = zeros(1,3);
%     for i = 1:3
%         [~, idx] = findpeaks(P1, 'SortStr','descend', ...
%             'NPeaks',1, 'MinPeakDistance',bpfo*0.1);
%         bpfo_harmonics(i) = P1(idx(1));
%     end
%     
%     % BPFI Harmonic Search (1-3 harmonics)
%     bpfi_harmonics = zeros(1,3);
%     for i = 1:3
%         [~, idx] = findpeaks(P1, 'SortStr','descend', ...
%             'NPeaks',1, 'MinPeakDistance',bpfi*0.1);
%         bpfi_harmonics(i) = P1(idx(1));
%     end
%     
%     freq_features = [bpfo_harmonics, bpfi_harmonics];
% 
%     temporal_features = [
%         rms(signal), peak2peak(signal), kurtosis(signal), ...
%         skewness(signal), max(signal)/rms(signal)
%     ];
%     
%     am_depth_bpfo = (max(bpfo_signal) - min(bpfo_signal)) / mean(abs(bpfo_signal));
%     am_depth_bpfi = (max(bpfi_signal) - min(bpfi_signal)) / mean(abs(bpfi_signal));
%     
%     energy_ratio = sum(bpfo_signal.^2) / sum(bpfi_signal.^2);
%     
%     mod_features = [
%         am_depth_bpfo, am_depth_bpfi, energy_ratio, mean(abs(diff(signal)))
%     ];

%     fts = [wavelet_features, freq_features, temporal_features, mod_features];
    
    signal_rms = rms(signal);
    signal_variance = var(signal);
    signal_peak = max(abs(signal));
    crest_factor = signal_peak / signal_rms;
    signal_kurtosis = kurtosis(signal);
    clearance_factor = signal_peak / (mean(sqrt(abs(signal)))^2);
    impulse_factor = signal_peak / mean(abs(signal));
    shape_factor = signal_rms / mean(abs(signal));
    line_integral = sum(abs(diff(signal)));
    p2p = peak2peak(signal);
    shannon = entropy(signal);
    skew = skewness(signal);

    temporal_features = [
        signal_rms, signal_variance, signal_peak, crest_factor, ...
        signal_kurtosis, clearance_factor, impulse_factor, ...
        shape_factor, line_integral, p2p, shannon, skew
        ];


    N = length(signal);
    fft_vals = abs(fft(signal)/N);
    fft_vals = fft_vals(1:N/2+1);
    fft_vals(2:end-1) = 2*fft_vals(2:end-1);
    f = fs*(0:(N/2))/N;
    
    % Peak value of FFT
    fft_peak = max(fft_vals);
    
    % Energy of FFT
    fft_energy = sum(fft_vals.^2);
    
    % Power spectral density (PSD)
    [pxx, ~] = pwelch(signal, [], [], [], fs);
    psd_mean = mean(pxx);

    freq_features = [
        fft_peak, fft_energy, psd_mean
    ];

    fts = [wavelet_features, temporal_features, freq_features];

%     fts = wavelet_features([2, 4, 6, 8]);

end

