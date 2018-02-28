function [updatedWeight, weightChange] = ART_Update_Weights(input, weight, categoryNumber, learningRate)
% ART_Update_Weights    Updates the weight matrix of an ART network.
%    [UPDATEDWEIGHT, WEIGHTCHANGE] = ART_Update_Weights(INPUT, WEIGHT, CATEGORYNUMBER, LEARNINGRATE)
%    This function returns a new weight matrix that has "learned" the input
%    in the given category, as well as a value correspoding to whether or 
%    not the weight matrix was changed (0 = no change; 1 = change).
% 
%    The input parameters are as follows:
%    The INPUT is a vector of size NumFeatures that contains the input
%    signal into the network. The WEIGHT is a matrix of size 
%    NumFeatures-by-NumCategories which holds the weights of the network.
%    The CATEGORYNUMBER is the number of the category that codes the 
%    current input. The LEARNINGRATE is the rate at which the network 
%    should learn new inputs. The length of the INPUT vector must equal
%    the number of rows in the WEIGHT matrix, the CATEGORYNUMBER must
%    be in the range [1, NumCategories], and the LEARNINGRATE must be
%    in the range [0, 1].
%
%    The return parameters are as follows:
%    The UPDATEDWEIGHT is a matrix of size NumFeatures-by-NumCategories
%    that holds the new weights of the network after the input has been
%    successfully learned.
%    The WEIGHTCHANGE is a value (0 or 1) which relays whether or not
%    the weight matrix was changed during this updating. Here, 0 represents
%    no change and 1 represents a change.


% Get the number of features from the weight matrix.
[numFeatures, numCategories] = size(weight);

% Check the input parameters for correct ranges.
if(length(input) ~= numFeatures)
    error('The length of the input and rows of the weights do not match.');
end
if((categoryNumber < 1) | (categoryNumber > numCategories))
    error('The category number must be in the range [1, NumCategories].');
end
if((learningRate < 0) | (learningRate > 1))
    error('The learning rate must be within the range [0, 1].');
end


% Modify the appropriate category of the weight matrix according to the following rule:
%
%    FOR EACH i IN input
%        IF input(i) < weight(i)(j) THEN
%            weight(i)(j) = (a * input(i)) + ((1 - a) * weight(i)(j))
%        ELSE
%            weight(i)(j) does not change
%        END IF
%    END FOR
%
% where "a" is the learning rate and "j" represents the appropriate category.
weightChange = 0;
for i = 1:numFeatures
    if(input(i) < weight(i, categoryNumber))
        weight(i, categoryNumber) = (learningRate * input(i)) + ((1 - learningRate) * weight(i, categoryNumber));
        weightChange = 1;
    end
end
    

% Return the updated weight matrix.
updatedWeight = weight;

return