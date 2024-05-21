close all
features = table();

% Healthy
varnames = ["K001"];
faultType = "Healthy";
features = [features; LoadFromK(varnames, faultType)];

% OR Damage
varnames = ["KA01"];
faultType = "ORDamage";
features = [features; LoadFromK(varnames, faultType)];

% IR Damage
varnames = ["KI01"];
faultType = "IRDamage";
features = [features; LoadFromK(varnames, faultType)];

features.Properties.VariableNames{1} = 'lambda';
features.Properties.VariableNames{2} = 'k';
features.Properties.VariableNames{3} = 'signal peak';
features.Properties.VariableNames{4} = 'mean signal';
features.Properties.VariableNames{5} = 'shape factor';
features.Properties.VariableNames{6} = 'impulse factor';
features.Properties.VariableNames{7} = 'ck';
features.Properties.VariableNames{8} = 'deviation';
features.Properties.VariableNames{9} = 'skewness';
features.Properties.VariableNames{10} = 'kurtosis';
features.Properties.VariableNames{11} = 'crest factor';
features.Properties.VariableNames{12} = 'clearance factor';
features.Properties.VariableNames{13} = 'spectrum peak';
features.Properties.VariableNames{14} = 'mean freq';
features.Properties.VariableNames{15} = 'median freq';
features.Properties.VariableNames{16} = 'wavelet energy';
features.Properties.VariableNames{17} = 'response';