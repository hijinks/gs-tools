addpath('./scripts');
addpath('./lib');

output_path = 'fan_comparisons/'
% Prep fan data
fan_names = {'G8', 'G10', 'T1', 'SR1'};
color_map = [[1.0000    0.6000    0.6000]; [0.8000    0.8000    1.0000]; [ 0.6000    0.6000    1.0000]; [0.2039 0.3020 0.4941]; [0.8196    0.8196    0.8510]; [0 0 0]];
line_styles = {'-','-k','-g','-r','-b','-c'};
point_styles = {'xm','xk','xg','xr','xb','xc'};
line_point_styles = {'x-','xk-','xg-','xr-','xb-','xc-'};
fans = {g8_data, g10_data, t1_data, sr1_data};

% Normalised downstream fining for each surface

%[distance_sorted] = surface_stats(fan_names, fans);

fannames = fieldnames(distance_sorted);

for fn=1:length(fannames)
    fan_data = fans{fn};
%     surface_figure = figure;
    cf = distance_sorted.(fannames{fn});
    s_names = fieldnames(cf);
    surface_names = s_names;
    legend_items = [];
    legend_labels = {};
    surface_wolmans = [];
    surface_d84s = [];
    surface_figure = figure()
    
    for sn=1:length(s_names)
        surface_data = fan_data{sn}
        surface = cf.(s_names{sn});
        ss = surface_data.ss;
        ed = -4.5:1:8.5;
        xp = [-4:1:8];
        all_x = [];
        all_y = [];

        for k=1:length(ss)
           [N,edges] = histcounts(ss{k}, ed);
           plot(xp,N, 'Color' , [.7 .7 .7]);
           hold on;
           all_x = [all_x; xp];
           all_y = [all_y; N];
        end

        plot(all_x,all_y, 'x');
        set(gca, 'FontSize',14);
        hold on;                
    end
    title(['Self Similiarity Curves ' fannames{fn}]);
    set(gca, 'FontSize', 14)
    ylim([0,70])
    print(surface_figure, '-dpdf', [output_path fannames{fn} '_self_similarity' '.pdf'])
    
%     surface_averages_figure = figure;
%     
%     boxplot(surface_wolmans);
%     hold on;
%     sd = plot(surface_d84s, 'kx-');
%     xlabel('Surfaces');
%     ylabel('Grain size(mm)');
%     ylim([0,200]);
%     set(gca,'xtick',1:length(s_names), 'xticklabel',s_names)
%     legend(sd, 'D84')
%     title([fannames{fn}, ' surface grain size variation'])
%     
%      print(surface_averages_figure, '-dpdf', [output_path fannames{fn} '_surface_averages' '.pdf'])
%     
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
