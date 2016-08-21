fan_lobes = struct();
fan_lobes.G8 = struct();
fan_lobes.G10 = struct();
fan_lobes.T1 = struct();
fan_lobes.SR1 = struct();
fan_lobes.Backthrust = struct();
fan_lobes.Backthrust.Modern = struct();
fan_lobes.Backthrust.Q2c = struct();
fan_lobes.Moonlight = struct();
fan_lobes.Moonlight.Q2c = struct();

fan_lobes.G10.A = 'fan_lobes/G10-A Widths.shp';
fan_lobes.G10.C = 'fan_lobes/G10-C Widths.shp';
fan_lobes.G10.D = 'fan_lobes/G10-D Widths.shp';
fan_lobes.G10.E = 'fan_lobes/G10-E Widths.shp';
fan_lobes.G8.A = 'fan_lobes/G8-A Widths.shp';
fan_lobes.T1.A = 'fan_lobes/T1-A Widths.shp';
fan_lobes.T1.C = 'fan_lobes/T1-C Widths.shp';
fan_lobes.T1.E = 'fan_lobes/T1-E Widths.shp';
fan_lobes.SR1.A = 'fan_lobes/SR1-A Widths.shp';
fan_lobes.SR1.C = 'fan_lobes/SR1-C Widths.shp';
fan_lobes.SR1.D = 'fan_lobes/SR1-D Widths.shp';

[g10sx,g10sy] = wgs2utm(36.7765850388, -117.1271739900);
[g8sx,g8sy] = wgs2utm(36.77300833333333, -117.11081944444445);
[t1sx,t1sy] = wgs2utm(36.57948, -117.103);
[sr1sx ,sr1sy] = wgs2utm(33.317537, -116.177939);

fan_origins = struct();
fan_origins.G10 = [g10sx,g10sy];
fan_origins.G8 = [g8sx,g8sy];
fan_origins.T1 = [t1sx,t1sy];
fan_origins.SR1 = [sr1sx ,sr1sy];


