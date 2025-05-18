function [selected_features, selected_indices] = select_features(features, response)
    % Преобразуем response в числовой формат, если это строки/категории
    if iscategorical(response) || iscell(response) || isstring(response)
        [~, ~, response_numeric] = unique(response);
    else
        response_numeric = response;
    end
    
    % Вычисляем значимость признаков (Maximum Separation Distance)
    [ranked_idx, scores] = rank_features(features, response_numeric);
    
    % Порог отбора (0.7 * максимальной значимости, как в статье)
    threshold = 0.7 * max(scores);
    selected_indices = ranked_idx(scores(ranked_idx) >= threshold);
    selected_features = features(:, selected_indices);
end

function [ranked_idx, scores] = rank_features(features, response)
    % Нормализуем признаки
    normalized_features = normalize(features, 'zscore');
    
    % Вычисляем межклассовое расстояние для каждого признака
    n_classes = max(response);
    scores = zeros(1, size(features, 2));
    
    for i = 1:size(features, 2)
        % Средние значения по классам
        class_means = zeros(1, n_classes);
        for c = 1:n_classes
            class_means(c) = mean(normalized_features(response == c, i));
        end
        
        % Maximum Separation Distance
        scores(i) = max(pdist(class_means'));
    end
    
    % Сортируем признаки по убыванию значимости
    [scores, ranked_idx] = sort(scores, 'descend');
end