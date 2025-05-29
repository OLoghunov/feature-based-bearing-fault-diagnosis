function features = load_data(varnames, fault_type, sig_size, cfg)

    path = '..\Bearings For Experiment\';
    
    sample_count = 1;
    fs = 64000;

    n_files = 80; %number of total files in Paderborn folder
    n_features = cfg.n_features;

    sz = [length(varnames) * sample_count * n_files, n_features + 1];
    vartype = repmat({'double'},1,sz(2) - 1);
    vartype = [vartype, {'string'}];
    features = table('Size', sz, 'VariableTypes', vartype);

    for i = 1:length(varnames)
        % Folder selection
        mat = dir(strcat(path, varnames(i), '\*.mat'));
        for q = 1:length(mat) 
            % File loading
            data_in = load(strcat(path, varnames(i), '\', mat(q).name));
            
            % File analysis
            if (contains(mat(q).name, 'N15'))
                rotational_speed = 1500;
            elseif (contains(mat(q).name, 'N09'))
                rotational_speed = 900;
            end
            
            if (contains(mat(q).name, 'M07'))
                load_torque = 0.7;
            elseif (contains(mat(q).name, 'M01'))
                load_torque = 0.1;
            end
                
            if (contains(mat(q).name, 'F10'))
                radial_force = 1000;
            elseif (contains(mat(q).name, 'F04'))
                radial_force = 400;
            end
   
            % Searching for the desired signal in the dataset
            % Y(7) for vibration Y(2) for phase current 1
            fns = fieldnames(data_in);
            signal = data_in.(fns{1}).Y(2).Data; 
   
            % RMS signal normalization
            R_dB = 0;
            R = 10^(R_dB/20);
            scaling_factor = sqrt((length(signal) * R^2)/(sum(signal.^2)));
            signal = signal * scaling_factor;
   
            % For full signal
            sig_size = min(sig_size, length(signal));

            % Features extraction
            step = sig_size/2;
            for j = 1:sample_count
                fts = get_features(signal((j-1)*step+1:(j-1)*step + sig_size), ...
                    fs, ...
                    rotational_speed);

                % Table generation                 
                fts_string = '';
                for p = 1:length(fts)
                    fts_string = append(fts_string, ['fts(', num2str(p), '), ']);
                end
                fts_string = append(fts_string, 'response');    
                response = strcat(fault_type);% + ...
%                     " RS=" + rotationalSpeed + ...
%                     " RF=" + radialForce + ...
%                     " Torque=" + loadTorque);

                tabl = eval(['table(', fts_string, ')']);

                % i - folders
                % q - files in folder
                % j - samples within file
                features((i-1) * sample_count * n_files + (q-1) * sample_count + j,:) = tabl;
            end
        end
    end
end

