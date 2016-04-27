% Output model parameters

% addpath('./scripts');
% addpath('./lib');
% 
% fan_names = {'G8', 'G10', 'T1'};
% fans = {g8_data, g10_data, t1_data};
% 
% [distance_sorted] = surface_stats(fan_names, fans);

% I have randomly picked a variable

grainpdf0 = log([prctile(A, 50)]);
phi0 = log(prctile(A, 84)/prctile(A, 50));
