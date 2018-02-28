% Tests SOM1 classifier
function  [results] = test_som1_classifier(out_features, out_targets, som_model);

    neurons_stats = som_model.neurons_stats;
    som_clusters  = som_model.som_clusters;

    times = tic;
    bmus = som_bmus(som_clusters, out_features');

    % Evaluate classification results
    true_positives = 0;
    true_negatives = 0;
    false_positives = 0;
    false_negatives = 0;
    for i = 1:length(bmus)
        wneuronindex = bmus(i);
        realclass = max(out_targets(1, i), 0) + 1;

        % Compare classification score for target vs nontarget statistics
        nontargetscore = neurons_stats(1, wneuronindex);
        targetscore    = neurons_stats(2, wneuronindex);
        if (targetscore > nontargetscore)
            detectedclass = 2;
        else
            detectedclass = 1;
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

    % Calculate metrics
    results = struct;
    results.time = toc(times);
    results.tp = true_positives;
    results.tn = true_negatives;
    results.fp = false_positives;
    results.fn = false_negatives;
    results.y  = [];
    results.accuracy = (true_positives + true_negatives) / (true_positives + true_negatives + false_positives + false_negatives);
    results.precision = (true_positives) / (true_positives + false_positives);
    results.recall = (true_positives) / (true_positives + false_negatives);