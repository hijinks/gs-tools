addpath('./scripts');
addpath('./lib');

output_path = 'fan_comparisons/'
% Prep fan data
fan_names = {'G8', 'G10', 'T1', 'SR1'};
color_map = [[0 0.4980 0]; [0.8706 0.4902 0]; [0.8 0 0]; [0.2039 0.3020 0.4941]; [1 0 1]; [0 0 0]];
line_styles = {'-','-k','-g','-r','-b','-c'};
point_styles = {'xm','xk','xg','xr','xb','xc'};
line_point_styles = {'x-','xk-','xg-','xr-','xb-','xc-'};
fans = {g8_data, g10_data, t1_data, sr1_data};

% Normalised downstream fining for each surface

%[distance_sorted] = surface_stats(fan_names, fans);

fannames = fieldnames(distance_sorted);

for fn=1:length(fannames)
    
%     surface_figure = figure;
    cf = distance_sorted.(fannames{fn});
    s_names = fieldnames(cf);
    surface_names = s_names;
    legend_items = {};
    legend_labels = [];
    surface_wolmans = [];
    surface_d84s = [];
    
    for sn=1:length(s_names)
        surface = cf.(s_names{sn});
        bigval = nan(5e5,1);
        surface_d84s = [surface_d84s,prctile(cell2mat(surface(:,2)), 84)];
        surface_wolman_all = cell2mat(surface(:,2));
        surface_wolman = cell2mat(surface(:,2));
        surface_wolman(isnan(surface_wolman)) = [];
        dif = length(bigval) - length(surface_wolman);
        pad = nan(dif,1);
        surface_wolman = [surface_wolman;pad];
        surface_wolmans = [surface_wolmans,surface_wolman];
        len = length(surface(:,1));
        distances = cell2mat(surface(:,1));
        max_dist = max(distances);
        norm_dist = distances./max_dist;
        wolmans = cell2mat(surface(:,2)');
        d84s = zeros(1,len);
        errors = zeros(1,len);
%         for j=1:len
%             d84s(1,j) = prctile(wolmans(:,j), 84);
%             errors = (prctile(wolmans(:,j), 90)-prctile(wolmans(:,j), 80))/2;
%         end
%         d = boundedline(norm_dist, d84s, errors, '-x', 'alpha', 'cmap', color_map(sn,:))
%         ylim([0,150]);
%         xlim([0,1.1]);
%         xlabel('Normalised downstream distance');
%         ylabel('Grain size (mm)');
%         hold on;
%         legend_labels{sn} = surface_names{sn};
%         legend_items = [legend_items,d];    
    end
%     legend(legend_items,legend_labels);
%     title(['Downstream Fining ' fannames{fn}]);
    
%     print(surface_figure, '-depsc', [output_path fannames{fn} '_downstream' '.eps'])
    
    surface_averages_figure = figure;
    
    boxplot(surface_wolmans);
    hold on;
    sd = plot(surface_d84s, 'kx-');
    xlabel('Surfaces');
    ylabel('Grain size(mm)');
    ylim([0,200]);
    set(gca,'xtick',1:length(s_names), 'xticklabel',s_names)
    legend(sd, 'D84')
    title([fannames{fn}, ' surface grain size variation'])
    
     print(surface_averages_figure, '-dpdf', [output_path fannames{fn} '_surface_averages' '.pdf'])
    
%     cfreq_figure = figure;
%     
%     for sn=1:length(s_names)
%         surface = cf.(s_names{sn});
%         
%         if (strcmp(s_names{sn}, 'B')+(strcmp(s_names{sn}, 'A'))) < 1
%            color = 'm';
%            t = 1;
%         else
%            color = 'k';
%            t = 0;
%         end
%         len = length(surface(:,1));
%         
%         for k=1:len
%             h = cdfplot(surface{k,2}); 
%             set(h,'Color',color)
%             hold on;
%             if t
%                last_pink = h;
%             else
%                last_black = h; 
%             end
%         end
%         set(h.Parent, 'xlim', [0 250])
% 
%     end
%     title([fannames{fn}, ' Grain Size Distributions'])
%     xlabel('Long axis grain size (mm)')
%     legend([last_pink, last_black], {'Holocene', 'Late Pleistocene'}, 'Location', 'SE')
%     print(cfreq_figure, '-depsc', [output_path fannames{fn} '_cfreq' '.eps'])
end
    
% Surface averages

% Cumulative frequency
