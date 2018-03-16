% Perform multiple iterations of analyzeAll
% in order to obtain smoother results
param = config();
clear globalresults;
param.randomizer = rng(10, 'simdTwister'); % for reproducibility
maxiter = 1;    
accuracies = zeros(maxiter, length(param.classifiers));
precisions = zeros(maxiter, length(param.classifiers));
recalls    = zeros(maxiter, length(param.classifiers));

% for predefined number of iterations
for iter = 1:maxiter
    analyzeAll;
    
    % store individual results from the current iteration
    if exist('globalresults')
        for i = 1:length(test_files)
            for j = 1:length(param.classifiers)
                 for k =  1:length(param.metrics)
                     % store classification performance
                     globalresults.(param.metrics{k}){i + 1, j} = [globalresults.(param.metrics{k}){i + 1, j} allresults.(param.metrics{k}){i + 1, j}];
                 end
            end
        end
        
        for j = 1:length(param.classifiers)
              % store classification outputs to allow statistical
              % comparisons
              classifier = param.classifiers{j};
              globalresults.y.(classifier) = [globalresults.y.(classifier) allresults.y.(classifier)];
        end
        globalresults.y.real = [globalresults.y.real allresults.y.real];
    else
        globalresults = allresults;
    end
    
    % store results
    for j = 1:length(param.classifiers)
        accuracies(iter, j) = mean([allresults.accuracy{2:(length(test_files) + 1) , j}]);
        precisions(iter, j) = mean([allresults.precision{2:(length(test_files) + 1) , j}]);
        recalls(iter, j)    = mean([allresults.recall{2:(length(test_files) + 1) , j}]);
    end
    
end

% averages individual results across all iterations
globalresultsavg = globalresults;
for i = 1:length(test_files)
    for j = 1:length(param.classifiers)
        classifier = param.classifiers{j};
        for k =  1:length(param.metrics)
            globalresultsavg.(param.metrics{k}){i + 1, j} = mean(globalresults.(param.metrics{k}){i + 1, j});
        end
    end
end

% collect results statistics across all iterations
avgaccuracy  = zeros(1, length(param.classifiers));
avgprecision = zeros(1, length(param.classifiers));
avgrecall    = zeros(1, length(param.classifiers));
minaccuracy  = zeros(1, length(param.classifiers));
minprecision = zeros(1, length(param.classifiers));
minrecall    = zeros(1, length(param.classifiers));
maxaccuracy  = zeros(1, length(param.classifiers));
maxprecision = zeros(1, length(param.classifiers));
maxrecall    = zeros(1, length(param.classifiers));
stdaccuracy  = zeros(1, length(param.classifiers));
stdprecision = zeros(1, length(param.classifiers));
stdrecall    = zeros(1, length(param.classifiers));
for j = 1:length(param.classifiers)
        avgaccuracy(j)  = mean(accuracies(:, j));
        avgprecision(j) = mean(precisions(:, j));
        avgrecall(j)    = mean(recalls(:, j));
        
        minaccuracy(j) = min(accuracies(:, j));
        minprecision(j) = min(precisions(:, j));
        minrecall(j) = min(recalls(:, j));
        
        maxaccuracy(j) = max(accuracies(:, j));
        maxprecision(j) = max(precisions(:, j));
        maxrecall(j) = max(recalls(:, j));
        
        stdaccuracy(j) = std(accuracies(:, j));
        stdprecision(j) = std(precisions(:, j));
        stdrecall(j) = std(recalls(:, j));
        
        classifier = param.classifiers{j};
        str = sprintf('%s average accuracy: %.3f %% (%.3f %%), precision: %.3f %% (%.3f %%), recall: %.3f %% (%.3f %%)', classifier, avgaccuracy(j) * 100, stdaccuracy(j) * 100, avgprecision(j) * 100, stdprecision(j) * 100, avgrecall(j) * 100, stdrecall(j) * 100);
        disp(str);
end
 
% Plotting individual and average results
plotResults(globalresultsavg, avgaccuracy, param);

% Statistical comparision
[hmn1, pmn1, e11, e21] = testcholdout(globalresults.y.sae,globalresults.y.lda,globalresults.y.real, 'Alternative','greater')
[hmn2, pmn2, e12, e22] = testcholdout(globalresults.y.sae,globalresults.y.mlp,globalresults.y.real, 'Alternative','greater')
    
