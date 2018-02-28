function match = ART_Calculate_Match(input, weightVector)
% ART_Calculate_Match    Calculates the match value of an input to a category.
%    MATCH = ART_Calculate_Match(INPUT, WEIGHTVECTOR)
%    This function returns a value which represents the amount of match
%    between the given input and the given category.
% 
%    The input parameters are as follows:
%    The INPUT is a vector of size NumFeatures that contains the input
%    signal into the network. The WEIGHTVECTOR is a matrix of size 
%    NumFeatures which holds the weights of the network for a given
%    category. The length of the INPUT vector must equal the length of
%    the WEIGHTVECTOR.
%
%    The return parameter is as follows:
%    The MATCH is a measure of the degree of match between the input
%    and the current category.


% Initialize the local variables.
match = 0;
numFeatures = length(input);

% Make sure the weight vector is appropriate for the input.
if(numFeatures ~= length(weightVector))
    error('The input and weight vector lengths do not match.');
end

% Calculate the match between the given input and weight vector.
% This is done according to the following equation:
%       Match = |Input^WeightVector| / |Input|
matchVector = min(input, weightVector);
inputLength = sum(input);
if(inputLength == 0)
    match = 0;
else
    match = sum(matchVector) / inputLength;
end

   
return