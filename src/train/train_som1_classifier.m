% Train using the "SOM1" method
%neurons_stats - contains the trained model with neurons assigned to
%different classes

function  [som_model, train_time] = train_som1_classifier(out_features, out_targets, param);

    times = tic;

    % clustering
    som_clusters = som_make(out_features',  'msize', [param.som1.size param.som1.size]); 
    %som_clusters = som_make(out_features',   'init' , 'randinit'); 
    %som_clusters = som_make(out_features',   'lattice', 'hexa'); 

    number_of_neurons = size(som_clusters.codebook, 1);

    % 2 classes: target, non-target
    number_of_targets = length(out_targets(out_targets(1,:) == 1));
    number_of_nontargets = length(out_targets(out_targets(1,:) == -1));
    neurons_stats = zeros(2, number_of_neurons);
    bmus = som_bmus(som_clusters, out_features');
    for i = 1:length(bmus)
        wneuronindex = bmus(i);
        class = max(out_targets(1, i), 0) + 1;
        neurons_stats(class, wneuronindex) = neurons_stats(class, wneuronindex) + 1;
    end

    for i = 1:size(neurons_stats, 2)
        neurons_stats(1, i) = neurons_stats(1, i)  / number_of_nontargets;
    end

    for i = 1:size(neurons_stats, 2)
        neurons_stats(2, i) = neurons_stats(2, i)  / number_of_targets;
    end

    som_model = struct;
    som_model.neurons_stats = neurons_stats;
    som_model.som_clusters  = som_clusters;

    train_time = toc(times);
