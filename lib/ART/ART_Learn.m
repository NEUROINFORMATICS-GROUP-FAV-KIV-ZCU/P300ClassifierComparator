function [new_art_network, categorization] = ART_Learn(art_network, data)
% ART_Learn    Trains an ART network on the given input data.
%    [NEW_ART_NETWORK, CATEGORIZATION] = ART_Learn(ART_NETWORK, DATA)
%    This function trains an ART network on the given input data. Each sample
%    of the data is presented to the network, which categorizes and learns 
%    for each sample. The function returns a new ART network which has learned
%    the input data, along with the categorization of each sample. If the
%    maximum number of categories is reached and an element should be classified
%    by a new category that cannot be created, the category is set to -1.
% 
%    The input parameters are as follows:
%    The ART_NETWORK is the ART network to be trained. It should be created
%    with ART_Create_Network(). The DATA is the training data to be presented
%    to the network. It is a matrix of size NumFeatures-by-NumSamples. 
%
%    The return parameters are as follows:
%    The NEW_ART_NETWORK is a new ART network which has learned the input data.
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

% Make sure that the number of epochs is a positive integer.
if(art_network.numEpochs < 1)
    error('The number of epochs must be a positive integer.');
end

% Set up the return variables.
new_art_network = {};
categorization = ones(1, numSamples);


% Go through the data once for every epoch.
for epochNumber = 1:art_network.numEpochs
        
    % This variable will allow us to keep up with the total
    % network change due to learning.
    % Initialize the number of changes to 0.
    numChanges = 0;
    
    % Classify and learn on each sample.
    for sampleNumber = 1:numSamples
        
        % Get the current data sample.
        currentData = data(:, sampleNumber);
        
        % Activate the categories for this sample.
        % This is equivalent to bottom-up processing in ART.
        bias = art_network.bias;
        categoryActivation = ART_Activate_Categories(currentData, art_network.weight, bias);
        
        % Rank the activations in order from highest to lowest.
        % This will allow us easier access to step through the categories.
        [sortedActivations, sortedCategories] = sort(-categoryActivation);
        
        % Go through each category in the sorted list looking for the best match.
        % This is equivalent to bottom-up--top-down processing in ART.
        resonance = 0;
        match = 0;
        numSortedCategories = length(sortedCategories);
        currentSortedIndex = 1;
        while(~resonance)
            
            % If there are no categories yet, we must create one.
            if(numSortedCategories == 0)
                resizedWeight = ART_Add_New_Category(art_network.weight);
                [resizedWeight, weightChange] = ART_Update_Weights(currentData, resizedWeight, ...
                                                                   1, art_network.learningRate);
                art_network.weight = resizedWeight;
                art_network.numCategories = art_network.numCategories + 1;
                categorization(1, sampleNumber) = 1;
                numChanges = numChanges + 1;
                resonance = 1;
                break;
            end
            
            % Get the current category based on the sorted index.
            currentCategory = sortedCategories(currentSortedIndex);
            
            % Get the current weight vector from the sorted category list.
            currentWeightVector = art_network.weight(:, currentCategory);
            
            % Calculate the match given the current data sample and weight vector.
            match = ART_Calculate_Match(currentData, currentWeightVector);
            
            % Check to see if the match is greater than the vigilance.
            if((match > art_network.vigilance) | (match >= 1))
                % If so, the current category should code the input.
                % Therefore, we should update the weights and induce resonance.
                [art_network.weight, weightChange] = ART_Update_Weights(currentData, art_network.weight, ...
                                                                        currentCategory, art_network.learningRate);
                categorization(1, sampleNumber) = currentCategory;
                
                % If there was a change, increment our counter.
                if(weightChange == 1)
                    numChanges = numChanges + 1;
                end
                
                resonance = 1;            
            else
                % Otherwise, choose the next category in the sorted category list.
                % If the current category is the last in the list, make sure that
                % the maximum number of categories has not been reached. If so,
                % assign the input a category of -1. If the maximum has not been
                % reached, create a new category for the input, update the weights, 
                % and induce resonance.
                if(currentSortedIndex == numSortedCategories)
                    if(currentSortedIndex == art_network.maxNumCategories)
                        categorization(1, sampleNumber) = -1;
                        resonance = 1;
                    else
                        resizedWeight = ART_Add_New_Category(art_network.weight);
                        [resizedWeight, weightChange] = ART_Update_Weights(currentData, resizedWeight, ...
                                                                           currentSortedIndex + 1, art_network.learningRate);
                        art_network.weight = resizedWeight;
                        art_network.numCategories = art_network.numCategories + 1;
                        categorization(1, sampleNumber) = currentSortedIndex + 1;
                        numChanges = numChanges + 1;
                        resonance = 1;
                    end
                else
                    currentSortedIndex = currentSortedIndex + 1;
                end            
            end
        end 
    end
    
    % If the network didn't change at all during the last epoch,
    % then we've reached equilibrium. Thus, we can stop training.
    if(numChanges == 0)
        break;
    end

end


fprintf('The number of epochs needed was %d\n', epochNumber);

% Fill the new network with the appropriate values.
new_art_network = art_network;

return