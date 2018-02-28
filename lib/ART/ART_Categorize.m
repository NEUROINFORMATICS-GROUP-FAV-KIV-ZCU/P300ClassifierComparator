function categorization = ART_Categorize(art_network, data)
% ART_Categorize    Uses an ART network to categorize the given input data.
%    CATEGORIZATION = ART_Categorize(ART_NETWORK, DATA)
%    This function uses an ART network to categorize the given input data with 
%    the specified vigilance parameter. Each sample of the data is presented to
%    the network, which categorizes each sample. The function returns the 
%    categorization of each sample. If the categorization of the sample requires
%    that a new category be created, the category for that sample is set to -1.
% 
%    The input parameters are as follows:
%    The ART_NETWORK is the trained ART network. It should be created with
%    ART_Create_Network(). The DATA is the categorization data to be presented
%    to the network. It is a matrix of size NumFeatures-by-NumSamples. 
%
%    The return parameters are as follows:
%    The CATEGORIZATION is a vector of size NumSamples that holds the 
%    category in which the ART network placed each sample.


% Make sure the user specifies the input parameters.
if(nargin ~= 2)
    error('You must specify both input parameters.');
end

% Make sure that the data is appropriate for the given network.
[numFeatures, numSamples] = size(data);
if(numFeatures ~= art_network.numFeatures)
    error('The data does not contain the same number of features as the network.');
end

% Make sure the vigilance is within the (0, 1] range.
if((art_network.vigilance <= 0) | (art_network.vigilance > 1))
    error('The vigilance must be within the range (0, 1].');
end

% Set up the return variables.
categorization = ones(1, numSamples);

% Classify and learn on each sample.
for sampleNumber = 1:numSamples
    
    % Get the current data sample.
    currentData = data(:, sampleNumber);
    
    % Activate the categories for this sample.
    bias = art_network.bias;
    categoryActivation = ART_Activate_Categories(currentData, art_network.weight, bias);
    
    % Rank the activations in order from highest to lowest.
    % This will allow us easier access to step through the categories.
    [sortedActivations, sortedCategories] = sort(-categoryActivation);
    
    % Go through each category in the sorted list looking for the best match.
    resonance = 0;
    match = 0;
    numSortedCategories = length(sortedCategories);
    currentSortedIndex = 1;
    while(~resonance)
        
        % Get the current category based on the sorted index.
        currentCategory = sortedCategories(currentSortedIndex);
        
        % Get the current weight vector from the sorted category list.
        currentWeightVector = art_network.weight(:, currentCategory);
        
        % Calculate the match given the current data sample and weight vector.
        match = ART_Calculate_Match(currentData, currentWeightVector);
        
        % Check to see if the match is greater than the vigilance.
        if((match > art_network.vigilance) | (match >= 1))
            % If so, the current category codes the input.
            % Therefore, we should induce resonance.
            categorization(1, sampleNumber) = currentCategory;
            resonance = 1;            
        else
            % Otherwise, choose the next category in the sorted category list.
            % If the current category is the last in the list, set the 
            % category for the return value as -1 and induce resonance.
            if(currentSortedIndex == numSortedCategories)
                categorization(1, sampleNumber) = -1;            
                resonance = 1;
            else
                currentSortedIndex = currentSortedIndex + 1;
            end            
        end
    end    
end


return