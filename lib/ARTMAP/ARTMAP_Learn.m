function new_artmap_network = ARTMAP_Learn(artmap_network, data, supervisor)
% ARTMAP_Learn    Trains an ARTMAP network on the given input data.
%    NEW_ARTMAP_NETWORK = ARTMAP_Learn(ARTMAP_NETWORK, DATA, SUPERVISOR)
%    This function trains an ARTMAP network on the given input data. Each sample
%    of the data is presented to the network, which categorizes each sample
%    and compares that category's entry in the map field to the supervisor signal.
%    If the map field value and the supervisor signal do not match, match-tracking
%    is induced until a category is found to code the input correctly. This
%    category then learns the input vector.
%
%    The function returns a new ARTMAP network which has learned the input data
%    according to the supervisor signal. If the maximum number of categories 
%    is reached and an appropriate categorization of the input cannot be made,
%    no learning occurs. The program prints out a warning message that the 
%    maximum category limit has been reached and begins to process the next
%    input vector.
% 
%    The input parameters are as follows:
%    The ARTMAP_NETWORK is the ARTMAP network to be trained. It should be created
%    with ARTMAP_Create_Network(). The DATA is the training data to be presented
%    to the network. It is a matrix of size NumFeatures-by-NumSamples. The
%    SUPERVISOR is the correct classification for each input vector. It is a
%    matrix of size 1-by-NumSamples.
%
%    The return parameters are as follows:
%    The NEW_ARTMAP_NETWORK is a new ARTMAP network which has learned the input data.


% Make sure the user specifies the input parameters.
if(nargin ~= 3)
    error('You must specify all 3 input parameters.');
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

% Make sure that the number of epochs is a positive integer.
if(artmap_network.numEpochs < 1)
    error('The number of epochs must be a positive integer.');
end

% Set up the return variables.
new_artmap_network = {};


% Go through the data once for every epoch.
for epochNumber = 1:artmap_network.numEpochs
        
    % This variable will allow us to keep up with the total
    % network change due to learning.
    % Initialize the number of changes to 0.
    numChanges = 0;
    
    % Classify and learn on each sample.
    for sampleNumber = 1:numSamples
        
        % Get the current data sample.
        currentData = data(:, sampleNumber);

        % Get the current supervisory signal.
        currentSupervisor = supervisor(1, sampleNumber);
    
        % Create a new category if this supervisory signal
        % has never been seen before.
        if(isempty(artmap_network.mapField) | isempty(find(artmap_network.mapField == currentSupervisor)))
            
            [resizedWeight, resizedMapField] = ARTMAP_Add_New_Category(artmap_network.weight, artmap_network.mapField);
            resizedWeight = ART_Update_Weights(currentData, resizedWeight, length(resizedMapField), artmap_network.learningRate);
            artmap_network.weight = resizedWeight;
            artmap_network.numCategories = artmap_network.numCategories + 1;
            resizedMapField(1, length(resizedMapField)) = currentSupervisor;
            artmap_network.mapField = resizedMapField;
            numChanges = numChanges + 1;
            continue;    
            
        else
        
           % Activate the categories for this sample.
            bias = artmap_network.bias;
            categoryActivation = ART_Activate_Categories(currentData, artmap_network.weight, bias);
            
            % Rank the activations in order from highest to lowest.
            % This will allow us easier access to step through the categories.
            [sortedActivations, sortedCategories] = sort(-categoryActivation);
            
            % Go through the process of locating the highest activated category
            % with the correct value in the map field for the supervisory signal.
            matchTracking = 1;
            vigilance = artmap_network.vigilance;
	
            % Go through each category in the sorted list looking for the best match.
            resonance = 0;
            match = 0;
            numSortedCategories = length(sortedCategories);
            currentSortedIndex = 1;
            while(~resonance)
                
                % Get the current category based on the sorted index.
                currentCategory = sortedCategories(currentSortedIndex);
                
                % Get the current weight vector from the sorted category list.
                currentWeightVector = artmap_network.weight(:, currentCategory);
                
                % Calculate the match given the current data sample and weight vector.
                match = ART_Calculate_Match(currentData, currentWeightVector);
                
                % Check to see if the match is less than the vigilance.
                if(match < vigilance)
                    
                    % If so, choose the next category in the sorted category list.
                    % If the current category is the last in the list, make sure that
                    % the maximum number of categories have not been reached. If the 
                    % maximum has not been reached, create a new category for the input, 
                    % update the weights, and induce resonance.
                    if(currentSortedIndex == numSortedCategories)
                        if(currentSortedIndex == artmap_network.maxNumCategories)
                            fprintf('WARNING: The maximum number of categories has been reached.\n');
                            resonance = 1;
                        else
                            [resizedWeight, resizedMapField] = ARTMAP_Add_New_Category(artmap_network.weight, artmap_network.mapField);
                            [resizedWeight, weightChange] = ART_Update_Weights(currentData, resizedWeight, currentSortedIndex + 1, artmap_network.learningRate);
                            artmap_network.weight = resizedWeight;
                            artmap_network.numCategories = artmap_network.numCategories + 1;
                            resizedMapField(1, currentSortedIndex + 1) = currentSupervisor;
                            artmap_network.mapField = resizedMapField;

                            % Increment the number of changes since we added a new category.
                            numChanges = numChanges + 1;
                            
                            resonance = 1;
                        end
                    else
                        currentSortedIndex = currentSortedIndex + 1;
                    end 
                    
                else 
                    
                    % Otherwise, check the category's value in the map field.
                    if(artmap_network.mapField(1, currentCategory) == currentSupervisor)
                        % If they're equal, the category should code the input.
                        % Therefore, we should update the weights and induce resonance.
                        [artmap_network.weight, weightChange] = ART_Update_Weights(currentData, artmap_network.weight, currentCategory, artmap_network.learningRate);

                        if(weightChange == 1)
                            numChanges = numChanges + 1;
                        end

                        resonance = 1;
                    else
                        % If they're not equal, we must find another category by
                        % inducing match-tracking. This means that we should increase
                        % the vigilance by the current match plus epsilon and then 
                        % continue through the category list until another match is
                        % found.
                        vigilance = match + 0.000001;
                        if(currentSortedIndex == numSortedCategories)
                            if(currentSortedIndex == artmap_network.maxNumCategories)
                                fprintf('WARNING: The maximum number of categories has been reached.\n');
                                resonance = 1;
                            else
                                [resizedWeight, resizedMapField] = ARTMAP_Add_New_Category(artmap_network.weight, artmap_network.mapField);
                                [resizedWeight, weightChange] = ART_Update_Weights(currentData, resizedWeight, currentSortedIndex + 1, artmap_network.learningRate);
                                artmap_network.weight = resizedWeight;
                                artmap_network.numCategories = artmap_network.numCategories + 1;
                                resizedMapField(1, currentSortedIndex + 1) = currentSupervisor;
                                artmap_network.mapField = resizedMapField;
                                
                                % Increment the number of changes since we added a new category.
                                numChanges = numChanges + 1;
                                
                                resonance = 1;
                            end
                        else
                            currentSortedIndex = currentSortedIndex + 1;
                            resonance = 0;
                        end
                    end      % if(artmap_network.mapField(1, currentCategory) == currentSupervisor)
                end      % if(match < vigilance)
            end      % while(~resonance)
        end      % if(isempty(artmap_network.mapField) | isempty(find(artmap_network.mapField == currentSupervisor)))
    end      % for sampleNumber = 1:numSamples
    
    % If the network didn't change at all during the last epoch,
    % then we've reached equilibrium. Thus, we can stop training.
    if(numChanges == 0)
        break;
    end

end      % for epochNumber = 1:artmap_network.numEpochs


fprintf('The number of epochs needed was %d\n', epochNumber);

% Fill the new network with the appropriate values.
new_artmap_network = artmap_network;

return