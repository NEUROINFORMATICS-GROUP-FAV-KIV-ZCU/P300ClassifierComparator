% Averages every N trials in EEG data structure
% eeg_data  - epoched EEG
% averaging - N - number of trials to average together 
function [ out_eeg_data ] = eeglab_averaging( eeg_data, averaging)
    out_eeg_data = zeros(size(eeg_data, 1), size(eeg_data, 2), floor(size(eeg_data,3) / averaging));
    for channel = 1:size(out_eeg_data, 1)
        for trial = 1:size(out_eeg_data, 3)
            start_point = (trial - 1) * averaging + 1;
            end_point   = trial * averaging;
            out_eeg_data(channel, :, trial) = mean(eeg_data(channel, :, start_point:end_point), 3);
        end
    end
end

