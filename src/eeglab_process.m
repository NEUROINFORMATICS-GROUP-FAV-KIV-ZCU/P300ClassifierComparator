% 
% Used to load EEG/ERP data, extract epochs and pick time intervals and
% channels of interest
% 
%
% Inputs:
% see create_feature_vector for explanation
%
% Outputs
% averages     - averaged epoched EEG features
% EEG_out      - extracted epochs ready to single trial analysis
% ------------------------------------------------
function [averages, EEG_out] = eeglab_process(source_directory, source_file_name, param, markers, phase);


    if ~contains(source_file_name, '.set')
        EEG = pop_fileio([source_directory, source_file_name]);
    else
        EEG = pop_loadset('filename', source_file_name, 'filepath', source_directory);
    end
    
    EEG = eeg_checkset( EEG );
    
     
    
   % EEG = pop_eegfilt( EEG, 0, 12);

    % extract epochs with selected channel
    EEG = pop_epoch( EEG, markers, [param.preepoch param.postepoch], 'epochinfo', 'yes');
    EEG = eeg_checkset( EEG );

    % remove baseline
    EEG = pop_rmbase( EEG, [param.preepoch * 1000    0]);
    EEG = eeg_checkset( EEG );
    
    EEG = pop_jointprob(EEG,1,[1:19], 3, 3, 0, 0);
    EEG = eeg_rejsuperpose( EEG, 1, 1, 1, 1, 1, 1, 1, 1);
    EEG = pop_rejepoch(EEG,EEG.reject.rejglobal ,0);  
   
    % prepare data for single trial analysis 1)
    EEG_data_singletrial = squeeze(EEG.data(param.channels, :, :))';
    % prepare data for single trial analysis 2)
    % truly remove the baseline preepoch period from the signal
    if param.preepoch < 0
        EEG_out = zeros(size(EEG_data_singletrial, 1), size(EEG_data_singletrial, 2) + param.preepoch * param.Fs);
        for i = 1:size(EEG_data_singletrial, 1)
            EEG_out(i, :) = EEG_data_singletrial(i, -param.preepoch * param.Fs + 1:end);
        end
    else
        EEG_out = EEG_data_singletrial;
    end
  
    % ensemble epoch averaging if requested
    if (param.avg.(phase) > 1)
        EEG_data = eeglab_averaging(EEG.data, param.avg.(phase));
    else
        EEG_data = EEG.data;
    end
    
    EEG_data = shuffle(EEG_data, 3);

    averages = utl_picktimes(EEG_data, param.Fs * param.wnd);
    averages = averages(param.channels, :, :);
    