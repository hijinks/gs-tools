% Estimate local shear stress using grain size and slope


% Fan slope vs. average grain size
X = 42.0;                  %# A3 paper size
Y = 29.7;                  %# A3 paper size
xMargin = 0;               %# left/right margins from page borders
yMargin = 2;               %# bottom/top margins from page borders
xSize = X - 2*xMargin;     %# figure size on paper (widht & hieght)
ySize = Y - 2*yMargin;     %# figure size on paper (widht & hieght)


fig = figure;

set(fig,'Visible','off');
set(fig, 'PaperSize',[X Y]);
set(fig, 'PaperPosition',[0 yMargin xSize ySize])
set(fig, 'PaperUnits','centimeters');

surfaces = [];

sf_fans = fieldnames(distance_sorted);

surface_colours;

padding = {};

if any(strcmp('B',fieldnames(distance_sorted.SR1)))
	distance_sorted.SR1 = rmfield(distance_sorted.SR1,'B');
end

fan_surface_medians = struct();
fan_surface_means = struct();
fan_surface_distances = struct();
fan_surface_ages = struct();
fan_surface_site_locations = struct();

for p=1:length(sf_fans)
    
%     figure;
    
    current_fan = distance_sorted.(sf_fans{p});
    current_fan_surfaces = fieldnames(current_fan);
    surface_names = {};
    surface_means_all = struct();
    surface_medians_all = struct();
    surface_distances_all = struct();
    surface_site_locations_all = struct();
    surface_ages = struct();
    
    for s=1:length(current_fan_surfaces)
        current_surface = current_fan.(current_fan_surfaces{s});
        surface_names{s} = current_fan_surfaces{s};
        surface_distances = zeros(length(current_surface), 1);
        surface_site_locations = zeros(length(current_surface), 1);
        surface_means = zeros(length(current_surface), 1);
        surface_medians = zeros(length(current_surface), 1);
        
        % Each site
        for r=1:length(current_surface)
            wm = current_surface{r,2};
            wm(isnan(wm)) = [];
            
            surface_distances(r) = current_surface{r,1};
            surface_means(r) = mean(wm);
            surface_medians(r) = prctile(wm, 50);
        end
        
        surface_distances_all.(current_fan_surfaces{s}) = surface_distances;
        surface_medians_all.(current_fan_surfaces{s}) = surface_medians;
        surface_means_all.(current_fan_surfaces{s}) = surface_means;
        surface_ages.(current_fan_surfaces{s}) = ages.(sf_fans{p}).(current_fan_surfaces{s});
        surface_site_locations_all.(current_fan_surfaces{s}) = cell2mat(current_surface(:,3));
    end
    
    fan_surface_medians.(sf_fans{p}) = surface_medians_all;
    fan_surface_means.(sf_fans{p}) = surface_means_all;
    fan_surface_distances.(sf_fans{p}) = surface_distances_all;
    fan_surface_site_locations.(sf_fans{p}) = surface_site_locations_all;
    fan_surface_ages.(sf_fans{p}) = surface_ages;
end

[slope_data] = surface_slope(distance_sorted);

sl = fieldnames(slope_data);

fan_surface_slopes = struct();
for w=1:length(sl)
   surface_labels = fieldnames(slope_data.(sl{w}));
   surface_slopes = struct();
   for k=1:length(surface_labels)
       surface_slopes.(surface_labels{k}) = atan(slope_data.(sl{w}).(surface_labels{k}){3}.Coefficients.Estimate(2));
   end
   fan_surface_slopes.(sl{w}) = surface_slopes;
end


% Plotting

fan_names = fieldnames(fan_surface_means);


rho_w = 1000; % kg/m3 water
rho_g = 1680 % kg/m3 gravel

h = .3; % m
width = 10;
perimeter = 2*h*width;
areas = width*h;
radius = areas/perimeter;
g = 9.8;

[apex_data] = fan_apexes;

for f=1:length(fan_names)
    fan_name = fan_names{f};
    surface_names = fieldnames(fan_surface_means.(fan_name));
    
    for v=1:length(surface_names)
       surface_name = surface_names{v};
       colour = clrs.(fan_name).(surface_name);
       
       s_distance = fan_surface_distances.(fan_name).(surface_name);
       s_sites = fan_surface_site_locations.(fan_name).(surface_name);
       
       [apex_distance, relative_distances] = fan_apex_relative(s_sites, ...
           apex_data.(fan_name), origins.(fan_name));
       
%        s_distance = s_distance./max(s_distance);
       s_means = fan_surface_means.(fan_name).(surface_name);
       s_medians = fan_surface_medians.(fan_name).(surface_name);
       s_slope = abs(fan_surface_slopes.(fan_name).(surface_name));

       gen_c = sin(s_slope) * rho_w * g * radius; % General fluid mobility
       tau_c = gen_c ./ (rho_g - rho_w) * g .* (s_medians/1000); % Critical shear
       
%        f = fit(relative_distances, tau_c,'poly1');
%        fy = f.p1.*relative_distances.^2 + f.p2.*relative_distances + f.p3;
%        fy = f.p1.*relative_distances + f.p2;

       plot(relative_distances, tau_c, 'x', 'Color', colour);
       hold on;
%        plot(relative_distances, fy, '-', 'Color', colour);
%        hold on;
       plot([0,0], [0,1], 'k-');
       hold on;
       xlabel('Relative distance from fan apex (m)');
       ylabel('\tau^*');
       set(gca, 'FontSize', 14);
       title('Critical shear stress downstream of fan surfaces')
       
    end
end
params = {['\bf{\rho}_w \rm', num2str(rho_w)],['\bf{\rho}_s \rm', num2str(rho_g)],['\bf{h} \rm', num2str(h)], ...
     ['\bf{width} \rm', num2str(width)],['\bf{radius} \rm', num2str(radius)], ['\bf{g} \rm', num2str(g)]};
textLoc(params, 'northwest')

% gscatter(fan_surface_slopes,tau_c,mean_gs_ages,'br','xo')
% labelpoints(fan_surface_slopes,tau_c, mean_gs_labels);
% xlabel('Fan surface gradient');
% ylabel('Mean grain size (mm)');
% title('Fan surface average grain size vs. average slope');

print(fig, '-dpdf', ['dump/comparisons/critical_shear' '.pdf'])