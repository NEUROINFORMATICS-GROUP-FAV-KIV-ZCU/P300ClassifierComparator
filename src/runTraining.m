% Performs training and validation (param.valid_iters iterations) of the models based on the param
% settings
% train_dirs  - cell array of directories used for training
% train_files - cell array of files in train_dirs
% param - global settings
function [bestmodels, global_results, results, param] = runTraining(train_dirs, train_files, param)

    % input data
    % - training
    %training_dir  = [base_dir, 'training\'];
    %training_file = '88_90_100_104.set';
        
    % extract all training feature vectors
    for I = 1:length(train_dirs)
        [out_featuresnew, out_targetsnew] = create_feature_vector(train_dirs{I}, train_files{I}, param, 'training'); % training trials
        
        if (exist('out_features', 'var') && exist('out_targets', 'var')) 
            out_features = vertcat(out_features, out_featuresnew);
            out_targets  = vertcat(out_targets, out_targetsnew);
         else
            out_features = out_featuresnew;
            out_targets = out_targetsnew;    
         end
    end
    
    % shuffle the features and outputs in the same way
    [out_features, sortOrder, ~] = shuffle(out_features, 1);
    out_targets = out_targets(sortOrder,:);
    
   
    
    if param.calcStat == 1
         % calculate statistical comparison
        [ h, p ] = calcStats( out_features, out_targets, param );
        % reduce unsignificant dimensions
        param.h = h;
       
    end
    if param.reduceStat == 1
        out_features = out_features(:, param.h == 1);
    end
    
    global_results = struct;
%    global_results.h = h;
%    global_results.p = p;
    max_accuracy = struct;
   
    for I = 1:length(param.classifiers)
        classifier = param.classifiers{I};
        max_accuracy.(classifier) = 0;
    end
    
    bestmodels = struct;
    
    

    % train and validate off-line BCI many times using different validation
    % dataset 
    for I = 1:param.valid_iters
        [results, models] = ...
        P300_train_val(out_features, out_targets, param); % training and validation
        
        
        for J = 1:length(param.classifiers)
            classifier = param.classifiers{J};
                        
            % store individual validation results
            global_results.(classifier)(I, 1) = results.(classifier).accuracy;
            global_results.(classifier)(I, 2) = results.(classifier).precision;
            global_results.(classifier)(I, 3) = results.(classifier).recall; 
            
            
            if results.(classifier).accuracy > max_accuracy.(classifier)
                max_accuracy.(classifier) = results.(classifier).accuracy;
                bestmodels.(classifier) = models.(classifier);
            end
        end
        global_results.models(I, 4) = models;
        

       
        
        % outputs for statistical tests
        %if isfield(global_results, 'val_yblda')
        %    global_results.val_yblda =  [global_results.val_yblda   results.blda.y];
        %    global_results.val_yreal  = [global_results.val_yreal  results.yreal];
        %else
        %    global_results.val_yblda = results.blda.y;
        %    global_results.val_yreal = results.yreal;
        %end;
    end

    %results = display_results(global_results);
end