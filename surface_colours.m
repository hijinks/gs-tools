
clrs = struct();
ages = struct();

% Holocene palette
warm_colours = colormap(hot);

% Pleistocene palette
cold_colours = colormap(winter);


% Grey colours
grey_colours = colormap(gray);

clrs.G10 = struct();
clrs.G8 = struct();
clrs.T1 = struct();
clrs.SR1 = struct();

gs_clrs.G10 = struct();
gs_clrs.G8 = struct();
gs_clrs.T1 = struct();
gs_clrs.SR1 = struct();

l = 4;
d = floor(64/l);
clrs.G10.A = warm_colours(1*d, :);
clrs.G10.B = warm_colours(2*d, :);
clrs.G10.C = cold_colours(1*d, :);
clrs.G10.D = cold_colours(2*d, :);
clrs.G10.E = cold_colours(3*d, :);
clrs.G10.F = cold_colours(4*d, :);

l = 4;
d = floor(64/l);
clrs.G8.A = warm_colours(1*d, :);
clrs.G8.B = warm_colours(2*d, :);
clrs.G8.C = cold_colours(1*d, :);
clrs.G8.D = cold_colours(2*d, :);

l = 3;
d = floor(64/l);
clrs.T1.A = warm_colours(1*d, :);
clrs.T1.C = cold_colours(1*d, :);
clrs.T1.E = cold_colours(2*d, :);

l = 4;
d = floor(64/l);
clrs.SR1.A = warm_colours(1*d, :);
clrs.SR1.B = warm_colours(2*d, :);
clrs.SR1.C = warm_colours(3*d/4, :);
clrs.SR1.D = cold_colours(4*d, :);


l = 5;
d = floor(64/l);
clrs.G10.A = grey_colours(1*d, :);
clrs.G10.B = grey_colours(2*d, :);
clrs.G10.C = grey_colours(3*d, :);
clrs.G10.D = grey_colours(4*d, :);
clrs.G10.E = grey_colours(1*d, :);
clrs.G10.F = grey_colours(2*d, :);

l = 5;
d = floor(64/l);
clrs.G8.A = grey_colours(1*d, :);
clrs.G8.B = grey_colours(2*d, :);
clrs.G8.C = grey_colours(3*d, :);
clrs.G8.D = grey_colours(4*d, :);

l = 5;
d = floor(64/l);
clrs.T1.A = grey_colours(1*d, :);
clrs.T1.C = grey_colours(2*d, :);
clrs.T1.E = grey_colours(3*d, :);

l = 5;
d = floor(64/l);
clrs.SR1.A = grey_colours(1*d, :);
clrs.SR1.B = grey_colours(2*d, :);
clrs.SR1.C = grey_colours(3*d, :);
clrs.SR1.D = grey_colours(4*d, :);

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

ages.SR1.A = 'Holocene   ';
ages.SR1.B = 'Holocene   ';
ages.SR1.C = 'Holocene   ';
ages.SR1.D = 'Pleistocene';


markers.G10.A = '+';
markers.G10.B = 'o';
markers.G10.C = '*';
markers.G10.D = 'd';
markers.G10.E = 'x';
markers.G10.F = 's';

markers.G8.A = 'd';
markers.G8.B = 's';
markers.G8.C = 'h';
markers.G8.D = '+';

markers.T1.A = 'o';
markers.T1.C = '*';
markers.T1.E = 's';

markers.SR1.A = 'x';
markers.SR1.B = 's';
markers.SR1.C = 'd';
markers.SR1.D = 'p';


origins = struct('G10',[36.7765850388, -117.1271739900], ...
    'G8', [36.77300833333333, -117.11081944444445], ...
    'T1',[36.57948, -117.103], 'SR1', [33.317537, -116.177939]);