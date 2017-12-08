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
bigval = nan(5e5,1);

for fn=1:length(fannames)
    cf = distance_sorted.(fannames{fn});
    fan_data = fans{fn};
    s_names = fieldnames(cf);
    subplot(2,3,fn);
    surface_wolmans = [];
    
    for sn=1:length(s_names)

        h = title([fannames{fn} ' - Surface ' s_names{sn}]);
        surface_data = fan_data{sn};
        surface = cf.(s_names{sn});
        
        surface_wolman = cell2mat(surface(:,2));
        surface_wolman(isnan(surface_wolman)) = [];
        dif = length(bigval) - length(surface_wolman);
        pad = nan(dif,1);
        surface_wolman = [surface_wolman;pad];
        surface_wolmans = [surface_wolmans,surface_wolman];
    end    

    boxplot(surface_wolmans, 'DataLim', [0 201], 'ExtremeMode', 'clip', 'symbol', '','Labels', s_names);

end
% subplot(1,3,3);
% plot([] , []);
% textLoc('Comparison of Wolman vs. Photogrammetry', 'center');

legend([last_holocene, last_pleistocene, d84_line, d50_line], {'Holocene', 'Late-Pleistocene', 'D84', 'D50'}, 'Location', 'southeast');
set(gca,'FontSize', 12);

print(f, '-dpdf', ['pdfs/' 'figure_3.pdf'])
print(f, '-depsc', ['pdfs/figure_3' '.eps'])