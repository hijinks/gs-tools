
fans = fieldnames(distance_sorted);
ds_surface = distance_sorted.SR1.D;
surface_data = sr1_data{4};

fan_data = {g8_data, g10_data, t1_data, sr1_data}

Jprocess = struct();

for u=1:length(fans)
    fan_surfaces = distance_sorted.(fans{u});
    current_fan = fan_data{u};
    surfaces_names = fieldnames(fan_surfaces);
    for w=1:length(surfaces_names)
        ds_surface = fan_surfaces.(surfaces_names{w});
        surface_data = current_fan{w};
        surface_name = [fans{u} '_' surface_data.name];
        Jprocess.(surface_name) = {ds_surface,surface_data};
    end
end

JtweakOptions(Jprocess);