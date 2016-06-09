ds = distance_sorted.SR1;

holocene1 = ds.A;
holocene2 = ds.C;

limit = 2;

h1_dat = zeros(length(holocene1(1:end-limit,2)), 6);
h2_dat = zeros(length(holocene2(1:end-limit,2)), 6);

h1_dat(:,1) = cell2mat(holocene1(1:end-limit,1))./max(cell2mat(holocene1(1:end-limit,1)));
h2_dat(:,1) = cell2mat(holocene2(1:end-limit,1))./max(cell2mat(holocene2(1:end-limit,1)));

for i=1:length(holocene1(1:end-limit,2))
    site = holocene1{i,2};
    site(isnan(site)) = [];
    h1_dat(i,2) = prctile(site, 84);
    h1_dat(i,3) = prctile(site, 50);
    h1_dat(i,4) = mean(site);
    h1_dat(i,5) = prctile(site, 86)-prctile(site, 82);
    h1_dat(i,6) = prctile(site, 52)-prctile(site, 48);
end

for i=1:length(holocene2(1:end-limit,2))
    site = holocene2{i,2};
    site(isnan(site)) = [];
    h2_dat(i,2) = prctile(site, 84);
    h2_dat(i,3) = prctile(site, 50);
    h2_dat(i,4) = mean(site);
    h2_dat(i,5) = prctile(site, 86)-prctile(site, 82);
    h2_dat(i,6) = prctile(site, 52)-prctile(site, 48);
end

f = figure('Visible','off')
% plot(h1_dat(:,1), h1_dat(:,2), 'mx-');
% hold on;
% plot(h2_dat(:,1), h2_dat(:,2), 'kx-');
%

sv = 1:1:length(h1_dat(:,1));
e = std(h1_dat(:,2))*ones(size(sv));
h = errorbar(h1_dat(:,1), h1_dat(:,2),h1_dat(:,5), 'o-', ...
    'Color', [1 0 1], 'MarkerFaceColor', [1 0 1],  'MarkerEdgeColor', [0 0 0]);
hold on;
sv = 1:1:length(h2_dat(:,1));
e = std(h2_dat(:,2))*ones(size(sv));
h2 = errorbar(h2_dat(:,1), h2_dat(:,2),h2_dat(:,5), 'o-', ...
    'Color', [0 0 1], 'MarkerFaceColor', [0 0 1], 'MarkerEdgeColor', [0 0 0 ]);
ylim([10,160]);
xlim([0,1.1]);
set(gca,'fontsize',12);
ylabel('Grain size (mm)');
xlabel('Normalised downstream distance');
title({'Holocene Surfaces - Santa Rosa Mountain', 'D84'})
legend('1-2ka', '5-7ka');
print(f, '-dpdf', ['dump/santa_rosa/d84.pdf'])

f = figure('Visible','off')

sv = 1:1:length(h1_dat(:,1));
e = std(h1_dat(:,2))*ones(size(sv));
h = errorbar(h1_dat(:,1), h1_dat(:,3),h1_dat(:,5), 'o-', ...
    'Color', [1 0 1], 'MarkerFaceColor', [1 0 1],  'MarkerEdgeColor', [0 0 0]);
hold on;
sv = 1:1:length(h2_dat(:,1));
e = std(h2_dat(:,2))*ones(size(sv));
h2 = errorbar(h2_dat(:,1), h2_dat(:,3),h2_dat(:,5), 'o-', ...
    'Color', [0 0 1], 'MarkerFaceColor', [0 0 1], 'MarkerEdgeColor', [0 0 0 ]);
ylim([10,160]);
xlim([0,1.1]);
set(gca,'fontsize',12);
legend('1-2ka', '5-7ka');
ylabel('Grain size (mm)');
xlabel('Normalised downstream distance');
title({'Holocene Surfaces - Santa Rosa Mountain', 'D50'})
print(f, '-dpdf', ['dump/santa_rosa/d50.pdf'])


