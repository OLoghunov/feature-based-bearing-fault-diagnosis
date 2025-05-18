function features = load_data_into_table(features, varnames, fault_type, ...
    signal_size, num_samples_per_file, start_idx, cfg)
    for k = 1:length(varnames)
        new_data = load_data(varnames(k), fault_type, signal_size, cfg);
        
        idx_range = start_idx + (k-1)*num_samples_per_file : start_idx + k*num_samples_per_file - 1;
        
        features{idx_range, 1:cfg.n_features} = table2array(new_data(:, 1:cfg.n_features));
        
        features.response(idx_range) = repmat(fault_type, num_samples_per_file, 1);
    end
end