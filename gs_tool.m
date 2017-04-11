% Grain size analysis tool

% Set of scripts to extract, analyse and display grain size data 
% from fieldwork or photographs.

addpath('./scripts');
addpath('./lib');

% g10_data = fan_data('G10',[36.7765850388, -117.1271739900], 'coordinates/G10_coords.csv');
% g8_data = fan_data('G8',[36.77300833333333, -117.11081944444445], 'coordinates/G8_coords.csv');
% t1_data = fan_data('T1', [36.57948, -117.103], 'coordinates/T1_coords.csv');
% sr1_data = fan_data('SR1', [33.317537, -116.177939], 'coordinates/SR1_coords.csv');

gc_data = fan_data('GC', [36.015715	-116.925868], 'coordinates/GC_coords.csv');
hp_data = fan_data('HP', [36.20487	-116.978697], 'coordinates/HP_coords.csv');