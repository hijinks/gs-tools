% Import script for Mitch D'Arcy's northern Death Valley grain size data

distance_sorted.Backthrust = struct();
distance_sorted.Moonlight = struct();


% Backthrust - Modern surface
filename = ['Mitch_data' filesep 'Backthrust_modern.csv'];
delimiter = ',';
startRow = 2;
formatSpec = '%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);

distance_sorted.Backthrust.Modern = struct();
distance_sorted.Backthrust.Modern.distance = dataArray{:, 1};
distance_sorted.Backthrust.Modern.d50 = dataArray{:, 4};
distance_sorted.Backthrust.Modern.d84 = dataArray{:, 5};
distance_sorted.Backthrust.Modern.mean = dataArray{:, 6};
distance_sorted.Backthrust.Modern.stdev = dataArray{:, 7};
distance_sorted.Backthrust.Modern.cv = dataArray{:, 8};
distance_sorted.Backthrust.Modern.c1 = 0.7;
distance_sorted.Backthrust.Modern.c2 = 0.88;

% Elevation = dataArray{:, 2};
% Count = dataArray{:, 3};

clearvars filename delimiter startRow formatSpec fileID dataArray ans;

% Backthrust - Q2c surface
filename = ['Mitch_data' filesep 'Backthrust_Q2c.csv'];
delimiter = ',';
startRow = 2;
formatSpec = '%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);

distance_sorted.Backthrust.Q2c = struct();
distance_sorted.Backthrust.Q2c.distance = dataArray{:, 1};
distance_sorted.Backthrust.Q2c.d50 = dataArray{:, 4};
distance_sorted.Backthrust.Q2c.d84 = dataArray{:, 5};
distance_sorted.Backthrust.Q2c.mean = dataArray{:, 6};
distance_sorted.Backthrust.Q2c.stdev = dataArray{:, 7};
distance_sorted.Backthrust.Q2c.cv = dataArray{:, 8};
distance_sorted.Backthrust.Q2c.c1 = 0.7;
distance_sorted.Backthrust.Q2c.c2 = 0.88;

% Elevation = dataArray{:, 2};
% Count = dataArray{:, 3};

clearvars filename delimiter startRow formatSpec fileID dataArray ans;

% Moonlight - Modern surface
filename = ['Mitch_data' filesep 'Moonlight_modern.csv'];
delimiter = ',';
startRow = 2;
formatSpec = '%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);

distance_sorted.Moonlight.Modern = struct();
distance_sorted.Moonlight.Modern.distance = dataArray{:, 1};
distance_sorted.Moonlight.Modern.d50 = dataArray{:, 4};
distance_sorted.Moonlight.Modern.d84 = dataArray{:, 5};
distance_sorted.Moonlight.Modern.mean = dataArray{:, 6};
distance_sorted.Moonlight.Modern.stdev = dataArray{:, 7};
distance_sorted.Moonlight.Modern.cv = dataArray{:, 8};
distance_sorted.Moonlight.Modern.c1 = 0.7;
distance_sorted.Moonlight.Modern.c2 = 0.88;

% Elevation = dataArray{:, 2};
% Count = dataArray{:, 3};

clearvars filename delimiter startRow formatSpec fileID dataArray ans;

% Moonlight - Q2c surface
filename = ['Mitch_data' filesep 'Moonlight_Q2c.csv'];
delimiter = ',';
startRow = 2;
formatSpec = '%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);

distance_sorted.Moonlight.Q2c = struct();
distance_sorted.Moonlight.Q2c.distance = dataArray{:, 1};
distance_sorted.Moonlight.Q2c.d50 = dataArray{:, 4};
distance_sorted.Moonlight.Q2c.d84 = dataArray{:, 5};
distance_sorted.Moonlight.Q2c.mean = dataArray{:, 6};
distance_sorted.Moonlight.Q2c.stdev = dataArray{:, 7};
distance_sorted.Moonlight.Q2c.cv = dataArray{:, 8};
distance_sorted.Moonlight.Q2c.c1 = 0.7;
distance_sorted.Moonlight.Q2c.c2 = 0.88;

% Elevation = dataArray{:, 2};
% Count = dataArray{:, 3};

clearvars filename delimiter startRow formatSpec fileID dataArray ans;

% FAN WIDTH DATA

filename = ['Mitch_data' filesep 'Moonlight_modern_widths.csv'];
delimiter = ',';
startRow = 2;
formatSpec = '%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
distance_sorted.Moonlight.Modern.width = [dataArray{:, 1},dataArray{:, 2}];
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

filename = ['Mitch_data' filesep 'Moonlight_Q2c_widths.csv'];
delimiter = ',';
startRow = 2;
formatSpec = '%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
distance_sorted.Moonlight.Q2c.width = [dataArray{:, 1},dataArray{:, 2}];
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

filename = ['Mitch_data' filesep 'Backthrust_modern_widths.csv'];
delimiter = ',';
startRow = 2;
formatSpec = '%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
distance_sorted.Backthrust.Modern.width = [dataArray{:, 1},dataArray{:, 2}];
clearvars filename delimiter startRow formatSpec fileID dataArray ans;


filename = ['Mitch_data' filesep 'Backthrust_Q2c_widths.csv'];
delimiter = ',';
startRow = 2;
formatSpec = '%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
distance_sorted.Backthrust.Q2c.width = [dataArray{:, 1},dataArray{:, 2}];
clearvars filename delimiter startRow formatSpec fileID dataArray ans;
