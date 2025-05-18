% MAIN SCRIPT
% 
% Сheck out the path variable in load_data function
% 
% If the number of features has changed, 
% you need to change the variable N_features in load_data respectively
% 
% load_data contains RMS normalization of signal
% change it if necessary
% 
% Output of get_features function is array of doubles

% Warnings occur from the fact that parameters in fit_GGD code are changing
warning('off')
close all

% Data parameters
num_samples = 2400;
num_features = 4;
signal_sizes = [1000];
accuracy = zeros(1, length(signal_sizes));

feature_names = strcat('feature_', string(1:num_features));
features = array2table(zeros(num_samples, num_features), ...
           'VariableNames', feature_names);
features.response = strings(num_samples, 1);

current_idx = 1;
    
for i = 1:length(signal_sizes)
    current_idx = 1;
    features{:, :} = 0;
    features.response(:) = "";  

    num_samples_per_file = 400;

    % Healthy
    % varnames = ["K001","K002","K003","K006"];
    varnames = ["K001","K002"];
    fault_type = "Healthy";
    features = load_data_into_table(features, varnames, fault_type, ...
                                   signal_sizes(i), num_samples_per_file, current_idx);
    current_idx = current_idx + length(varnames)*num_samples_per_file;

    
    % OR Damage
    % varnames = ["KA04","KA05","KA22","KA30"];
    varnames = ["KA04","KA05"];
    fault_type = "ORDamage";
    features = load_data_into_table(features, varnames, fault_type, ...
                                   signal_sizes(i), num_samples_per_file, current_idx);
    current_idx = current_idx + length(varnames)*num_samples_per_file;
    
    % IR Damage
    % varnames = ["KI01","KI16","KI17","KI21"];
    varnames = ["KI01","KI16"];
    fault_type = "IRDamage";
    features = load_data_into_table(features, varnames, fault_type, ...
                                   signal_sizes(i), num_samples_per_file, current_idx);   
    
    % KNN    
    [~, accuracy(i)] = train_classifier(features);
end

plot(signal_sizes, accuracy)
xlabel('sample number')
ylabel('accuracy')
grid on

warning('on')