addpath('./scripts');
addpath('./lib');

output_path = 'dump/'
% Self similarity plots
fan_names = {'G8', 'G10', 'T1', 'SR1'};
color_map = [[1.0000    0.6000    0.6000]; [0.8000    0.8000    1.0000]; [ 0.6000    0.6000    1.0000]; [0.2039 0.3020 0.4941]; [0.8196    0.8196    0.8510]; [0 0 0]];
line_styles = {'-','-k','-g','-r','-b','-c'};
point_styles = {'xm','xk','xg','xr','xb','xc'};
line_point_styles = {'x-','xk-','xg-','xr-','xb-','xc-'};
fans = {g8_data, g10_data, t1_data, sr1_data};

% Normalised downstream fining for each surface

%[distance_sorted] = surface_stats(fan_names, fans);

fannames = fieldnames(distance_sorted);

sfig = figure;
X = 42.0;                  %# A3 paper size
Y = 29.7;                  %# A3 paper size
xMargin = 0;               %# left/right margins from page borders
yMargin = 2;               %# bottom/top margins from page borders
xSize = X - 2*xMargin;     %# figure size on paper (widht & hieght)
ySize = Y - 2*yMargin;     %# figure size on paper (widht & hieght)
    
set(sfig, 'Position', [0,0, 1200, 800])
set(sfig, 'PaperSize',[X Y]);
set(sfig, 'PaperPosition',[0 yMargin xSize ySize])
set(sfig, 'PaperUnits','centimeters');
        

ha = tight_subplot(2,2,[.02;.02],.05,[.05 .02]);

for fn=1:length(fannames)
    
    axes(ha(fn));
    
    fan_data = fans{fn};
%     surface_figure = figure;
    cf = distance_sorted.(fannames{fn});
    s_names = fieldnames(cf);
    surface_names = s_names;
    legend_items = [];
    legend_labels = {};
    surface_wolmans = [];
    surface_d84s = [];
%     surface_figure = figure()
    
    for sn=1:length(s_names)
        surface_data = fan_data{sn};
        surface = cf.(s_names{sn});
        ss = surface_data.ss;
        ed = -4.5:1:8.5;
        xp = [-4:1:8];
        all_x = [];
        all_y = [];

        for k=1:length(ss)
           [N,edges] = histcounts(ss{k}, ed);
           fD = N./sum(N);
           plot(xp,fD, 'Color' , [.7 .7 .7]);
           meta = surface_data.meta{k};
           hold on;
           if max(N) > 70
               disp([s_names{sn} meta.name meta.site]);
           end
           all_x = [all_x; xp];
           
           
           all_y = [all_y; fD];
           
        end

        plot(all_x,all_y, 'x');
        
    end
    textLoc(fannames{fn}, 'northeast');
    ylim([0,.6])
    
    
 
end

set(ha(1:2),'XTickLabel',''); set(ha(2),'YTickLabel',''); set(ha(4),'YTickLabel','')
h = supertitle('Self-Similarity Curves');
P = get(h,'Position');
set(h,'Position',[P(1) P(2)+0.03 P(3)]);
print(sfig, '-dpdf', [output_path '2015_self_similarity' '.pdf'])

