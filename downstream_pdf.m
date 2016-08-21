sf_fans = fieldnames(distance_sorted);

colours = colormap(bone);


for p=1:length(sf_fans);
    current_fan = distance_sorted.(sf_fans{p});
    current_fan_surfaces = fieldnames(current_fan);

    for s=1:length(current_fan_surfaces)
        figure
        
        current_surface = current_fan.(current_fan_surfaces{s});
        wolmans = current_surface(:,2);
        pds = cell(length(wolmans),1);
        x_values = 0:1:250;
        d = floor(64/length(wolmans));

        for w=1:length(wolmans)
            wm = wolmans{w};
            wm(isnan(wm)) = [];
            pd = fitdist(wm,'Normal');
            y = pdf(pd, x_values);
            plot(x_values, y, 'Color', colours(w*d, :));
            hold on;
        end

        title([sf_fans{p} ' ' current_fan_surfaces{s}]);
    end
end
