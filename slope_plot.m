
addpath('./topotoolbox');
addpath('./topotoolbox/tools_and_more');

grape_dem = GRIDobj('dems/grapevine_dem3.tif');
grape_dem = inpaintnans(grape_dem);

grotto_dem = GRIDobj('dems/grotto_dem8.tif');
grotto_dem = inpaintnans(grotto_dem);

fannames = fieldnames(distance_sorted);

f = figure('Menubar','none');
set(f, 'PaperSize',[X Y]);
set(f, 'PaperPosition',[0 yMargin xSize ySize])
set(f, 'PaperUnits','centimeters');
    
for fn=1:length(fannames)
    
    if strcmp(fannames{fn}, 'T1') > 0
       dem = grotto_dem; 
    else
       dem = grape_dem;
    end
    
    cf = distance_sorted.(fannames{fn});
    s_names = fieldnames(cf);
    
    for sn=1:length(s_names)
       dat = cf.(s_names{sn});
       coords = cell2mat(dat(:,3));

       [dn,z] = demprofile(dem, 500, coords(:,1), coords(:,2));

       figure;
       plot(dn,z)
       ylim([0,400])
    end
end
