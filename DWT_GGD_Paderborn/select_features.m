function [selected_features, selected_indices] = select_features(features, response)
    if iscategorical(response) || iscell(response) || isstring(response)
        [~, ~, response_numeric] = unique(response);
    else
        response_numeric = response;
    end
    
    [ranked_idx, scores] = rank_features(features, response_numeric);
    
    threshold = 0.7 * max(scores);
    selected_indices = ranked_idx(scores(ranked_idx) >= threshold);
    selected_features = features(:, selected_indices);
end

function [ranked_idx, scores] = rank_features(features, response)
    normalized_features = normalize(features, 'zscore');
    
    n_classes = max(response);
    scores = zeros(1, size(features, 2));
    
    for i = 1:size(features, 2)
        class_means = zeros(1, n_classes);
        for c = 1:n_classes
            class_means(c) = mean(normalized_features(response == c, i));
        end
        
        scores(i) = max(pdist(class_means'));
    end
    
    [scores, ranked_idx] = sort(scores, 'descend');
end