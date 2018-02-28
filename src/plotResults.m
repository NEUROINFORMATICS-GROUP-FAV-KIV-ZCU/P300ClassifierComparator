% Plot classification results:
% -  individual results for different participants
% -  average accuracies
function plotResults(allresults, means, param)
    % individual results

    allxseries = struct;
    %zeros(length(param.classifiers), length(param.test_ids));


    for j = 1: length(param.metrics)
    allxseries.(param.metrics{j})  = []; 
    for i = 1:length(param.classifiers)  
        xseries.(param.metrics{j}) = [allresults.(param.metrics{j}){2:(length(param.test_ids) + 1) , i}];
        allxseries.(param.metrics{j}) = [allxseries.(param.metrics{j}); xseries.(param.metrics{j})];
    end

    figure;
    bar(allxseries.(param.metrics{j})' * 100);
    set(gca,'xtick',1:length(param.test_ids),'xticklabel',param.test_ids);
    title([param.metrics{j}, ' of various classifiers']);
    xlabel('Dataset number');
    ylabel([param.metrics{j}, ' %']);
    legend(upper(param.classifiers));
    end


    % average
    figure;
    bar(means * 100);
    set(gca,'xtick',1:length(param.classifiers), 'xticklabel', param.classifiers);
    title('Average accuracy of various classifiers');
    xlabel('Classification model');
    ylabel('Accuracy');
    ylim([min(means * 100) max(means * 100)])
end

