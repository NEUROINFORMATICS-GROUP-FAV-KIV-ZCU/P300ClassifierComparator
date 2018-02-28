% Performs a proper LASSO classification 
% as described in the paper:
% Midenet, Sophie & Grumbach, Alain. (1994). Learning Associations by Self-Organization: The LASSO model.. Neurocomputing. 6. 343-361. 10.1016/0925-2312(94)90069-8. 
function  [results] = test_lasso_classifier2(out_featurestest, out_targetstest, som_clusters, param)

    % set up the LASSO parameters
    grid_distance     = param.lasso.grid_distance;
    relative_distance = param.lasso.relative_distance;

    % prepare data structures
    unknown_targets = zeros(size(out_targetstest, 1), size(out_targetstest, 2));
    untagged_features = [out_featurestest', unknown_targets']; % feature space dimensionality + output dimensionality

    timel2 = tic;

    [bmus, ~] = som_bmus(som_clusters, untagged_features, 1:size(som_clusters.codebook, 1));
    true_positives = 0;
    true_negatives = 0;
    false_positives = 0;
    false_negatives = 0;

    output_pattern = 0;


    for i = 1:size(untagged_features, 1)

        % true - tagged value
        trueclasses = out_targetstest(:, i);

        %nontargetscore = neurons_stats(1, wneuronindex);
        %targetscore    = neurons_stats(2, wneuronindex);
        activations = get_lasso_activations(som_clusters, untagged_features, i, bmus, grid_distance, relative_distance);

        activationssum = 1 / (sum(activations));

        for j = 1: length(activations)
            output_pattern = output_pattern + activations(1, j) * som_clusters.codebook(j, size(untagged_features, 2):size(untagged_features, 2));
        end

        output_pattern = activationssum * output_pattern;


        if (output_pattern > 0)
            detectedclass = 2; % target
        else
            detectedclass = 1;
        end

        if (trueclasses > 0)
            realclass = 2; % target
        else
            realclass = 1;
        end
        if (realclass == detectedclass && realclass == 1)
            true_negatives = true_negatives + 1;
        elseif (realclass == detectedclass && realclass == 2)
            true_positives = true_positives + 1;
        elseif (realclass ~= detectedclass && realclass == 1)
            false_positives = false_positives + 1;
        else
            false_negatives = false_negatives + 1;
        end
    end

    results = struct;
    results.time = toc(timel2);
    results.tp = true_positives;
    results.tn = true_negatives;
    results.fp = false_positives;
    results.fn = false_negatives;
    results.y  = [];
    results.accuracy = (true_positives + true_negatives) / (true_positives + true_negatives + false_positives + false_negatives);
    results.precision = (true_positives) / (true_positives + false_positives);
    results.recall = (true_positives) / (true_positives + false_negatives);