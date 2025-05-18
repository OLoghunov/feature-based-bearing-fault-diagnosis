function [trainedClassifier, validationAccuracy] = trainClassifier(trainingData)
    %  Input:
    %      trainingData: A table containing the same predictor and response
    %       columns as those imported into the app.
    %
    %  Output:
    %      trainedClassifier: A struct containing the trained classifier. The
    %       struct contains various fields with information about the trained
    %       classifier.
    %
    %      trainedClassifier.predictFcn: A function to make predictions on new
    %       data.
    %
    %      validationAccuracy: A double containing the accuracy as a
    %       percentage. In the app, the Models pane displays this overall
    %       accuracy score for each model.

    % Extract predictors and response
    % This code processes the data into the right shape for training the
    % model.
    inputTable = trainingData;
    
    varNames = trainingData.Properties.VariableNames;
    varNames(end) = [];
    predictorNames = varNames;
    
    predictors = inputTable(:, predictorNames);
    response = inputTable.response;
    
    % Train a classifier
    % This code specifies all the classifier options and trains the classifier.
    classificationKNN = fitcknn(...
        predictors, ...
        response, ...
        'Distance', 'Minkowski', ...
        'Exponent', 3, ...
        'NumNeighbors', 10, ...
        'DistanceWeight', 'Equal', ...
        'Standardize', true, ...
        'ClassNames', {'Healthy'; 'IRDamage'; 'ORDamage'});
    
    % Create the result struct with predict function
    predictorExtractionFcn = @(t) t(:, predictorNames);
    knnPredictFcn = @(x) predict(classificationKNN, x);
    trainedClassifier.predictFcn = @(x) knnPredictFcn(predictorExtractionFcn(x));
    
    % Add additional fields to the result struct
    trainedClassifier.RequiredVariables = predictorNames;
    trainedClassifier.ClassificationKNN = classificationKNN;
    trainedClassifier.About = 'This struct is a trained model exported from Classification Learner R2022a.';
    trainedClassifier.HowToPredict = sprintf('To make predictions on a new table, T, use: \n  yfit = c.predictFcn(T) \nreplacing ''c'' with the name of the variable that is this struct, e.g. ''trainedModel''. \n \nThe table, T, must contain the variables returned by: \n  c.RequiredVariables \nVariable formats (e.g. matrix/vector, datatype) must match the original training data. \nAdditional variables are ignored. \n \nFor more information, see <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appclassification_exportmodeltoworkspace'')">How to predict using an exported model</a>.');
    
    % Perform cross-validation
    partitionedModel = crossval(trainedClassifier.ClassificationKNN, 'KFold', 5);
    
    % Compute validation accuracy
    validationAccuracy = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError');
end