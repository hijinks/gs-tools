addpath('./scripts');
addpath('./lib');

X = 42.0;                  %# A3 paper size
Y = 29.7;                  %# A3 paper size
xMargin = 0;               %# left/right margins from page borders
yMargin = 2;               %# bottom/top margins from page borders
xSize = X - 2*xMargin;     %# figure size on paper (widht & hieght)
ySize = Y - 2*yMargin;     %# figure size on paper (widht & hieght)
f = figure('Menubar','none');
set(f, 'Position', [0,0, 1200, 800])
set(f, 'PaperSize',[X Y]);
set(f, 'PaperPosition',[0 yMargin xSize ySize])
set(f, 'PaperUnits','centimeters');
set(f, 'Visible', 'off');

surface_colours;
[apex_data] = fan_apexes;

output_path = 'dump/comparisons/'
% Downstream fining plots
fan_names = {'G8', 'G10', 'T1', 'SR1'};
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
    fan_name = fannames{fn};
    s_names = fieldnames(cf);
    surface_names = s_names;
    legend_items = [];
    legend_labels = {};
    surface_wolmans = [];
    surface_d84s = [];
%     surface_figure = figure()
    
    subplot(2,2, fn)
    
    for sn=1:length(s_names)
        
        surface = cf.(s_names{sn});
        if strcmp(s_names{sn}, 'B') < 1
            
            if strcmp(s_names{sn}, 'F') < 1
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
                sites = cell2mat(surface(:,3));
                
                [apex_distance, relative_distances] = fan_apex_relative(sites, ...
                    apex_data.(fan_name), origins.(fan_name)); 
                
                max_dist = max(distances);
                norm_dist = distances;
                wolmans = cell2mat(surface(:,2)');
                d84s = zeros(1,len);
                errors = zeros(1,len);
                for j=1:len
                    d84s(1,j) = prctile(wolmans(:,j), 84);
                    errors = (prctile(wolmans(:,j), 90)-prctile(wolmans(:,j), 80))/2;
                end
                d = boundedline(norm_dist, d84s, errors, '-x', 'alpha', 'cmap', clrs.(fannames{fn}).(s_names{sn}));
                ylim([0,150]);
%                 xlim([0,1.1]);
                xlabel('Normalised downstream distance');
                ylabel('Grain size (mm)');
                hold on;
                plot([apex_distance,apex_distance], [-10,200], 'k-');
                hold on;
                legend_labels = [legend_labels surface_names{sn}];
                legend_items = [legend_items,d];
            end
        end
    end
    legend(legend_items,char(legend_labels));
    title(fannames{fn});
    set(gca, 'FontSize', 14)

print(f, '-dpng', ['fans_downstream', '.png'])
    
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
