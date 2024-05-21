function features = LoadFromK(varnames, faultType, ignore)
    if nargin < 3
        ignore = [];
    end
    sampleCount = 200;
    sz = [length(varnames) * 1 * sampleCount , 17];
    vartype = repmat({'double'},1,sz(2) - 1);
    vartype = [vartype, {'string'}];
    features = table('Size', sz, 'VariableTypes', vartype);

    for i = 1:length(varnames)
        % Folder selection
        mat = dir(strcat('..\..\Paderborn Bearings\', varnames(i), '\*.mat'));
        num = 0;
        for q = 1:length(mat) 
            % File loading
            fl = 1;
            for n = 1:length(ignore)
                if (contains(mat(q).name, ignore(n)))
                    fl = 0;
                end
            end

            if (fl == 0)
                continue;
            end

            if (contains(mat(q).name, '_1.') && contains(mat(q).name, 'N09'))
                data_in = load(strcat('..\..\Paderborn Bearings\', varnames(i), '\', mat(q).name));
            

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
            signal = data_in.(fns{1}).Y(7).Data(1:sampleCount * 1e3); 

            % RMS signal normalization
            R_dB = 0;
            R = 10^(R_dB/20);
            scalingFactor = sqrt((length(signal) * R^2)/(sum(signal.^2)));
            signal = signal * scalingFactor;

            % Features extraction
            step = 500;
            sigSize = 2000;
            
            if (contains(mat(q).name, '_1.') && contains(mat(q).name, 'N09'))
                for j = 1:sampleCount
                    [pd, signalPeak, meanSignal, shapeFactor,...
                        impulseFactor, ck, deviation, skew, kurt,...
                        crestFactor, clearanceFactor, specPeak,...
                        meanFreq, medianFreq, waveletEnergy,...
                        norm_PP, wave_norm, vg] = GetFeatures(signal(j*step:j*step + sigSize));
                    
                    response = strcat(faultType + ...
                        " RS=" + rotationalSpeed + ...
                        " RF=" + radialForce + ...
                        " Torque=" + loadTorque);
                    features(num * sampleCount + j,:) = table(pd.mu, pd.sigma, signalPeak, meanSignal, shapeFactor, impulseFactor, ck, deviation, skew, kurt, crestFactor, clearanceFactor, specPeak, meanFreq, medianFreq, waveletEnergy, response);
                end
                num = num + 1;
            end
            if (contains(mat(q).name, '_1.') && num == 1)
                f = figure();
                t = tiledlayout(3, 1);
                title(t, strcat("Folder " + varnames(i) + " " + faultType))
                m = 1;
            end

            if (contains(mat(q).name, '_1.'))
                distType = 'wbl';
                nexttile(m)
                
                histfit(norm_PP, 100, distType);
                xlabel('Peak-to-peak ampl.');
                ylabel('N');
                title({strcat("File " + strrep(mat(q).name, '_', '-')); strcat("RS=" + rotationalSpeed + " RF=" + radialForce + " Torque=" + loadTorque)})
                
                distType = 'normal';
                nexttile(1 + m)
                histfit(wave_norm, 30, distType);
                xlabel('Wavelet coeffitients');
                ylabel('N');

                nexttile(2 + m);
                G = graph(full(vg));
                p = plot(G);
                [edgebins,iC] = biconncomp(G);
                highlight(p, iC);
                p.EdgeCData = edgebins;
               
                m = m + 1;
            end
            end
        end
    end
end

