% Colormaps and fan datum coordinates

clrs = struct();
ages = struct();

% Holocene palette
warm_colours = colormap(hot);

% Pleistocene palette
cold_colours = colormap(bone);
cold_colours2 = colormap(winter);

clrs.G10 = struct();
clrs.G8 = struct();
clrs.T1 = struct();

l = 6;
d = floor(64/l);
clrs.G10.A = warm_colours(1*d, :);
clrs.G10.B = warm_colours(2*d, :);
clrs.G10.C = cold_colours2(1*d, :);
clrs.G10.D = cold_colours2(2*d, :);
clrs.G10.E = cold_colours(3*d, :);
clrs.G10.F = cold_colours(4*d, :);

l = 4;
d = floor(64/l);
clrs.G8.A = warm_colours(1*d, :);
clrs.G8.B = warm_colours(2*d, :);
clrs.G8.C = cold_colours2(1*d, :);
clrs.G8.D = cold_colours2(2*d, :);

l = 3;
d = floor(64/l);
clrs.T1.A = warm_colours(1*d, :);
clrs.T1.C = cold_colours2(1*d, :);
clrs.T1.E = cold_colours(2*d, :);


ages.G10.A = 'Holocene   ';
ages.G10.B = 'Holocene   ';
ages.G10.C = 'Pleistocene';
ages.G10.D = 'Pleistocene';
ages.G10.E = 'Pleistocene';
ages.G10.F = 'Pleistocene';

ages.G8.A = 'Holocene   ';
ages.G8.B = 'Holocene   ';
ages.G8.C = 'Pleistocene';
ages.G8.D = 'Pleistocene';

ages.T1.A = 'Holocene   ';
ages.T1.C = 'Pleistocene';
ages.T1.E = 'Pleistocene';


origins = struct('G10',[36.7765850388, -117.1271739900], ...
    'G8', [36.77300833333333, -117.11081944444445], ...
    'T1',[36.57948, -117.103]);