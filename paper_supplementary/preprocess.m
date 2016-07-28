% RUN FIRST

% Correctly sort fan surface points by distance

addpath('./lib');

fan_names = {'G8', 'G10', 'T1'};
fans = {g8_data, g10_data, t1_data};

distance_sorted = surface_stats(fan_names, fans);