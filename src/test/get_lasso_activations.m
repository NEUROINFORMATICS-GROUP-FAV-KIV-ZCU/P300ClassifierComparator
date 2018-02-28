% Finds activation of neurons across the SOM network for the LASSO
% classification model
function  [activations] = get_lasso_activations(som_clusters, untagged_features, i, bmus, gridthreshold, relative_distance_threshold);

     wneuronindex = bmus(i, 1);
     codebook = som_clusters.codebook;
     winnerweightvectors = codebook(wneuronindex, :);

     % SOM - based class prediction - take the last part of the vector
     % predicting class
     activations = zeros(1, size(codebook, 1));
     feature_noclass = untagged_features(i, 1:(length(winnerweightvectors)- 1));
     winnerweightvectors_noclass = winnerweightvectors(1:(length(winnerweightvectors)- 1));

     % for each neuron in the som network
     for j = 1:size(codebook, 1)
         % test1 - distance on the SOM network, path length to the winning
         % neuron has to be smaller than a threshold
         % dD(j,j*) < SD 

         % test 2 - relative distance

         % relative distance test
         currweight_vector_noclass = codebook(j, 1:(length(winnerweightvectors)- 1));
         dist_input_weight_winner  = norm(winnerweightvectors_noclass - feature_noclass);
         dist_input_weight_current = norm(currweight_vector_noclass - feature_noclass);
         relative_distance_value         = (dist_input_weight_current^2 - dist_input_weight_winner^2) / dist_input_weight_winner^2;


         winnergridcoord = som_ind2sub(som_clusters, wneuronindex);
         currgridcoord = som_ind2sub(som_clusters, j);
         griddist = norm(winnergridcoord - currgridcoord);


         if (abs(relative_distance_value) > relative_distance_threshold || griddist > gridthreshold)
            activations(1, j) = 0;
         else
            activations(1, j) = dist_input_weight_winner ^ 2 / dist_input_weight_current^2;
         end
    %     if (j == wneuronindex)
    %         activations(1, j) = 1;
    %      else
    %         activations(1, j) = 0;
    %      end;
    end
 

     
    