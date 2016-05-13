% Assuming that figures are in fs struct

fannames = fieldnames(distance_sorted);

X = 20;                  %# A3 paper size
Y = 15;                  %# A3 paper size
xMargin = 0;               %# left/right margins from page borders
yMargin = 2;               %# bottom/top margins from page borders
xSize = X - 2*xMargin;     %# figure size on paper (widht & hieght)
ySize = Y - 2*yMargin;     %# figure size on paper (widht & hieght)

% 1 = downstream grain size
% 2 = self similarity
% 3 = coefficient of variation

mode = 3;

for fn=1:length(fannames)
    cf = distance_sorted.(fannames{fn});
    fan_data = fans{fn};
    s_names = fieldnames(cf);
    
    f = figure();
    set(f, 'Position', [0,0, 800, 600])
    set(f, 'PaperSize',[X Y]);
    set(f, 'PaperPosition',[0 yMargin xSize ySize])
    set(f, 'PaperUnits','centimeters');
    axes('Units','Normal');
    h = title([fannames{fn} ' - Surfaces'])     
    set(gca,'visible','off');
    set(gca, 'FontSize',16);
    set(h,'visible','on')
    pos=get(h,'Position')
    pos(2) = 1.05
    set(h,'Position',pos)
    
    if length(s_names) > 4
        tbs = tight_subplot(2,3,[.07 .07],[.07 .07],[.05 .05]);
    else
        tbs = tight_subplot(2,2,[.07 .07],[.07 .07],[.05 .05]);
    end
    
    for sn=1:length(s_names)
        
        surface_data = fan_data{sn}
        dat = cf.(s_names{sn});
       
        axes(tbs(sn));
        
        if mode == 1
            plot_surface(dat);
        elseif mode == 2
            ss_fit(surface_data)
        elseif mode == 3
            scatter(surface_data.distance,surface_data.cv_median,'SizeData', 30 )
            xlabel('Distance (m)');
            ylabel('Coefficient of variation');
            ylim([0,1.2]);
            set(gca, 'FontSize',14);
        elseif mode == 4
        
        end
        title(s_names{sn})
        set(gca, 'FontSize',14);
%        if strcmp(fannames{fn}, 'T1') > 0
%           dem = grotto_dem; 
%        else
%           dem = grape_dem;
%        end
% 
%        coords = cell2mat(dat(:,3));
% 
%        [dn,z] = demprofile(dem, 500, coords(:,1), coords(:,2));
% 
%        plot(dn,z)
%        xlabel('Distance downstream (m)');
%        ylabel('Elevation (m)');
%        ylim([0,500])
    end
    print(f, '-dpdf', ['dump/really_new/' fannames{fn} '_' num2str(mode) '.pdf'])

end