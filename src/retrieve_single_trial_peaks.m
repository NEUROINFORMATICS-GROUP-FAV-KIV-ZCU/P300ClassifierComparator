% Retrieve individual trial peak latencies and peak amplitudes
% in the param.range variable
% trials - array of number of trials x number of samples in each trial
% Output:
% amplitudes - array of peak amplitudes
% latencies  - array of peak latencies
function [amplitudes, latencies, peakamplitude, peaklatency] = retrieve_single_trial_peaks(trials, param)
    amplitudes = zeros(1, size(trials, 1));
    latencies  = zeros(1, size(trials, 1));
    for i = 1:size(trials, 1)
        signalPart = trials(i, param.range(1) * (param.Fs / 1000):param.range(2) * (param.Fs / 1000));
        [amplitudes(1, i), I] = max(signalPart);
        latencies(1, i) = param.range(1) + I / (param.Fs / 1000);
    end
    
    % peak from the signal average
    avgtrial = mean(trials,1);
    avgtrialPart = avgtrial(param.range(1) * (param.Fs / 1000):param.range(2) * (param.Fs / 1000));
    [peakamplitude, I] = max(avgtrialPart);
    peaklatency = param.range(1) + I / (param.Fs / 1000);
    
end

    