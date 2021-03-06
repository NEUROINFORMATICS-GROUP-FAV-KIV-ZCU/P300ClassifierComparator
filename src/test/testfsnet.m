function  [results] = testfsnet(out_featurestest, out_targetstest, tnet);
    timef = tic;
    r = classify(out_featurestest', tnet, out_targetstest(1,:)', 10);
    results = struct;
    results.time = toc(timef);
    results.tp = sum(r' == out_targetstest(1,:)' & out_targetstest(1,:)' > 0);
    results.tn = sum(r' == out_targetstest(1,:)' & out_targetstest(1,:)' <= 0);
    results.fp = sum(r' ~= out_targetstest(1,:)' & out_targetstest(1,:)' <= 0);
    results.fn = sum(r' ~= out_targetstest(1,:)' & out_targetstest(1,:)' > 0);
    results.y  = r;
    results.accuracy = (results.tp + results.tn) / (results.tp + results.tn + results.fp + results.fn);
    results.precision = (results.tp) / (results.tp + results.fp);
    results.recall = (results.tp) / (results.tp + results.fn);