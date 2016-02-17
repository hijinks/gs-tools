fan_names = {'T1};
fans = {t1_data}
surface_names = struct()
surface_data = struct()


for j=1:length(fans)
    fan = fans{j};
    fan_surfaces = [];
    fan_surface_names = [];
    fan_averages = [];
    fan_name = fan_names{j};
    
    for i=1:length(fan)
        surf = fan{i};
        fan_surface_names = [fan_surface_names,surf.name];
        site_averages = mean(surf.mean);
        site_d84 = mean(surf.d84);
        site_d50 = mean(surf.d50);
        row = [site_averages,site_d50,site_d84];
        fan_surfaces = [fan_surfaces;row];
    end
    
    surface_names.(fan_name) = fan_surface_names;
    surface_data.(fan_name) = fan_surfaces;
end