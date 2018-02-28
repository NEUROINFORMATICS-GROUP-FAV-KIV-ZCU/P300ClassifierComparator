% ARTMAPExample.m
% Aaron Garrett
%
% This script uses the ARTMAP network to learn the exclusive-or (XOR) function.


% Set up the input and supervisory signal for the XOR function.
input = [1, 1, 0, 0;
         1, 0, 1, 0];

sup = [0, 1, 1, 0];


% Complement-code the input.
ccInput = ART_Complement_Code(input);

% This produces a matrix like the following:
%
% ccInput =
%
%      1     1     0     0
%      0     0     1     1
%      1     0     1     0
%      0     1     0     1


% Create the ARTMAP network that takes 4 inputs and allows 2 classes (i.e., T and F).
net = ARTMAP_Create_Network(4, 2);

% This produces a network like the following:
%
% net = 
%
%          numFeatures: 4
%        numCategories: 0
%     maxNumCategories: 100
%           numClasses: 2
%               weight: [4x0 double]
%             mapField: []
%            vigilance: 0.7500
%                 bias: 1.0000e-006
%            numEpochs: 100
%         learningRate: 1



% Train the network on the input and supervisor.
newNet = ARTMAP_Learn(net, ccInput, sup);

% This produces an output like the following:
%
% newNet = 
% 
%          numFeatures: 4
%        numCategories: 4
%     maxNumCategories: 100
%           numClasses: 2
%               weight: [4x4 double]
%             mapField: [0 1 1 0]
%            vigilance: 0.7500
%                 bias: 1.0000e-006
%            numEpochs: 100
%         learningRate: 1



% Now that the network has been trained, we can
% use it to classify inputs.

% The first input should result in a classification of 0.
% The second input should result in a classification of -1, since 
% the network has never seen one similar to it before.
newInput = [1, 0.5; 1, 0.5];
ccNewInput = ART_Complement_Code(newInput);
class = ARTMAP_Classify(newNet, ccNewInput);

% This produces an output of
%
% class =
%
%      0    -1

