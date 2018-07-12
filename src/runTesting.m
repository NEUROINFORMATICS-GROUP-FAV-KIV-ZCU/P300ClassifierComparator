% Performs testing for all classifiers 
% assuming the models are already trained and validated.
% testing_dir - directory to read from
% testing_file - eeglab compatible file from testing_dir to read from
% models - trained classification models
% param  - global parameters
function [results, global_results, test_out_features, test_out_targets, param] = runTesting( testing_dir, testing_file, models, param)
    % extract trials
    [test_out_features, test_out_targets, param] = create_feature_vector(testing_dir, testing_file, param, 'testing'); % testing trials

    global_results = struct;
    results = struct;

    % reduce insignificant features
    if (param.reduceStat == 1)
        test_out_features = test_out_features(:, param.h == 1);
    end
   
    % testing
    [results.sae]     = testsae2(models.sae, test_out_features', test_out_targets');
    [results.mlp]     = testmlp( test_out_features', test_out_targets', models.mlp);
    [results.lda]     =  testlda(test_out_features', test_out_targets' == 1, models.lda);
    [results.som1]    = test_som1_classifier(test_out_features', test_out_targets(:, 1)', models.som1);
    [results.som2]  = test_som2_classifier(test_out_features', test_out_targets(:, 1)', models.som2);
    [results.lasso] = test_lasso_classifier2(test_out_features', test_out_targets(:, 1)', models.lasso, param);
  %  [results.sfam]  = testfsnet(test_out_features', test_out_targets(:, 1)', models.sfam);
    results.yreal = (test_out_targets(:, 1)' == 1);
    
end