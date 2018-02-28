% Train multi-lazer perceptron with parameters
% corresponding to the setting of stacked autoencoder
% excluding unsupervised pre-training
function  [net, train_time] = trainmlp(out_features, out_targets, param)
    timem = tic;
    net = patternnet([param.sae.neurons_1, param.sae.neurons_2, param.sae.neurons_3]);
    net.layers{1}.transferFcn = param.sae.TransferFunction;
    net.layers{2}.transferFcn = param.sae.TransferFunction;
    net.layers{1}.transferFcn = param.sae.TransferFunction;
   
    net.performFcn = param.sae.performFcn;
    net.divideFcn = '';
    net.trainParam.epochs = param.sae.finetuneIter;
        
    if param.showTraining == 'true'
        net.trainParam.showWindow=1;
    else
        net.trainParam.showWindow=0;
    end
    [net] = train(net, out_features, out_targets);
    train_time = toc(timem);
  %  view(net);


