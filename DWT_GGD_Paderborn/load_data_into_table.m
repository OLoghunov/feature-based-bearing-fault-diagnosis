function features = load_data_into_table(features, varnames, fault_type, signal_size, num_samples_per_file, start_idx)
    for k = 1:length(varnames)
        new_data = load_data(varnames(k), fault_type, signal_size);
        
        idx_range = start_idx + (k-1)*num_samples_per_file : start_idx + k*num_samples_per_file - 1;
        
        features{idx_range, 1:4} = table2array(new_data(:, 1:4));
        
        features.response(idx_range) = repmat(fault_type, num_samples_per_file, 1);
    end
end