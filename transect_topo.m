% View transects relative to DEM

addpath('./topotoolbox');
addpath('./topotoolbox/tools_and_more');

dem = GRIDobj('dems/grapevine_dem3.tif');
dem = inpaintnans(dem);
[coord_table] = get_coords('coordinates/G8_coords.csv')

locations = []
surface = g10_data{2};

for p=1:length(surface.meta)
   meta = surface.meta{p};
   d = surface.distance(p);
   location = meta.location;
   sl = strsplit(location, ' ');
   r = [d, str2num(sl{1}), str2num(sl{2})];
   locations = [locations; r];
end

distance_sorted = sortrows(locations);

xy = [distance_sorted(:,2),distance_sorted(:,3)];
SW = SWATHobj(dem,xy, 'width', 10, 'plot', true);

[MS] = SWATHobj2mapstruct(SW,'lines');
figure, imageschs(dem), hold on
mapshow(MS)