function  [model, train_time] = trainfsnet(out_features, out_targets, param);

    % fuzzy ARTMAP network
    fsnet = create_network(size(out_features, 1));
    fsnet.epochs = param.sfam.epochs;
    
    fsnet.max_categories = param.sfam.max_categories; % 35
    fsnet.alpha = param.sfam.alpha; % 1 - recommended http://download.springer.com/static/pdf/674/art%253A10.1023%252FA%253A1026004816362.pdf?auth66=1406544474_d172c3f32c8fb08cbf35bbe1fa8b81c4&ext=.pdf
    fsnet.epsilon = param.sfam.epsilon; % recommended http://download.springer.com/static/pdf/674/art%253A10.1023%252FA%253A1026004816362.pdf?auth66=1406544474_d172c3f32c8fb08cbf35bbe1fa8b81c4&ext=.pdf
    fsnet.beta = param.sfam.beta; % slow learning - algorithm default settings
    fsnet.vigilance = param.sfam.vigilance;%0.75; % 0.1 - algorithm default settings
    
    
    % train the network
    trainf = tic;
    model = train(out_features', out_targets(1,:)', fsnet, 0); % 1 - verbose mode
    train_time = toc(trainf);
    