function [resizedWeight, resizedMapField] = ARTMAP_Add_New_Category(weight, mapField)
% ARTMAP_Add_New_Category    Adds a new category to the given weight matrix and map field.
%    [RESIZEDWEIGHT, RESIZEDMAPFIELD] = ARTMAP_Add_New_Category(WEIGHT, MAPFIELD)
%    This function returns a new weight matrix which is identical to the
%    given weight matrix except that it contains one more category which
%    is initialized to all 1's. It also returns a new map field matrix
%    which is identical to the given map field matrix except that it contains
%    one more element initialized to 0.
% 
%    The input parameters are as follows:
%    The WEIGHT is a matrix of size NumFeatures-by-NumCategories which
%    holds the weights of the network. The MAPFIELD is a matrix of size
%    1-by-NumCategories which holds the associations between categories
%    and classes.
%
%    The return parameters are as follows:
%    The RESIZEDWEIGHT is a matrix of size NumFeatures-by-NumCategories+1
%    which holds the weights of the old matrix plus a new category of all
%    values of 1. The RESIZEDMAPFIELD is a matrix of size 1-by-NumCategories+1
%    which holds the given map field matrix except that it contains
%    one more element initialized to 0.


% Make sure that the user specified the weight and map field matrices.
if(nargin ~= 2)
    error('You must specify the weight and map field parameters.');    
end

% Create the return weight matrix with the right dimensions.
[numFeatures, numCategories] = size(weight);
newCategory = ones(numFeatures, 1);
resizedWeight = [weight, newCategory];

% Create the return map field matrix with the right dimensions.
resizedMapField = [mapField, 0];


return