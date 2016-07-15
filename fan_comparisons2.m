
% Fan slope vs. average grain size
X = 42.0;                  %# A3 paper size
Y = 29.7;                  %# A3 paper size
xMargin = 0;               %# left/right margins from page borders
yMargin = 2;               %# bottom/top margins from page borders
xSize = X - 2*xMargin;     %# figure size on paper (widht & hieght)
ySize = Y - 2*yMargin;     %# figure size on paper (widht & hieght)


fig = figure;



surfaces = []

sf_fans = fieldnames(distance_sorted);

surface_colours;

padding = {};

if any(strcmp('B',fieldnames(distance_sorted.SR1)))
	distance_sorted.SR1 = rmfield(distance_sorted.SR1,'B');
end

mean_gs = [];
mean_gs_labels = {};
mean_gs_ages = [];

for p=1:length(sf_fans)
    
%     figure;
    
    current_fan = distance_sorted.(sf_fans{p});
    current_fan_surfaces = fieldnames(current_fan);
    surface_names = {};
    wolmans = {};
    
    for s=1:length(current_fan_surfaces)
        current_surface = current_fan.(current_fan_surfaces{s});
        surface_names{s} = current_fan_surfaces{s};
        wm = cell2mat(current_surface(:,2));
        wm(isnan(wm)) = [];
        wolmans{s} = reshape(wm,[numel(wm),1]);
        
        mean_gs_ages = [mean_gs_ages; ages.(sf_fans{p}).(current_fan_surfaces{s})];
        mean_gs_labels = [mean_gs_labels; [sf_fans{p} '_' current_fan_surfaces{s}]];
        mean_gs = [mean_gs; mean(wm)];
    end
    
    maxLength=max(cellfun(@(x)numel(x),wolmans));
    
    for w=1:length(wolmans)
        wolmans{w} = [wolmans{w}; nan(maxLength-length(wolmans{w}), 1)];
        
    end
    
    wolman_mat = cell2mat(wolmans);
%     boxplot(wolman_mat, 'DataLim', [0 200], 'ExtremeMode', 'clip', 'symbol', '','Labels', surface_names);
%     title(sf_fans{p});
    
    
end

[slope_data] = surface_slope(distance_sorted);

sl = fieldnames(slope_data);

fan_surface_slopes = [];
for w=1:length(sl)
   surface_labels = fieldnames(slope_data.(sl{w}));
   surface_slopes = [];
   for k=1:length(surface_labels)
       surface_slopes(k) = abs(slope_data.(sl{w}).(surface_labels{k}){3}.Coefficients.Estimate(2));
       fan_surface_slopes = [fan_surface_slopes; atan(surface_slopes(k))];
   end
end

gscatter(fan_surface_slopes,mean_gs,mean_gs_ages,'br','xo')
labelpoints(fan_surface_slopes,mean_gs, mean_gs_labels);
xlabel('Fan surface gradient');
ylabel('Mean grain size (mm)');
title('Fan surface average grain size vs. average slope');

print(fig, '-dpdf', ['dump/comparisons/slope_vs_gs' '.pdf'])
