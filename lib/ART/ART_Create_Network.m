function art_network = ART_Create_Network(numFeatures)
% ART_Create_Network    Creates a new ART network.
%    ART_NETWORK = ART_Create_Network(NUMFEATURES)
%    This function creates a new ART network with the specified number
%    features. The network is created to expand the number of categories
%    as needed. In this way, the ART network can grow to encompass new 
%    data according to the vigilance parameter, which defaults to 0.75.
%    The initial number of categories is set to 1. The maximum number
%    of categories defaults to 100. The bias defaults to 0.000001, the
%    number of epochs defaults to 100, and the learning rate defaults 
%    to 1.0 (fast-learning).
% 
%    The input parameters are as follows:
%    The NUMFEATURES is the number of features that the network expects
%    of the input data. This value must be an positive integer. 
%
%    The return parameter is as follows:
%    The ART_NETWORK is the structure that holds all of the information
%    for the network. It must be passed into both ART_LEARN() and 
%    ART_CATEGORIZE(). The fields of this structure are numFeatures,
%    numCategories, maxNumCategories, weight, vigilance, bias, numEpochs, 
%    and learningRate.


% Make sure that the user specified the required parameter.
if(nargin ~= 1)
    error('You must specify a number of features.');
end

% Check the ranges of the input parameters.
numFeatures = round(numFeatures);
if(numFeatures < 1)
    error('The number of features must be a positive integer.');
end

% Create and initialize the weight matrix.
weight = ones(numFeatures, 0);

% Create the structure and return.
art_network = struct('numFeatures', {numFeatures}, 'numCategories', {0}, 'maxNumCategories', {100}, 'weight', {weight}, ...
                     'vigilance', {0.75}, 'bias', {0.000001}, 'numEpochs', {100}, 'learningRate', {1.0});
    
                 
return

