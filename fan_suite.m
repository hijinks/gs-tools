addpath('./scripts');
addpath('./lib');

% Choose fan

% Choose dem


% Choose map


% Surface plots


% Surface comparisons

fan_names = {'G8', 'G10', 'T1'};
fans = {g8_data, g10_data, t1_data};

% [s_figs, s_stats] = surface_plots(fan_names{2}, fans{2});

[distance_sorted] = surface_stats(fan_names, fans);

% fan_comparisions(distance_sorted);