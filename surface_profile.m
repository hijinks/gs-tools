
for i = 1 : length(SW.xy0)
    
    z_min = nanmin(SW.Z{i},[],1);
    z_max = nanmax(SW.Z{i},[],1);
    z_mean = nanmean(SW.Z{i},1)';
    z_std = nanstd(SW.Z{i},0,1)';
    dist = SW.distx{i};
    
end
