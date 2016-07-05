
surf = distance_sorted.G10.A;
name = 'G10_A';

for i=1:length(surf)
    su = surf{i,2};
    su(isnan(su)) = [];
    surf{i,2} = su;
end


mean_dat = cellfun(@(x) mean(x), surf(:,2), 'UniformOutput', true);
d84_dat = cellfun(@(x) prctile(x, 84), surf(:,2), 'UniformOutput', true);
d50_dat = cellfun(@(x) prctile(x, 50), surf(:,2), 'UniformOutput', true);

T = table(cell2mat(surf(:,1)),mean_dat,d84_dat,d50_dat);
T.Properties.VariableNames = {'Distance', 'Mean', 'D84', 'D50'};

writetable(T,[name, '.csv']);