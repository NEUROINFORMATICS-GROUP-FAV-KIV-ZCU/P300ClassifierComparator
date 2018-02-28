function  [model, train_time] = train_artmap(out_features, out_targets);

    ccInput = ART_Complement_Code(out_features);
    net = ARTMAP_Create_Network(size(ccInput, 1), 2);
    net.maxNumCategories = 30;
    net.numEpochs = 100;
    net.vigilance = 0.1;
    net.epsilon  = 0.001;
    %net.beta     = 0.5;
    net.learningRate = 0.05;
    
    timea = tic;
    model = ARTMAP_Learn(net, ccInput, out_targets(1,:));
    train_time = toc(timea);
   
    
    