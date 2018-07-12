% Sets up default parameters for feature extraction and classification
%
function [param] = configParam()
    % classification parameters
    param = struct;

    % classifiers included for training and testing
    param.classifiers = {'lda', 'mlp', 'sae', 'som1', 'som2', 'lasso'};
    %param.classifiers = {'sfam'};
    param.metrics    = {'accuracy', 'precision', 'recall'};

    % ------------------------------------
    % markers (triggers) for classification
    param.training = struct;
    param.training.target_markers    = {'S  2'};
    param.training.nontarget_markers = {'S  4'}; 
    param.testing = struct;
    param.testing.target_markers    = {'S  2'};
    param.testing.nontarget_markers = {'S  4'}; 

    % ------------------------------------
    % picking a subset of EEG channels
    param.channels = 19; % 1:32 - all, 26 - Pz, 1:19 - default
    % ------------------------------------
    % epoch border settings
    param.preepoch  = -0.1;
    param.postepoch = 1;


    % ------------------------------------
    % windows for feature extraction averaging - in seconds related to the
    % stimuli onsets
    minlatency   = 0.0;  % after stimulus start %0.15 - default
    maxlatency   = 1;  % after stimulus end   %0.7  - default
    steps = 20;    % number of intervals  %  11 - default 
    interval  = (maxlatency - minlatency) / steps;
    temp_wnd  = minlatency:interval:maxlatency;
    wnd = zeros(steps, 2);
    for I = 1:length(temp_wnd) - 1 % create "steps" time windows between "min" and "max"
        wnd(I, 1) = temp_wnd(I);
        wnd(I, 2) = temp_wnd(I + 1);
    end
    param.wnd       = wnd;
    param.wnd       = param.wnd - param.preepoch;

    % perform statistical analysis to remove, if not, predefined time
    % windows / channels are used
    param.calcStat = 1;
    param.reduceStat = 1;
    % precalculated statistically significant time windows / channels
    %param.h = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0];
    % significance level for t-tests
    param.alpha  = (0.05 / (length(param.wnd) * length(param.channels)));

    % ------------------------------------
    % bandpass frequency filters - currently unused!!
    param.min_fq = 0.1;  % lower bandpass frequency limit in Hz
    param.max_fq = 12;   % upper bandpass frequency limit in Hz
    % ------------------------------------
    % resampling
    param.Fs = 1000;      % original sampling rate in Hz
    %param.Fsnew = 100;   % new sampling rate in Hz
    % epoch size
    %param.full_size = 1024;
    % ------------------------------------
    % averaging
    param.avg.training = 1;
    param.avg.testing  = 1; % averaging trials? default and for single trial classification - 1
    % ------------------------------------
    % validation percentage
    param.validation = 0.3; % percentage of feature vectors excluded from training
                            % and used for validation
    param.valid_iters = 1; % number of iterations in Monte Carlo cross-validation
    param.showplots   = 0;  % for each iteration, plot feature vectors for each condition
    
    
    
    %param.randomizer = rng(10, 'simdTwister'); % for reproducibility

    % classifier parameters
    param.sae = struct;
    param.sae.TransferFunction = 'purelin';
    param.sae.neurons_1 = 70;%70;
    param.sae.neurons_2 = 55;%55;
    param.sae.neurons_3 = 40;%40;
    %param.sae.neurons_4 = 40;
    param.sae.iters_1 = 200;
    param.sae.iters_2 = 200;
    param.sae.iters_3 = 200;
    %param.sae.iters_4 = 100;
    param.sae.iters_softmax = 200;
    param.sae.finetuneIter = 200;
    param.sae.performFcn = 'mse';
    param.sae.percentageValidation = 0;
    param.sae.sparprop = 0.2; % 0.15
    param.sae.l2reg = 0.015;  % 0.004
    param.sae.sparreg = 15;   % 4
    param.showTraining = false;

    param.som1 = struct;
    param.som1.size = 8;

    param.som2 = struct;
    param.som2.size = 8;
    param.som2.n_clusters = 7;
    
    param.lasso = struct;
    param.lasso.size = 8;
    param.lasso.targetmultcoef = 1;
    param.lasso.grid_distance = 5;
    param.lasso.relative_distance = 0.4;
    
    param.lda = struct;
    param.lda.regularization = 'shrinkage';
    %param.lda.shrinkageParam = 0;
    
    param.sfam = struct;
    param.sfam.max_categories = 2;
    param.sfam.epochs = 50;
    param.sfam.vigilance = 0.75;
    param.sfam.alpha = 0.001;
    param.sfam.epsilon = 0.001;
    param.sfam.beta = 1;
    
    % range for finding p300 in single trial analysis
    param.range = [250, 500]; % in miliseconds
    param.stanalysis = struct;
    
end

