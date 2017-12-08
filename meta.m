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
clrs.SR1 = struct();

l = 6;
d = floor(64/l);
clrs.G10.A = warm_colours(1*d, :);
clrs.G10.B = warm_colours(2*d, :);
clrs.G10.C = cold_colours2(1*d, :);
clrs.G10.D = cold_colours2(2*d, :);
clrs.G10.E = cold_colours(.5*d, :);
clrs.G10.F = cold_colours(4*d, :);

l = 4;
d = floor(64/l);
clrs.G8.A = warm_colours(1*d, :);
clrs.G8.B = warm_colours(2*d, :);
clrs.G8.C = cold_colours2(1*d, :);
clrs.G8.D = cold_colours2(2*d, :);

l = 4;
d = floor(64/l);
clrs.T1.A = warm_colours(1*d, :);
clrs.T1.C = cold_colours2(1*d, :);
clrs.T1.E = cold_colours(.5*d, :);

l = 4;
d = floor(64/l);
clrs.SR1.A = warm_colours(1*d, :);
clrs.SR1.B = warm_colours(2*d, :);
clrs.SR1.C = warm_colours(3*d, :);
clrs.SR1.D = cold_colours2(1*d, :);

l = 4;
d = floor(64/l);
clrs.GC.A = [0    0.8000         0];
clrs.GC.B = warm_colours(2*d, :);
clrs.GC.D = cold_colours2(1*d, :);

l = 4;
d = floor(64/l);

clrs.HP.A = [0    0.8000         0];
clrs.HP.B = warm_colours(2*d, :);
clrs.HP.C = cold_colours2(1*d, :);


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

ages.GC.A = 'Holocene   ';
ages.GC.B = 'Holocene   ';
ages.GC.D = 'Pleistocene';

ages.HP.A = 'Holocene   ';
ages.HP.B = 'Holocene   ';
ages.HP.C = 'Pleistocene';

symbols.G10.A = '^';
symbols.G10.B = '+';
symbols.G10.C = 's';
symbols.G10.D = 'x';
symbols.G10.E = 'd';
symbols.G10.F = 'o';

symbols.G8.A = '^';
symbols.G8.B = '+';
symbols.G8.C = 's';
symbols.G8.D = 'x';

symbols.T1.A = '^';
symbols.T1.C = 's';
symbols.T1.E = 'd';

symbols.SR1.A = '^';
symbols.SR1.B = 's';
symbols.SR1.C = 'x';
symbols.SR1.D = '+';

symbols.GC.A = '^';
symbols.GC.B = 's';
symbols.GC.D = 'x';

symbols.HP.A = '^';
symbols.HP.B = 's';
symbols.HP.C = 'x';

origins = struct('G10',[36.7765850388, -117.1271739900], ...
    'G8', [36.77300833333333, -117.11081944444445], ...
    'T1',[36.57948, -117.103], 'SR1', [33.317044, -116.178552],...
'GC',[36.015715,-116.925868],'HP',[36.20487,-116.97869]);