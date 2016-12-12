addpath('./scripts');
addpath('./lib');

fannames = fieldnames(distance_sorted);


X = 42.0;                  %# A3 paper size
Y = 29.7;                  %# A3 paper size
xMargin = 0;               %# left/right margins from page borders
yMargin = 2;               %# bottom/top margins from page borders
xSize = X - 2*xMargin;     %# figure size on paper (widht & hieght)
ySize = Y - 2*yMargin;     %# figure size on paper (widht & hieght)
    
for fn=1:length(fannames)
    cf = distance_sorted.(fannames{fn});
    fan_data = fans{fn};
    s_names = fieldnames(cf);
    
    fig = figure;

    %set(fig,'Visible','off');
    set(fig, 'PaperSize',[X Y]);
    set(fig, 'PaperPosition',[0 yMargin xSize ySize])
    set(fig, 'PaperUnits','centimeters');

    rows = 2;
    cols = ceil(length(s_names)/rows);

    for sn=1:length(s_names)
        
        sb = subplot(rows,cols, sn);
 
        surface = fan_data{sn};
        surface_ds = cf.(s_names{sn});
        
        cv= zeros(length(surface_ds(:,1)), 1);
        
        for k=1:length(surface_ds(:,1))
            site = surface_ds(k,:);
            wm = site{2};
            wm(isnan(wm)) = [];

            cv(k) = std(wm)/mean(wm);
%             errors(k) = (prctile(wm, 60)-prctile(wm, 40))/2;
%             d84s(k) = prctile(wm, 84);
%             d70s(k) = prctile(wm, 70);
%             d50s(k) = prctile(wm, 50);
%             means(k) = ;
        end
        
        disp([fannames{fn} s_names{sn} ' ' num2str(mean(cv))])
        distance = cell2mat(surface_ds(:,1));

        initial_wolman = surface_ds{1,2};

        plot(distance, cv, 'x');
        ylim([0,1.2])
        xlabel('Distance (m)');
        ylabel('Cv');
        
        hold on;

%         run_params = {['\bf CV', '\rm ',  num2str(CV)], ...
%             ['\bf C1 ', '\rm ',  num2str(C1)], ...
%             ['\bf C2 ', '\rm ', num2str(C2)]
%         };
% 
%         textbp(run_params,'EdgeColor', 'black', 'FontSize', 8, 'Parent', sb);
% 
%         predicted_ds = plot(x, mean_gs_predict, 'k-');
%         legend([field_ds, predicted_ds], {'Field Mean', 'Predicted Mean'}, 'Location', 'SE')

        v = axis;
        title(s_names{sn});
    end
    
    stitle = supertitle(fannames{fn});
    pos = get(stitle, 'position');
    set(stitle,'position',[0.4 1.0090 0.4]);
    set(gca, 'FontSize', 14);
    
    %print(fig, '-dpdf', ['dump/cv_plots/' fannames{fn} '_cv' '.pdf'])

end
