% 
% Used to load EEG/ERP data, extract epochs and pick time intervals and
% channels of interest
% 
%
% Inputs:
% see create_feature_vector for explanation
%
% Outputs
% averages - averaged epoched EEG features
% EEG      - original EEG EEGLAB data
% ------------------------------------------------
function [averages, EEG] = eeglab_process(source_directory, source_file_name, param, markers, phase);


    if isempty(strfind(source_file_name, '.set'))
        EEG = pop_fileio([source_directory, source_file_name]);
    else
        EEG = pop_loadset('filename', source_file_name, 'filepath', source_directory);
    end;
    
    %EEG = pop_fileio([source_directory, source_file_name]);
    EEG = eeg_checkset( EEG );

    % extract epochs with selected channel
    EEG = pop_epoch( EEG, markers, [param.preepoch param.postepoch], 'epochinfo', 'yes');
    EEG = eeg_checkset( EEG );

    % remove baseline
    EEG = pop_rmbase( EEG, [param.preepoch * param.Fs    0]);
    EEG = eeg_checkset( EEG );

    % low-pass-filter the data 
    %EEG = pop_eegfilt( EEG, 0, max_fq);
    %EEG = eeg_checkset( EEG );
    %EEG = pop_eegfilt( EEG, min_fq, 0, (postepoch - preepoch) * Fs / 4);
    %EEG = pop_eegfilt( EEG, 0.01, 12, 16);
    %EEG = eeg_checkset( EEG );
    
    % downsample the data
%    [EEG] = pop_resample( EEG, param.Fsnew);
    
    % ensamble epoch averaging if requested
    if (param.avg.(phase) > 1)
        EEG_data = eeglab_averaging(EEG.data, param.avg.(phase));
    else
        EEG_data = EEG.data;
    end
    
    EEG_data = shuffle(EEG_data, 3);

    averages = utl_picktimes(EEG_data, param.Fs * param.wnd);
    averages = averages(param.channels, :, :);
    