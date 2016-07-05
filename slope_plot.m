
addpath('./topotoolbox');
addpath('./topotoolbox/tools_and_more');

grape_dem = GRIDobj('dems/grapevine_dem3.tif');
grape_dem = inpaintnans(grape_dem);

grotto_dem = GRIDobj('dems/grotto_dem8.tif');
grotto_dem = inpaintnans(grotto_dem);

santa_rosa_dem = GRIDobj('dems/santa_rosa.tif');
santa_rosa_dem = inpaintnans(santa_rosa_dem);

fannames = fieldnames(distance_sorted);

surface_colours;

% f = figure('Menubar','none');
% set(f, 'PaperSize',[X Y]);
% set(f, 'PaperPosition',[0 yMargin xSize ySize])
% set(f, 'PaperUnits','centimeters');


start_points = struct('G10', [36.7765850388, -117.1271739900], 'G8',[36.77300833333333, -117.11081944444445], ...
    'T1', [36.57948, -117.103], 'SR1', [33.317537, -116.177939]);

for fn=1:length(fannames)
    figure;
    
    if strcmp(fannames{fn}, 'T1') > 0
       dem = grotto_dem;
    elseif strcmp(fannames{fn}, 'SR1') > 0
       dem = santa_rosa_dem; 
    else
       dem = grape_dem;
    end
    
    cf = distance_sorted.(fannames{fn});
    start = start_points.(fannames{fn});
    
    [start_x,start_y,u1,utm1] = wgs2utm(start(1),start(2)); 
        
    s_names = fieldnames(cf);
    legend_labels = {};
    legend_items = [];
    
    for sn=1:length(s_names)
       dat = cf.(s_names{sn});
       coords = cell2mat(dat(:,3));
       start_distance = dat{1,1};
% 
%        sl = plot(coords(:,1), coords(:,2), 'ro');
%        hold on;
%        sp = plot(coords(:,1), coords(:,2), '-');
       [dn,z,xx,yy] = demprofile(dem, 500, coords(:,1), coords(:,2));
       
       distances = arrayfun(@(x,y) sqrt((x-start_x)^2+(y-start_y)^2), xx, yy);
       
       [dist_sort,I] = sort(distances);
       z_sort = z(I);
       
       mdl = fitlm(dist_sort,z_sort,'linear')
       c = mdl.Coefficients.Estimate(1);
       x1 = mdl.Coefficients.Estimate(2);
       
       dist_all = 0:1:5000;
       zy = x1.*dist_all+c;
       
       surf_colour = clrs.(fannames{fn}).(s_names{sn});
       sl = plot(dist_all,zy, 'Color' , surf_colour);
%        hold on
%        plot(dist_sort,z_sort);
%        plot(dist_sort, z_sort, 'o');
       
        legend_items = [legend_items;sl];
        legend_labels = [legend_labels;s_names{sn}];
       
       ylim([0,400]);
       title(fannames{fn})
       hold on;
    end
    legend(legend_items, legend_labels, 'Location', 'NE')
end


