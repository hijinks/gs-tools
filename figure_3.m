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

meta;

for fn=1:length(fannames)
    cf = distance_sorted.(fannames{fn});
    fan_data = fans{fn};
    s_names = fieldnames(cf);
    subplot(2,2,fn);
    for sn=1:length(s_names)

        h = title([fannames{fn} ' - Surface ' s_names{sn}]) 
        surface_data = fan_data{sn};
        surface = cf.(s_names{sn});
        age = ages.(fannames{fn}).(s_names{sn});
        if (strcmp(age, 'Pleistocene')) < 1
           color = warm_colours(20, :);
           t = 0;
        else
           color = cold_colours(20, :);
           t = 1;
        end
        len = length(surface(:,1));
        for k=1:len
            h = cdfplot(surface{k,2}); 
            set(h,'Color',color)
            hold on;
            if t
               last_pleistocene = h;
            else
               last_holocene = h; 
            end
        end
        set(h.Parent, 'xlim', [0 250])
    end
    title(fannames{fn});
    xlabel('Grain size');
    d84_line = plot([0,300], [.84,.84], 'k--');
    d50_line = plot([0,300], [.5, .5], 'b:');
    legend([last_holocene, last_pleistocene, d84_line, d50_line], {'Holocene', 'Pleistocene', 'D84', 'D50'}, 'Location', 'southeast');
end
subplot(2,2,4);
plot([] , []);
textLoc('Comparison of Wolman vs. Photogrammetry', 'center');
print(f, '-dpdf', ['pdfs/' 'figure_3.pdf'])
print(f, '-depsc', ['pdfs/figure_3' '.eps'])