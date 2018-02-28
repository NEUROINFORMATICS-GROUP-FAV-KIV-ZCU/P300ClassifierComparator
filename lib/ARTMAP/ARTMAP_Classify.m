function classification = ARTMAP_Classify(artmap_network, data)
% ARTMAP_Classify    Uses an ARTMAP network to classify the given input data.
%    CLASSIFICATION = ARTMAP_Classify(ARTMAP_NETWORK, DATA)
%    This function uses an ARTMAP network to classify the given input data with 
%    the specified vigilance parameter. Each sample of the data is presented to
%    the network, which classifies each sample. The function returns the 
%    classification of each sample. If the classification of the sample requires
%    that a new category be created, the class for that sample is set to -1.
% 
%    The input parameters are as follows:
%    The ARTMAP_NETWORK is the trained ARTMAP network. It should be created
%    with ARTMAP_Create_Network(). The DATA is the classification data to be 
%    presented to the network. It is a matrix of size NumFeatures-by-NumSamples. 
%
%    The return parameters are as follows:
%    The CLASSIFICATION is a vector of size NumSamples that holds the 
%    class in which the ARTMAP network placed each sample.


% Make sure the user specifies the input parameters.
if(nargin ~= 2)
    error('You must specify both input parameters.');
end

% Make sure that the data is appropriate for the given network.
[numFeatures, numSamples] = size(data);
if(numFeatures ~= artmap_network.numFeatures)
    error('The data does not contain the same number of features as the network.');
end

% Make sure the vigilance is within the (0, 1] range.
if((artmap_network.vigilance <= 0) | (artmap_network.vigilance > 1))
    error('The vigilance must be within the range (0, 1].');
end

% Set up the return variables.
classification = zeros(1, numSamples);

% Classify and learn on each sample.
for sampleNumber = 1:numSamples
    
    % Get the current data sample.
    currentData = data(:, sampleNumber);
    
    % Activate the categories for this sample.
    bias = artmap_network.bias;
    categoryActivation = ART_Activate_Categories(currentData, artmap_network.weight, bias);
    
    % Rank the activations in order from highest to lowest.
    % This will allow us easier access to step through the categories.
    [sortedActivations, sortedCategories] = sort(-categoryActivation);
    
    % Go through each category in the sorted list looking for the best match.
    resonance = 0;
    match = 0;
    numSortedCategories = length(sortedCategories);
    currentSortedIndex = 1;
    while(~resonance)
        
        % If there are no categories, we return a -1.
        if(numSortedCategories == 0)
            classification(1, sampleNumber) = -1;
            resonance = 1;
            break;
        end

        % Get the current category based on the sorted index.
        currentCategory = sortedCategories(currentSortedIndex);
        
        % Get the current weight vector from the sorted category list.
        currentWeightVector = artmap_network.weight(:, currentCategory);
        
        % Calculate the match given the current data sample and weight vector.
        match = ART_Calculate_Match(currentData, currentWeightVector);
        
        % Check to see if the match is less than the vigilance.
        if(match < artmap_network.vigilance)
            
            % If so, choose the next category in the sorted category list.
            % If the current category is the last in the list, set the 
            % category for the return value as -1 and induce resonance.
            if(currentSortedIndex == numSortedCategories)
                classification(1, sampleNumber) = -1;
                resonance = 1;
            else
                currentSortedIndex = currentSortedIndex + 1;
            end            
            
        else

            % Otherwise, the current category codes the input.
            % Therefore, we should induce resonance.
            classification(1, sampleNumber) = artmap_network.mapField(1, currentCategory);
            resonance = 1;            
            
        end
    end    
end


return