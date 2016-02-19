% View transects relative to DEM

addpath('./scripts');
addpath('./topotoolbox');
addpath('./topotoolbox/tools_and_more');

dem = GRIDobj('dems/grotto_dem7.tif');
dem = inpaintnans(dem);



topodata = struct();
fan_names = {'T1'};
fans = {t1_data};

for f=1:length(fans)
    fan_name = fan_names{f};
    current_fan = fans{f};
    surface_data = struct();
    
    for l=1:length(current_fan)
        surface = current_fan{l};
        locations = [];
        for p=1:length(surface.meta)
           meta = surface.meta{p};
           coords = surface.coords(p,:);
           c = surface.name
           locations = [locations; r];
        end
        distance_sorted = sortrows(locations);
        xy = [distance_sorted(:,2),distance_sorted(:,3)];
        SW = SWATHobj(dem,xy, 'plot', false);
        surface_data.(surface.name) = {SW, distance_sorted(1)};
    end
    
    topodata.(fan_name) = surface_data;
end

fnames = fieldnames(topodata)

plotStyle = {'m','k','g','r','b'};
xlimits = {[300 2700],[0 1500]};
ylimits = {[0 400], [0 350]};

for k=1:length(fnames)
    figure;
    surfaces = topodata.(fnames{k});
    surf_names = fieldnames(surfaces);
    legend_items = {}
    for s=1:length(surf_names)
        surf_name = surf_names{s};
        if strcmp(surf_name, 'E') < 1
            if ((strcmp(surf_name, 'D'))+(strcmp(fnames{k}, 'G10'))) < 2
                surf = surfaces.(surf_name);
                sw_surface = surf{1};
                offset = surf{2};
                for i = 1 : length(sw_surface.xy0)
                    z_min = nanmin(sw_surface.Z{i},[],1);
                    z_max = nanmax(sw_surface.Z{i},[],1);
                    z_mean = nanmean(sw_surface.Z{i},1)';
                    z_std = nanstd(sw_surface.Z{i},0,1)';
                    dist = sw_surface.distx{i};
                end
                dist = dist+offset;
                plot(dist,z_mean, plotStyle{s});
                hold on
            end
        end
        legend_items = [legend_items, surf_name]
    end
    title(strcat(fnames{k},' Surface Profiles'));
    xlim(xlimits{k})
    ylim(ylimits{k})
    xlabel('Distance (m)');
    ylabel('Z');
    legend(legend_items)
    set(gca,'fontsize', 12);
end