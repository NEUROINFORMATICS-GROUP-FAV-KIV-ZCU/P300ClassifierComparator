input = [0.5, 0.3, 0.2, 0.91, 1.0;
         0.7, 0.4, 0.3, 0.55, 0.2];

     
ccInput = ART_Complement_Code(input);
% This produces a matrix like the following:
%
% ccInput =
% 
%     0.5000    0.3000    0.2000    0.9100    1.0000
%     0.5000    0.7000    0.8000    0.0900         0
%     0.7000    0.4000    0.3000    0.5500    0.2000
%     0.3000    0.6000    0.7000    0.4500    0.8000


net = ART_Create_Network(4);
% This produces a network like the following:
%
% net = 
% 
%          numFeatures: 4
%        numCategories: 1
%     maxNumCategories: 100
%               weight: [4x1 double]
%            vigilance: 0.7500
%                 bias: 1.0000e-006
%            numEpochs: 100
%         learningRate: 1


[newNet, cat] = ART_Learn(net, ccInput);
% This produces an output like the following:
%
% newNet = 
% 
%          numFeatures: 4
%        numCategories: 3
%     maxNumCategories: 100
%               weight: [4x3 double]
%            vigilance: 0.7500
%                 bias: 1.0000e-006
%            numEpochs: 100
%         learningRate: 1
%         
% cat =
% 
%      1     1     2     3     3


% Now that the network has been trained, we can
% use it to categorize a new input.

newInput = [0.2; 0.4];
ccNewInput = ART_Complement_Code(newInput);
newCat = ART_Categorize(newNet, ccNewInput);

% This produces an output of
%
% newCat =
% 
%      2

