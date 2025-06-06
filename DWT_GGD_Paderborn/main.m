% MAIN SCRIPT
% 
% Сheck out the path variable in load_data function
% 
% load_data contains RMS normalization of signal
% change it if necessary
% 
% Output of get_features function is array of doubles

% Warnings occur from the fact that parameters in fit_GGD code are changing
warning('off')
close all

% Data parameters
cfg = config();

healthy_varnames = ["K001","K002","K003","K004","K005"];
or_damage_varnames = ["KA04","KA15","KA16","KA22","KA30"];
ir_damage_varnames = ["KI04","KI14","KI16","KI18","KI21"];

n_folders = length([healthy_varnames, or_damage_varnames, ir_damage_varnames]);
n_samples_per_folder = 80;
n_samples = n_folders * n_samples_per_folder;
n_features = cfg.n_features;
signal_sizes = [1000, 2000, 5000, 100000, Inf];
accuracy = zeros(1, length(signal_sizes));

feature_names = strcat('feature_', string(1:n_features));
features = array2table(zeros(n_samples, n_features), ...
           'VariableNames', feature_names);
features.response = strings(n_samples, 1);

current_idx = 1;
    
for i = 1:length(signal_sizes)
    current_idx = 1;
    features{:, :} = 0;
    features.response(:) = "";  

    % Healthy
%     varnames = [];
    fault_type = "Healthy";
    features = load_data_into_table(features, healthy_varnames, fault_type, ...
                                   signal_sizes(i), ...
                                   n_samples_per_folder, current_idx, cfg);
    current_idx = current_idx + length(healthy_varnames)*n_samples_per_folder;

    
    % OR Damage
%     varnames = ["KB27"];
    fault_type = "OR Damage";
    features = load_data_into_table(features, or_damage_varnames, fault_type, ...
                                   signal_sizes(i), ...
                                   n_samples_per_folder, current_idx, cfg);
    current_idx = current_idx + length(or_damage_varnames)*n_samples_per_folder;
    
    % IR Damage
%     varnames = ["KB23","KB24"];
    fault_type = "IR Damage";
    features = load_data_into_table(features, ir_damage_varnames, fault_type, ...
                                   signal_sizes(i), ...
                                   n_samples_per_folder, current_idx, cfg);   
    
    features_matrix = table2array(features(:, 1:end-1));
    response = features.response;
    
    [selected_features, selected_idx] = select_features(features_matrix, response);
    
    features_selected = array2table(selected_features, ...
        'VariableNames', features.Properties.VariableNames(selected_idx));
    features_selected.response = response;

    % Training    
    [~, accuracy(i)] = train_ensemble(features, {'Healthy'; 'OR Damage'; 'IR Damage'});
end

warning('on')