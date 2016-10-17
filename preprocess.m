% RUN FIRST

% Correctly sort fan surface points by distance

addpath('./lib');

fan_names = {'G8', 'G10', 'T1'};
fans = {g8_data, g10_data, t1_data};

distance_sorted = surface_stats(fan_names, fans);

[s_C1, s_C2] = C1_C2(distance_sorted);