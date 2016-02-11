% View transects relative to DEM

addpath('./scripts');
addpath('./topotoolbox');
addpath('./topotoolbox/tools_and_more');

dem = GRIDobj('dems/grapevine_dem3.tif');
dem = inpaintnans(dem);



topodata = struct();
fan_names = {'G8', 'G10'};
fans = {g8_data, g10_data};

for f=1:length(fans)
    fan_name = fan_names{f};
    current_fan = fans{f};
    surface_data = struct();
    
    for l=1:length(current_fan)
        surface = current_fan{l};
        locations = [];
        for p=1:length(surface.meta)
           meta = surface.meta{p};
           coords = surface.coords{p};
           [ix,iy,iu,iutm1] = wgs2utm(coords(1),coords(2));
           d = surface.distance(p);
           r = [d, ix, iy];
           locations = [locations; r];
        end
        distance_sorted = sortrows(locations);
        xy = [distance_sorted(:,2),distance_sorted(:,3)];
        surface_data.(surface.name) = xy;
    end
    
    topodata.(fan_name) = surface_data;
end

fnames = fieldnames(topodata)

for k=1:length(fnames)
   
end

%         for i = 1 : length(SW.xy0)
%         z_min = nanmin(SW.Z{i},[],1);
%         z_max = nanmax(SW.Z{i},[],1);
%         z_mean = nanmean(SW.Z{i},1)';
%         z_std = nanstd(SW.Z{i},0,1)';
%         dist = SW.distx{i};
%     end
    % [MS] = SWATHobj2mapstruct(SW,'lines');
% figure, imageschs(dem), hold on
% mapshow(MS)
