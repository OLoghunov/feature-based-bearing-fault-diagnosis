function [ensemble, accuracy] = train_ensemble(training_data)
    predictors = training_data{:,1:end-1};
    response = training_data.response;
    
    % Standardization of data
    predictors = normalize(predictors, 'zscore');
    
    % Checking the number of classes
    if ~iscategorical(response)
        response = categorical(response);
    end
    n_classes = numel(categories(response));
    
    % Initialization of models
    models = {
        @() fitctree(predictors, response, 'MaxNumSplits', 10), ...
        @() fitcensemble(predictors, response, 'Method', 'Bag', 'Learners', 'tree', 'NumLearningCycles', 50), ...
        @() fitcecoc(predictors, response, 'Learners', 'svm', 'Coding', 'onevsone', 'Options', statset('UseParallel', true)), ... % Многоклассовый SVM
        @() fitcnet(predictors, response, 'LayerSizes', [20 10], 'Standardize', true), ...
        @() fitcknn(predictors, response, 'NumNeighbors', 5, 'Standardize', true)
    };
    
    % Cross-validation
    kfold = 5;
    cv = cvpartition(response, 'KFold', kfold);
    acc = zeros(kfold,1);
    
    for i = 1:kfold
        train_idx = cv.training(i);
        test_idx = cv.test(i);
        
        votes = zeros(sum(test_idx), numel(models));
        
        % Learning and Prediction
        for m = 1:numel(models)
            try
                model = models{m}();
                pred = predict(model, predictors(test_idx,:));
                votes(:,m) = double(pred == response(test_idx)); %1 if true, 0 if not
            catch ME
                warning('Model %d failed: %s', m, ME.message);
                votes(:,m) = 0;
            end
        end
        
        % Majority voting
        pred_accuracy = mean(votes, 2);
        acc(i) = mean(pred_accuracy);
    end
    
    accuracy = mean(acc)*100;
    
    % Final training on all data
    ensemble = cell(1, numel(models));
    for m = 1:numel(models)
        ensemble{m} = models{m}();
    end
end