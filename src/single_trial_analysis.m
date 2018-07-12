function  single_trial_analysis(param)
    % print single trial measures
    fields = fieldnames(param.stanalysis);

    sumTLStds = 0;
    countTLStds = 0;
    MAX_TRIAL = 200;
    for fn=fields'
        MAX_TRIAL = min(MAX_TRIAL, length(param.stanalysis.(fn{1}).latenciesT));
    end

    allTLatencies = zeros(length(fields), MAX_TRIAL);

    for fn=fields'
      str = sprintf('\nFilename: %s', fn{1});
      disp(str);

      %# since fn is a 1-by-1 cell array, you still need to index into it, unfortunately
      t_st_ampl_mean = mean(param.stanalysis.(fn{1}).amplitudesT);
      t_st_ampl_std = std(param.stanalysis.(fn{1}).amplitudesT);
      t_avg_ampl = param.stanalysis.(fn{1}).avgAmplitudeT;

      n_st_ampl_mean = mean(param.stanalysis.(fn{1}).amplitudesN);
      n_st_ampl_std = std(param.stanalysis.(fn{1}).amplitudesN);
      n_avg_ampl = param.stanalysis.(fn{1}).avgAmplitudeN;

      t_st_lat_mean = mean(param.stanalysis.(fn{1}).latenciesT);
      t_st_lat_std = std(param.stanalysis.(fn{1}).latenciesT);
      t_avg_lat = param.stanalysis.(fn{1}).avgLatencyT;

      sumTLStds = sumTLStds + t_st_lat_std;
      countTLStds = countTLStds + 1;
      allTLatencies(countTLStds, :) = param.stanalysis.(fn{1}).latenciesT(1:MAX_TRIAL);

      n_st_lat_mean = mean(param.stanalysis.(fn{1}).latenciesN);
      n_st_lat_std = std(param.stanalysis.(fn{1}).latenciesN);
      n_avg_lat = param.stanalysis.(fn{1}).avgLatencyN;


      str = sprintf('Target: peak latency %.3f, single trial average %.3f (SD %.3f)', t_avg_lat, t_st_lat_mean, t_st_lat_std);
      disp(str);
      str = sprintf('Non-target: peak latency %.3f, single trial average %.3f (SD %.3f)', n_avg_lat, n_st_lat_mean, n_st_lat_std);
      disp(str);
      str = sprintf('Target: peak amplitude %.3f, single trial average %.3f (SD %.3f)', t_avg_ampl, t_st_ampl_mean, t_st_ampl_std);
      disp(str);
      str = sprintf('Non-target: peak amplitude %.3f, single trial average %.3f (SD %.3f)', n_avg_ampl, n_st_ampl_mean, n_st_ampl_std);
      disp(str);
    end
    str = sprintf('Average target latency SD: %.3f', sumTLStds / countTLStds);
    disp(str);
    globalTLatencies = mean (allTLatencies, 1);
    plotregression(1:length(globalTLatencies), globalTLatencies);
    %plotregression(1:length(globalTLatencies), std (allTLatencies, 1));
end

