function plot_feature_vectors(out_features, out_targets)
   % plot
    targetf = out_features(:, out_targets == 1);
    tmean = mean(targetf, 2);
    nontargetf = out_features(:, out_targets == -1);
    nontmean = mean(nontargetf, 2);
    
    plot(tmean);
    hold on;
    plot(nontmean, 'r');
    xlabel('Feature vector time/channel points')
    ylabel('Feature vector average amplitudes')
    legend('Target average','Non-target average')
end

