% Merges target and nontarget features and creates a matrix of target
% classes
% targetAverages    - features (averaged or single trials) associated with target markers
% nontargetAverages - features (averaged or single trials) associated with non-target markers
function [out_features, out_targets] = ...
            merge_target_nontarget(targets, nontargets);
        
    number_of_channels = size(targets, 1);
    number_of_windows = size(targets, 2);
    number_of_targets = size(targets, 3);
    number_of_nontargets = size(nontargets, 3);

    % reshape arrays to have time data next to each other for every channel
    reshaped_t = reshape(permute(targets, [2 1 3]), number_of_channels * number_of_windows, number_of_targets);
    reshaped_n = reshape(permute(nontargets, [2 1 3]), number_of_channels * number_of_windows, number_of_nontargets);

    % reduce the size of nontarget array to match the size
    % of the target array
    if (number_of_nontargets > number_of_targets)
        reshaped_n     = shuffle(reshaped_n, 2);
        reshaped_n     = reshaped_n(:,1:number_of_targets);
        number_of_nontargets = number_of_targets;
    end

    % create target array and invert vectors
    out_t = repmat([1 -1], number_of_targets, 1);
    out_n = repmat([-1 1], number_of_nontargets, 1);
    reshaped_t = reshaped_t';
    reshaped_n = reshaped_n';

    % concatenate targets and nontargets
    out_targets  = vertcat(out_t, out_n);
    out_features = vertcat(reshaped_t, reshaped_n);
    out_features = normr(out_features);
end
