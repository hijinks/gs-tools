% Assuming that figures are in fs struct

fannames = fieldnames(distance_sorted);

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

surface_colours;

for fn=1:length(fannames)
    cf = distance_sorted.(fannames{fn});
    fan_data = fans{fn};
    s_names = fieldnames(cf);
    subplot(2,2,fn);
    for sn=1:length(s_names)

        h = title([fannames{fn} ' - Surface ' s_names{sn}]) 
        surface_data = fan_data{sn};
        surface = cf.(s_names{sn});
        
        color = clrs.(fannames{fn}).(s_names{sn});
        if (strcmp(s_names{sn}, 'B')+(strcmp(s_names{sn}, 'A'))) < 1
           t = 1;
        else
           t = 0;
        end
        len = length(surface(:,1));
        for k=1:len
            h = cdfplot(surface{k,2}); 
            set(h,'Color',color)
            hold on;
            if t
               last_pink = h;
            else
               last_black = h; 
            end
        end
        set(h.Parent, 'xlim', [0 250])
    end
    title(fannames{fn});
end

print(f, '-dpdf', ['dump/new/' 'fan_cumfreq.pdf'])
