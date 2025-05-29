function cfg = config()
    cfg = struct();
    mock_x = linspace(-5, 5, 100);
    mock_y = sin(mock_x);
    n = length(get_features(mock_y, 1, 1));
    cfg.n_features = n;
end