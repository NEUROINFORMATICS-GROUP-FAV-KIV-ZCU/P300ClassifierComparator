% Validates the P300 data using P300 classification method
%
% Input:
% training_dir - directory containing training file(s)
% training_file- training dataset filename(s)
% test_dirs    - directories containing testing file(s)
% test_files   - testing dataset filename(s)
% param        - contains parameters for feature extraction and training   
function [results, models] = P300_train_val(out_features, out_targets, param);
    
    % shuffle the features and outputs in the same way
    %rng(param.randomizer);
    [out_features, y, ~] = shuffle(out_features, 1);
    out_targets = out_targets(y,:);

    % split selected percentage for training, the rest for validation
    training_size = round( size(out_features, 1) * (1 - param.validation));
    outf_train = out_features(1:training_size, :);
    outt_train = out_targets(1:training_size, :);
    outf_val = out_features((training_size + 1):size(out_features, 1), :);
    outt_val = out_targets((training_size + 1):size(out_targets, 1), :);
    
    % save for Python
    save('training.mat', '-v7.3', 'outf_train', 'outt_train', 'outf_val', 'outt_val');
        
    % train using the training dataset
    models = struct;
    results = struct;
    results.train_times = struct;
    
    [models.mlp, results.train_times.mlp]   =  trainmlp(outf_train', outt_train', param);
    [models.sae, results.train_times.sae]   =  trainsae2(outf_train', outt_train', param);
    [models.lda, results.train_times.lda]   =  trainlda(outf_train', outt_train' == 1, param);
    [models.som1, results.train_times.som1]  =  train_som1_classifier(outf_train', outt_train(:, 1)', param);
    [models.som2, results.train_times.som2]  =  train_som2_classifier(outf_train', outt_train(:, 1)', param);
    [models.lasso, results.train_times.lasso] =  train_lasso_classifier(outf_train', outt_train(:, 1)', param);
   % [models.sfam, results.train_times.sfam]  =  trainfsnet(outf_train', outt_train(:, 1)', param);


    % test the models
    results.mlp   = testmlp( outf_val', outt_val', models.mlp);
    results.sae   = testsae2( models.sae, outf_val', outt_val');
    results.lda   = testlda(outf_val', outt_val' == 1, models.lda);
    results.som1  = test_som1_classifier(outf_val', outt_val(:, 1)', models.som1);
    results.som2  = test_som2_classifier(outf_val', outt_val(:, 1)', models.som2);
    results.lasso = test_lasso_classifier2(outf_val', outt_val(:, 1)', models.lasso, param);
 %   results.sfam  = testfsnet(outf_val', outt_val(:, 1)', models.sfam);
    results.yreal = (outt_val(:, 1)' == 1);
end
    