function fts = get_features(signal, fs, rpm)
    %% PREPROCESSING

    % Bearing Parameters (Table 1)
    Nb = 8;
    Bd = 6.75e-3;
    Pd = 28.55e-3;
    phi = 0;

    bpfo = (Nb/2) * (1 - (Bd/Pd)*cos(phi)) * (rpm/60);
    bpfi = (Nb/2) * (1 + (Bd/Pd)*cos(phi)) * (rpm/60);

    % Bands around BPFO/BPFI ±20%
    [b, a] = butter(4, [0.8*bpfo, 1.2*bpfo]/(fs/2), 'bandpass');
    bpfo_signal = filtfilt(b, a, signal);
    [b, a] = butter(4, [0.8*bpfi, 1.2*bpfi]/(fs/2), 'bandpass');
    bpfi_signal = filtfilt(b, a, signal);

    %%

    wp = wpdec(signal, 3, 'db4');
    
    % Energy of 8 nodes at 3rd level
    wavelet_features = zeros(1,8);
    for i = 0:7
        node_coefs = wpcoef(wp, [3 i]);
        wavelet_features(i+1) = sum(node_coefs.^2); % Энергия узла
    end

    [P1, f] = pwelch(signal, [], [], [], fs);
    
    % BPFO Harmonic Search (1-3 harmonics)
    bpfo_harmonics = zeros(1,3);
    for i = 1:3
        [~, idx] = findpeaks(P1, 'SortStr','descend', ...
            'NPeaks',1, 'MinPeakDistance',bpfo*0.1);
        bpfo_harmonics(i) = P1(idx(1));
    end
    
    % BPFI Harmonic Search (1-3 harmonics)
    bpfi_harmonics = zeros(1,3);
    for i = 1:3
        [~, idx] = findpeaks(P1, 'SortStr','descend', ...
            'NPeaks',1, 'MinPeakDistance',bpfi*0.1);
        bpfi_harmonics(i) = P1(idx(1));
    end
    
    freq_features = [bpfo_harmonics, bpfi_harmonics];

    temporal_features = [
        rms(signal), peak2peak(signal), kurtosis(signal), ...
        skewness(signal), max(signal)/rms(signal)
    ];
    
    am_depth_bpfo = (max(bpfo_signal) - min(bpfo_signal)) / mean(abs(bpfo_signal));
    am_depth_bpfi = (max(bpfi_signal) - min(bpfi_signal)) / mean(abs(bpfi_signal));
    
    energy_ratio = sum(bpfo_signal.^2) / sum(bpfi_signal.^2);
    
    mod_features = [
        am_depth_bpfo, am_depth_bpfi, energy_ratio, mean(abs(diff(signal)))
    ];

    fts = [wavelet_features, freq_features, temporal_features, mod_features];
%     fts = wavelet_features([2, 4, 6, 8]);

end

