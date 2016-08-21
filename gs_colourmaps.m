sf_fans = fieldnames(distance_sorted);


for p=1:length(sf_fans);
    current_fan = distance_sorted.(sf_fans{p});
    current_fan_surfaces = fieldnames(current_fan);

    for s=1:length(current_fan_surfaces)
        
        current_surface = current_fan.(current_fan_surfaces{s});
        wolmans = current_surface(:,2);
        
        wolman_columns = cell(length(wolmans),1);
        for w=1:length(wolmans)
            wm = wolmans{w};
            wm(isnan(wm)) = [];
            wc = imresize(sort(wm),[30000 1]);
            wolman_columns{w} = wc';
        end
        wc = cell2mat(wolman_columns);
        figure
        imagesc(wc);
        colorbar;
        title([sf_fans{p} ' ' current_fan_surfaces{s}]);
    end
end
