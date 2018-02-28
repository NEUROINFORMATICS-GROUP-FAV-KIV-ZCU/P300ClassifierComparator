% Reads EEG/ERP data from a selected directory and file and extracts features
% as desired.
% source_directory - directory to read data from
% source_file_name - .set filename
% param            - feature extraction parameters
% out_features - contains the features - [M x N] - M - dimension of features, N - number of features
% out_targets  - contains the targets  - [P x N] - P - target classes, N - number of features
function [out_features, out_targets] ...
    = create_feature_vector(source_directory, source_file_name, param, phase);
    
        % get a feature vector for each condition
        % and join them into NNToolBox training data
        [targetAverages, ~] = eeglab_process(source_directory, source_file_name, ...
        param, param.(phase).target_markers, phase);
        [nontargetAverages, ~] = eeglab_process(source_directory, source_file_name, ...
        param, param.(phase).nontarget_markers, phase);
        [out_features, out_targets] = ...
        merge_target_nontarget(targetAverages, nontargetAverages);
end

    