% Reads EEG/ERP data from a selected directory and file and extracts features
% as desired.
% source_directory - directory to read data from
% source_file_name - .set filename
% param            - feature extraction parameters
% out_features - contains the features - [M x N] - M - dimension of features, N - number of features
% out_targets  - contains the targets  - [P x N] - P - target classes, N - number of features
function [out_features, out_targets, param] ...
    = create_feature_vector(source_directory, source_file_name, param, phase);
    
        % get a feature vector for each condition
        % and join them into NNToolBox training data
        [targetAverages, singletrialsT] = eeglab_process(source_directory, source_file_name, ...
        param, param.(phase).target_markers, phase);
        [amplitudesT, latenciesT] = retrieve_single_trial_peaks(singletrialsT, param);
        [nontargetAverages, singletrialsN] = eeglab_process(source_directory, source_file_name, ...
        param, param.(phase).nontarget_markers, phase);
        [amplitudesN, latenciesN] = retrieve_single_trial_peaks(singletrialsN, param);
        
        % output for single trial analysis
        stanalysis = struct;
        stanalysis.amplitudesT = amplitudesT;
        stanalysis.amplitudesN = amplitudesN;
        stanalysis.latenciesT  = latenciesT;
        stanalysis.latenciesN  = latenciesN;
        sname = char(matlab.lang.makeValidName(extractBetween(source_file_name, "_",".")));
        param.stanalysis.(sname) = stanalysis;
        
        [out_features, out_targets] = ...
        merge_target_nontarget(targetAverages, nontargetAverages);
end

    