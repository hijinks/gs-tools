% Assuming that figures are in fs struct

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
    
    for sn=1:length(s_names)
        f = figure('Menubar','none');
        set(f, 'Position', [0,0, 1200, 800])
        set(f, 'PaperSize',[X Y]);
        set(f, 'PaperPosition',[0 yMargin xSize ySize])
        set(f, 'PaperUnits','centimeters');
        
        axes('Units','Normal');
        h = title([fannames{fn} ' - Surface ' s_names{sn}]) 
        set(gca,'visible','off')
        set(h,'visible','on')
        pos=get(h,'Position')
        pos(2) = 1.05
        set(h,'Position',pos)
        surface_data = fan_data{sn}
        dat = cf.(s_names{sn});
               
       r = dat(:,2);
       wm = cell2mat(r');
           
       tbs = tight_subplot(2,2,[.07 .07],[.07 .07],[.05 .05]);
       axes(tbs(1));
       cx = tbs(1);
       ss = size(wm);
       
       for y=1:ss(2)
           hold on;
           dd = wm(:,y);
           dd(isnan(dd))=[]
           cdfplot(dd)
           ylim([0,1])
           xlim([0,400])
       end
       cx.XTick = [0 100 200 300 400]
       
       axes(tbs(2));
       boxplot(wm);
       xlabel('Sites');
       ylabel('Grain size(mm)');
       
       axes(tbs(3));
       plot_surface(dat);
       
       axes(tbs(4));
       
       ss_fit(surface_data)
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
       print(f, '-dpdf', ['dump/new/' fannames{fn} '_' s_names{sn} '.pdf'])
    end
    
end