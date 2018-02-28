% Evaluate feature vectors using the trained stacked autoencoder
function [results ] = testsae2( deepnet, test_x, test_y )

    times = tic;
    y = deepnet(test_x);
    y = round(y);
    %plotconfusion(test_y,y);
    true_positives = sum(y(1,:) == 1 & (test_y(1,:)  == 1));
    true_negatives = sum(y(2,:) == 1 & (test_y(2,:)  == 1)); % = nontarget, puv hodnota 4
    false_positives = sum(y(1,:) == 1 & (test_y(2,:) == 1));
    false_negatives = sum(y(2,:) == 1 & (test_y(1,:) == 1)); % = nontarget, puv hodnota 4

    results = struct;
    results.time = toc(times);
    results.y = (y(1,:) == 1);
    results.tp = true_positives;
    results.tn = true_negatives;
    results.fp = false_positives;
    results.fn = false_negatives;
    if (true_positives + true_negatives + false_positives + false_negatives == 0)
        results.accuracy = 0;
    else
        results.accuracy = (true_positives + true_negatives) / (true_positives + true_negatives + false_positives + false_negatives);
    end
    if ((true_positives + false_positives) == 0)
        results.precision = 0;
    else
        results.precision = (true_positives) / (true_positives + false_positives);
    end
    if (true_positives + false_negatives == 0)
        results.recall = 0;
    else
        results.recall = (true_positives) / (true_positives + false_negatives);
    end

end

