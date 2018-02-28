function  [som_clusters, train_time] = train_lasso_classifier(out_features, out_targets, param);

    timel = tic;
    c=[out_features',out_targets' * param.lasso.targetmultcoef];
    som_clusters = som_make(c, 'init', 'lininit', 'algorithm', 'batch', 'lattice', 'hexa', 'shape', 'sheet', 'msize', [param.lasso.size param.lasso.size]); 
    train_time = toc(timel);
    %som_show(som_clusters, 'umat', 'all');
    %som_show(som_clusters);