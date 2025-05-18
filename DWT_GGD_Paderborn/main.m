% MAIN SCRIPT
% 
% Сheck out the path variable in LoadFromK function
% 
% If the number of features has changed, 
% you need to change the variable N_features in LoadFromK respectively
% 
% LoadFromK contains RMS normalization of signal
% change it if necessary
% 
% Output of GetFeatures function is array of doubles

% Warnings occur from the fact that parameters in fitGGD code are changing
warning('off')

close all
features = table();

signal_sizes = [1000, 2000, 5000];
accuracy = zeros(1, length(signal_sizes));

for i = 1:length(signal_sizes)
    % Healthy
    varnames = ["K001","K002","K003","K006"];
    faultType = "Healthy";
    features = [features; LoadFromK(varnames, faultType, signal_sizes(i))];
    
    % OR Damage
    varnames = ["KA04","KA05","KA22","KA30"];
    faultType = "ORDamage";
    features = [features; LoadFromK(varnames, faultType, signal_sizes(i))];
    
    % IR Damage
    varnames = ["KI01","KI16","KI17","KI21"];
    faultType = "IRDamage";
    features = [features; LoadFromK(varnames, faultType, signal_sizes(i))];
    
    features.Properties.VariableNames{end} = 'response';   
    
    % KNN    
    [~, accuracy(i)] = trainClassifier(features);

     features = table();
end

plot(signal_sizes, accuracy)
xlabel('sample number')
ylabel('accuracy')
grid on

warning('on')