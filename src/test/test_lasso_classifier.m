% Test the LASSO classification
function  [results] = test_lasso_classifier(out_featurestest, out_targetstest, som_clusters);
    unknown_targets = zeros(size(out_targetstest, 1), size(out_targetstest, 2));
    untagged_features = [out_featurestest', unknown_targets'];
    size(untagged_features)
    size(som_clusters.codebook)
    bmus = som_bmus(som_clusters, untagged_features);
    true_positives = 0;
    true_negatives = 0;
    false_positives = 0;
    false_negatives = 0;
    timel = tic;

    for (i = 1:length(bmus))
        wneuronindex = bmus(i);
        %out_targetstest(:, i))
        wneuronvalues = som_clusters.codebook(wneuronindex,:);

        % SOM - based class prediction
        wneuronvalues = wneuronvalues(length(wneuronvalues):length(wneuronvalues));

        % true - tagged value
        trueclasses = out_targetstest(:, i);

        %nontargetscore = neurons_stats(1, wneuronindex);
        %targetscore    = neurons_stats(2, wneuronindex);
        if (wneuronvalues > 0)
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
    results.time = toc(timel);
    results.tp = true_positives;
    results.tn = true_negatives;
    results.fp = false_positives;
    results.fn = false_negatives;
    results.y = [];
    results.accuracy = (true_positives + true_negatives) / (true_positives + true_negatives + false_positives + false_negatives);
    results.precision = (true_positives) / (true_positives + false_positives);
    results.recall = (true_positives) / (true_positives + false_negatives);