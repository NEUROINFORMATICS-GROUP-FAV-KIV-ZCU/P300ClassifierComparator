function artmap_network = ARTMAP_Create_Network(numFeatures, numClasses)
% ARTMAP_Create_Network    Creates a new ARTMAP network.
%    ARTMAP_NETWORK = ARTMAP_Create_Network(NUMFEATURES, NUMCLASSES)
%    This function creates a new ARTMAP network with the specified number
%    features and classes. The network is created to expand the number of 
%    categories as needed. The vigilance parameter defaults to 0.75.
%    The initial number of categories is set to 1. The maximum number
%    of categories defaults to 100. The bias defaults to 0.000001, the
%    number of epochs defaults to 100, and the learning rate defaults 
%    to 1.0 (fast-learning).
% 
%    The input parameters are as follows:
%    The NUMFEATURES is the number of features that the network expects
%    of the input data. This value must be a positive integer. The
%    NUMCLASSES is the number of classes that exist for the supervisory
%    signal. This value must be a positive integer greater than 1.
%
%    The return parameter is as follows:
%    The ARTMAP_NETWORK is the structure that holds all of the information
%    for the network. It must be passed into both ARTMAP_LEARN() and 
%    ARTMAP_CLASSIFY(). The fields of this structure are numFeatures,
%    numCategories, maxNumCategories, numClasses, weight, mapField, 
%    vigilance, bias, numEpochs, and learningRate.


% Make sure that the user specified the required parameter.
if(nargin ~= 2)
    error('You must specify both input parameters.');
end

% Check the ranges of the input parameters.
numFeatures = round(numFeatures);
if(numFeatures < 1)
    error('The number of features must be a positive integer.');
end
numClasses = round(numClasses);
if(numClasses < 2)
    error('The number of classes must be a positive integer greater than 1.');
end

% Create and initialize the weight matrix.
weight = ones(numFeatures, 0);

% Create and initialize the map field.
mapField = zeros(0);

% Create the structure and return.
artmap_network = struct('numFeatures', {numFeatures}, 'numCategories', {0}, 'maxNumCategories', {100}, ...
                        'numClasses', {numClasses}, 'weight', {weight}, 'mapField', {mapField}, ...
                        'vigilance', {0.75}, 'bias', {0.000001}, 'numEpochs', {100}, 'learningRate', {1.0});
    
                 
return

