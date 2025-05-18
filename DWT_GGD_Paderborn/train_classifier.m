function [trained_classifier, validation_accuracy] = train_classifier(training_data)
    %  Input:
    %      training_data: A table containing the same predictor and response
    %       columns as those imported into the app.
    %
    %  Output:
    %      trained_classifier: A struct containing the trained classifier. The
    %       struct contains various fields with information about the trained
    %       classifier.
    %
    %      trained_classifier.predictFcn: A function to make predictions on new
    %       data.
    %
    %      validation_accuracy: A double containing the accuracy as a
    %       percentage. In the app, the Models pane displays this overall
    %       accuracy score for each model.

    % Extract predictors and response
    % This code processes the data into the right shape for training the
    % model.
    input_table = training_data;
    
    var_names = training_data.Properties.VariableNames;
    var_names(end) = [];
    predictor_names = var_names;
    
    predictors = input_table(:, predictor_names);
    response = input_table.response;
    
    % Train a classifier
    % This code specifies all the classifier options and trains the classifier.
    classification_KNN = fitcknn(...
        predictors, ...
        response, ...
        'Distance', 'Minkowski', ...
        'Exponent', 3, ...
        'NumNeighbors', 10, ...
        'DistanceWeight', 'Equal', ...
        'Standardize', true, ...
        'ClassNames', {'Healthy'; 'IRDamage'; 'ORDamage'});
    
    % Create the result struct with predict function
    predictor_extraction_fcn = @(t) t(:, predictor_names);
    knn_predict_fcn = @(x) predict(classification_KNN, x);
    trained_classifier.predictFcn = @(x) knn_predict_fcn(predictor_extraction_fcn(x));
    
    % Add additional fields to the result struct
    trained_classifier.RequiredVariables = predictor_names;
    trained_classifier.ClassificationKNN = classification_KNN;
    trained_classifier.About = 'This struct is a trained model exported from Classification Learner R2022a.';
    trained_classifier.HowToPredict = sprintf('To make predictions on a new table, T, use: \n  yfit = c.predictFcn(T) \nreplacing ''c'' with the name of the variable that is this struct, e.g. ''trainedModel''. \n \nThe table, T, must contain the variables returned by: \n  c.RequiredVariables \nVariable formats (e.g. matrix/vector, datatype) must match the original training data. \nAdditional variables are ignored. \n \nFor more information, see <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appclassification_exportmodeltoworkspace'')">How to predict using an exported model</a>.');
    
    % Perform cross-validation
    partitioned_model = crossval(trained_classifier.ClassificationKNN, 'KFold', 5);
    
    % Compute validation accuracy
    validation_accuracy = 1 - kfoldLoss(partitioned_model, 'LossFun', 'ClassifError');
end