%neurons_stats - contains the trained model with neurons assigned to
%different classes

function  [som2_model, train_time] = train_som2_classifier(out_features, out_targets, param);

    times = tic;

    % clustering
    n_of_clusters = param.som2.n_clusters;
    som_clusters = som_make(out_features',  'msize', [param.som2.size param.som2.size]); 

    % seed
    %targetmean = mean(out_features(:, out_targets(1, :) == 1),2);
    %som_clusters.codebook(1, :) = targetmean;

    % re-train
    %som_clusters = som_batchtrain(som_clusters, out_features');
    %som_clusters = som_make(out_features'); 

    %figure;
    %sC = som_cllinkage(som_clusters); 
    %som_clplot(sC); 

    %figure;


    [c, p, err, ind] = kmeans_clusters(som_clusters); % find clusterings
    dichotomic_clusters = p{n_of_clusters, 1};
    %[dummy,i] = min(ind); % select the one with smallest index
    %som_show(som_clusters,'color',{p{i},sprintf('%d clusters',i)}); %
    %visualize
    %colormap(jet(i)), som_recolorbar % change colormap

    %[cluster_base, cluster_seed] = som_dmatclusters(som_clusters, 'neighf', 'N1');

    % 2 classes: target, non-target
    number_of_targets = length(out_targets(out_targets(1,:) > 0));
    number_of_nontargets = length(out_targets(out_targets(1,:) <= 0));
    neurons_stats = zeros(2, n_of_clusters);
    bmus = som_bmus(som_clusters, out_features');
    for i = 1:length(bmus)
        wneuronindex = bmus(i);
        wclusterindex = dichotomic_clusters(wneuronindex);
        class = max(out_targets(1, i), 0) + 1;
        neurons_stats(class, wclusterindex) = neurons_stats(class, wclusterindex) + 1;
    end

    for i = 1:size(neurons_stats, 2)
        neurons_stats(1, i) = neurons_stats(1, i)  / number_of_nontargets;
    end

    for i = 1:size(neurons_stats, 2)
        neurons_stats(2, i) = neurons_stats(2, i)  / number_of_targets;
    end

    som2_model = struct;
    som2_model.neurons_stats = neurons_stats;
    som2_model.som_clusters = som_clusters;
    som2_model.dichotomic_clusters = dichotomic_clusters;

    train_time = toc(times);