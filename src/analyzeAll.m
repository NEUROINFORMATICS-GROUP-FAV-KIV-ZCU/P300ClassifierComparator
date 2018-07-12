% Main script to run. It analyzes datasets defined by base_dir, conditions
% and number_of_participants parameters.
close all;
%clearvars averages;
base_dir = 'E:\eeg_data\Anonymize\'; % directory that contains training and testing data

param = configParam();

train_dirs    = {[base_dir, '95\Data\'];   [base_dir, '96\Data\'];    [base_dir, '99\Data\'];   [base_dir, '100\Data\'];    [base_dir, '102\Data\'];   [base_dir, '104\Data\'];   [base_dir, '105\Data\'];   [base_dir, '106\Data\']};
train_files   = { 'LED_04_06_2012_95.vhdr';  'LED_04_06_2012_96.vhdr';  'LED_05_06_2012_99.vhdr'; 'LED_05_06_2012_100.vhdr';  'LED_06_06_2012_102.vhdr'; 'LED_28_06_2012_104.vhdr'; 'LED_28_06_2012_105.vhdr'; 'LED_28_06_2012_106.vhdr'};
param.train_ids = {'95', '96', '99', '100', '102', '104', '105', '106'};


test_dirs    = {[base_dir, '85\Data\']; [base_dir, '86\Data\']; [base_dir, '87\Data\'];  [base_dir, '91\Data\']; [base_dir, '92\Data\']; [base_dir, '93\Data\']; [base_dir, '94\Data\']; [base_dir, '97\Data\']; [base_dir, '98\Data\'];  [base_dir, '101\Data\']; [base_dir, '103\Data\']};
test_files   = { 'LED_22_05_2012_85.vhdr'; 'LED_22_05_2012_86.vhdr'; 'LED_28_05_2012_87.vhdr'; 'LED_29_05_2012_91.vhdr'; 'LED_29_05_2012_92.vhdr'; 'LED_29_05_2012_93.vhdr'; 'LED_04_06_2012_94.vhdr'; 'LED_05_06_2012_97.vhdr'; 'LED_05_06_2012_98.vhdr'; 'LED_06_06_2012_101.vhdr'; 'LED_06_06_2012_103.vhdr'};
param.test_ids = { '85', '86', '87', '91', '92', '93', '94', '97', '98', '101', '103'};

% add descriptions for each column
number_of_participants = length(test_files);
allresults = struct;

for j = 1:length(param.metrics)
    allresults.(param.metrics{j})   = cell(number_of_participants + 1, length(param.classifiers));

    % results headlines
    for i = 1:length(param.classifiers)
        allresults.(param.metrics{j}){1, i}  = ['Test-', param.classifiers{i}, '-', param.metrics{j}, ' (%)'];
    end
end


[bestmodels, global_resultsTrain, resultsTrain, param] = runTraining(train_dirs, train_files, param);
validationResults = struct;
for i = 1:length(param.classifiers)
    classifier = param.classifiers{i};
    validationResults.(classifier) = struct;
    
    for j =  1:length(param.metrics)
        validationResults.(classifier).(param.metrics{j})  = mean(global_resultsTrain.(classifier)(:, j));
    end
end

testing_data = struct;

% store y values for statistical comparisons
allresults.y = struct;
% init
for i = 1:length(param.classifiers)
    allresults.y.(param.classifiers{i}) = [];
end
allresults.y.real = [];

for i = 1:length(test_files) % iterate over participants
    % testing
    [results, global_results, test_out_features, test_out_targets, param] = runTesting( test_dirs{i}, test_files{i}, bestmodels, param);
    testing_data.(['features_', test_files{i}(end-6:end-5)]) = test_out_features;
    testing_data.([ 'targets_', test_files{i}(end-6:end-5)]) = test_out_targets;
    
    % store results into a cell matrix
    for j = 1:length(param.classifiers)
        classifier = param.classifiers{j};
        for k =  1:length(param.metrics)
            allresults.(param.metrics{k}){i + 1, j}   = results.(classifier).(param.metrics{k});
        end
        % join results
        allresults.y.(classifier) = [allresults.y.(classifier) results.(classifier).y];
    end    
    allresults.y.real = [allresults.y.real results.yreal];
   
end

% average results across all tested subjects
for j = 1:length(param.classifiers)
    accuracy  = mean([allresults.accuracy{2:(length(test_files) + 1) , j}]);
    precision = mean([allresults.precision{2:(length(test_files) + 1) , j}]);
    recall    = mean([allresults.recall{2:(length(test_files) + 1) , j}]);
    classifier = param.classifiers{j};
    
    if exist('averages')
        averages = [averages, accuracy];
    else
        averages = accuracy;
    end
    str = sprintf('%s average accuracy: %.3f %%, precision: %.3f %% recall: %.3f %%', classifier, accuracy * 100, precision * 100, recall * 100);
    disp(str);
end
    


single_trial_analysis(param);

%plotResults(allresults, averages, param)

% save data to be later evaluated e.g. by Python deep learning
% libraries, such as Keras
%save('testing.mat', '-v7.3', 'testing_data');