function  [results] = test_artmap(out_featurestest, out_targetstest, artmap);

    results = struct;
    results.tp = 0;
    results.tn = 0;
    results.fp = 0;
    results.fn = 0;
    results.y  = [];

    timea = tic;
    for i = 1:size(out_featurestest, 2)
        class = ARTMAP_Classify(artmap, ART_Complement_Code(out_featurestest(:, i)));
        results.y  = [results.y class];
        if (class == out_targetstest(1, i) && class > 0)
            results.tp = results.tp + 1;
        elseif (class == out_targetstest(1, i) && class <= 0)
            results.tn = results.tn + 1;
        elseif (class ~= out_targetstest(1, i) && class > 0)
            results.fp = results.fp + 1;
        elseif (class ~= out_targetstest(1, i) && class <= 0)
            results.fn = results.fn + 1;
        end
    end


    results.time = toc(timea);
    results.accuracy = (results.tp + results.tn) / (results.tp + results.tn + results.fp + results.fn);
    results.precision = (results.tp) / (results.tp + results.fp);
    results.recall = (results.tp) / (results.tp + results.fn);