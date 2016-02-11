
figure

[grapevine, D] = geotiffread('maps/clipped.tif');
R = grapevine(:,:,1);
G = grapevine(:,:,2);
B = grapevine(:,:,3);

mapshow(cat(3,R,G,B), D)
coord_table = get_coords('G8_coords.csv',2, 63);
coord_table2 = get_coords('G10_coords.csv',2, 63);
lat_utm = []
lon_utm = []
lat_utm2 = []
lon_utm2 = []
for c=1:height(coord_table)
    row = coord_table(c,:);
    [ix,iy,iu,iutm1] = wgs2utm(row.lat, row.lon, 11, 'N')
    lat_utm = [lat_utm, ix];
    lon_utm = [lon_utm, iy];
end

for c=1:height(coord_table2)
    row = coord_table2(c,:);
    [ix,iy,iu,iutm1] = wgs2utm(row.lat, row.lon, 11, 'N')
    lat_utm2 = [lat_utm2, ix];
    lon_utm2 = [lon_utm2, iy];
end


mapshow(lat_utm,lon_utm, 'DisplayType', 'point')
mapshow(lat_utm2,lon_utm2, 'DisplayType', 'point')


