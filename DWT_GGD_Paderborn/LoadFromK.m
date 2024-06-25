function features = LoadFromK(varnames, faultType, sigSize)

    path = '..\Bearings For Experiment\';
    
    sampleCount = 5;

    N_files = 80; %number of total files in Paderborn folder
    N_features = 4;

    sz = [length(varnames) * sampleCount * N_files, N_features + 1];
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
                rotationalSpeed = 1500;
            elseif (contains(mat(q).name, 'N09'))
                rotationalSpeed = 900;
            end
            
            if (contains(mat(q).name, 'M07'))
                loadTorque = 0.7;
            elseif (contains(mat(q).name, 'M01'))
                loadTorque = 0.1;
            end
                
            if (contains(mat(q).name, 'F10'))
                radialForce = 1000;
            elseif (contains(mat(q).name, 'F04'))
                radialForce = 400;
            end
   
            % Searching for the desired signal in the dataset
            % Y(7) for vibration Y(2) for phase current 1
            fns = fieldnames(data_in);
            signal = data_in.(fns{1}).Y(7).Data; 
   
            % RMS signal normalization
            R_dB = 0;
            R = 10^(R_dB/20);
            scalingFactor = sqrt((length(signal) * R^2)/(sum(signal.^2)));
            signal = signal * scalingFactor;
   
            % Features extraction
            step = sigSize/2;
            for j = 1:sampleCount
                fts = GetFeatures(signal(j*step:j*step + sigSize));

                % Table generation                 
                ftsString = '';
                for p = 1:length(fts)
                    ftsString = append(ftsString, ['fts(', num2str(p), '), ']);
                end
                ftsString = append(ftsString, 'response');    
                response = strcat(faultType);% + ...
%                     " RS=" + rotationalSpeed + ...
%                     " RF=" + radialForce + ...
%                     " Torque=" + loadTorque);

                tabl = eval(['table(', ftsString, ')']);

                % i - folders
                % q - files in folder
                % j - samples within file
                features((i-1) * sampleCount * N_files + (q-1) * sampleCount + j,:) = tabl;
            end
        end
    end
end

