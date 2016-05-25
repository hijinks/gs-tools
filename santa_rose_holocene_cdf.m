
ds = distance_sorted.SR1;

holocene1 = ds.A;
holocene2 = ds.C;

limit = 0;

h1_dat = cell2mat(holocene1(:,2)');
h2_dat = cell2mat(holocene2(:,2)');
h1_size = size(h1_dat);
h2_size = size(h2_dat);

fig = figure();

for i=1:h1_size(2)
    site = holocene1{i,2};
    site(isnan(site)) = [];
    h1 = cdfplot(site);
    set(h1,'Color','r');
    hold on;    
end


for i=1:h2_size(2)
    site = holocene2{i,2};
    site(isnan(site)) = [];
    h2 = cdfplot(site);
    set(h2,'Color','b');
    hold on;
end

title('Grain size distribution for Santa Rosa Mountain fan surfaces')
xlabel('Long axis grain size (mm)')
legend([h1, h2], {'1-2ka', '5-7ka'}, 'Location', 'SE')
xlim([0,300]);
set(gca, 'FontSize', 14);
print('-dpdf', ['fan_comparisons/' fannames{fn} '_surface_averages' '.pdf'])

% set(gca,'XScale','log');
