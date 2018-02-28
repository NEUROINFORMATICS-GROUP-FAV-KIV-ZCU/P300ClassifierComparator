% Investigates statistical differences between target and non-target
% feature vectors using t-test on a param.alpha significance level.
% Returns results for individual components of the vector.
% hv - indicates null hypothesis rejection (1) or no rejection (0)
%  p - p-values
function [ hv, p ] = calcStats( out_features, out_targets, param )
  
    targetf = out_features(out_targets(:, 1) > 0, :);
    nontargetf = out_features(out_targets(:, 1) <= 0, :);
    
    diffs = zeros(1, size(targetf, 1));
    hv     = zeros(1, size(targetf, 2));
    p     = zeros(1, size(targetf, 2));
    
    % for all channels and time intervals
    for i = 1: size(targetf, 2)
        % for all trials
        for j = 1: size(targetf, 1)
            diffs(1, j) = targetf(j, i) - nontargetf(j, i);
        end
        
         [hv(i), p(i)] = ttest(diffs, 0, param.alpha); % test each channel and time interval separately
    end
    
    % plot results, highlight statistical significant intervals
    x=0:size(targetf, 2) - 1;
    plot (x, mean(targetf, 1));
    maxt = max(abs(mean(targetf, 1)));
    hold on;
    plot (x, mean(nontargetf, 1), 'r');
    maxn = max(abs(mean(nontargetf, 1)));
    %plot(h==1, 'g')
   
    x = [x;x];
    h = [hv;hv];
    harea = area(x([2:end end]), h(1:end)*max(maxt, maxn)); % rescale to max
    set(harea, 'FaceColor', 'r')
    alpha(0.25)
%     xt = get(gca, 'XTick');   
%     set(gca, 'XTick', xt, 'XTickLabel', xt * 20)  
%     xlabel('Time [ms]')
    ylabel('Voltage [\muV]')
    legend('Target average', 'Non-target average', 'h == 1')
    
   
end

