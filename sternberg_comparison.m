Y = 21.0;                  %# A3 paper size
X = 29.7;                  %# A3 paper size
xMargin = 0;               %# left/right margins from page borders
yMargin = 1;               %# bottom/top margins from page borders
xSize = X - 2*xMargin;     %# figure size on paper (widht & hieght)
ySize = Y - 2*yMargin;     %# figure size on paper (widht & hieght)
f = figure('Menubar','none');
set(f, 'Position', [0,0, 1200, 800])
set(f, 'PaperSize',[X Y]);
set(f, 'PaperPosition',[0 yMargin xSize ySize])
set(f, 'PaperUnits','centimeters');

meta;
[apex_data] = fan_apexes;

[~, ~, raw] = xlsread('/Users/sambrooke/Repos/gs-tools-data-import/backthrustq2c.xlsx','Sheet1');
raw = raw(3:end,:);
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells
data = reshape([raw{:}],size(raw));
backthrustq2c_distance = data(:,1);
backthrustq2c_mean = data(:,2);
clearvars data raw R;

[~, ~, raw] = xlsread('/Users/sambrooke/Repos/gs-tools-data-import/moonlightq2c.xlsx','Sheet1');
raw = raw(2:end,:);
data = reshape([raw{:}],size(raw));
backthrustq2c_distance = data(:,1);
moonq2c_mean = data(:,2);

clearvars data raw;

% Downstream fining plots

fans = {g10_data};

full_distances = 0:.1:6;

% G10 C
surfaces = {{'G10', 'C'},{'G8', 'C'}, {'G10', 'A'}, {'G8','A'}};
styles = {'+', 'o', 'x', 'd', '.'};
line_colours = {[0.2,0.67,0.19];[0.4,0,1];[0.8000,0,0];[0.85,0.33,0.1]};
legend_labels = {};
legend_items = [];

for q = 1:length(surfaces)
    surf_info = surfaces{q};
    
    cf = distance_sorted.(surf_info{1});
    surface = cf.(surf_info{2});



    bigval = nan(5e5,1);
    surface_d84s = [surface_d84s,prctile(cell2mat(surface(:,2)), 84)];
    surface_wolman_all = cell2mat(surface(:,2));
    surface_wolman = cell2mat(surface(:,2));
    surface_wolman(isnan(surface_wolman)) = [];
    dif = length(bigval) - length(surface_wolman);
    pad = nan(dif,1);
    surface_wolman = [surface_wolman;pad];
    surface_wolmans = [surface_wolmans,surface_wolman];
    len = length(surface(:,1));
    distances = cell2mat(surface(:,1));
    sites = cell2mat(surface(:,3));

    [apex_distance, relative_distances] = fan_apex_relative(sites, ...
        apex_data.(surf_info{1}), origins.(surf_info{1})); 

    wolmans = cell2mat(surface(:,2)');
    means = zeros(1,len);
    errors = zeros(1,len);
    cv= zeros(1, len);

    for j=1:len
        wm = wolmans(:,j);
        wm(isnan(wm)) = [];
        means(1,j) = mean(wm);
        errors(1,j) = (prctile(wolmans(:,j), 60)-prctile(wolmans(:,j), 50))/2;
        cv(1,j) = std(wm)/mean(wm);
    end
    
    if strcmp(surf_info{1}, 'T1') && strcmp(surf_info{2}, 'C')
        means(1) = [];
        distances(1) = [];
    end

    ft = fittype( 'a*exp(-b*x)', 'independent', 'x', 'dependent', 'y' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.Lower = [-Inf 0.0001];
    opts.StartPoint = [30 0.8033];
    opts.Upper = [Inf 0.9];
    distances_km = distances/1000;
    
    % Fit model to data.
    [fitresult, gof] = fit(distances_km, means', ft, opts );

    d = plot(distances_km, means', ['-' styles{q}], 'Color', line_colours{q});
    hold on;

    sternberg = fitresult.a*exp(full_distances.*-fitresult.b);
    h = plot(full_distances, sternberg, ['--'], 'Color', line_colours{q}, 'LineWidth', 1);
    %d = boundedline(relative_distances, means, errors, ['-' symbols.(fannames{fn}).(s_names{sn})], 'alpha', 'cmap', clrs.(fannames{fn}).(s_names{sn}));
    ylim([0,100]);
    hold on;
    
    legend_labels = [legend_labels, [surf_info{1} ' ' surf_info{2}],...
        [num2str(fitresult.a) 'e^{-' num2str(fitresult.b) 'x}']];
    legend_items = [legend_items,d,h];
end

% Plot Mitch's Q2c data

% Backthrst
back_means = plot(backthrustq2c_distance, backthrustq2c_mean, ['-d'], 'Color', 'k');
hold on;

a = 27.07;
b = 0.07938;       
sternberg_mitch_backthrust = a*exp(full_distances.*-b);
back_fit = plot(full_distances, sternberg_mitch_backthrust, ['--'], 'Color', 'k');

backthrustlabel = 'Backthrust Canyon Q2c';
backthrust_eqn = [num2str(a) 'e^{-' num2str(b) 'x}'];

% MOONLIGHT
moon_means = plot(moonq2c_distance, moonq2c_mean, ['-^'], 'Color', [.5,.5,.5]);
hold on;

a = 29.04;
b = 0.05858;       
sternberg_mitch_moonlight = a*exp(full_distances.*-b);
moon_fit = plot(full_distances, sternberg_mitch_moonlight, ['--'], 'Color', [.5,.5,.5]);
moonlabel = 'Moonlight Canyon Q2c';
moon_eqn = [num2str(a) 'e^{-' num2str(b) 'x}'];

legend_labels = [legend_labels, backthrustlabel, ...
    backthrust_eqn, moonlabel, moon_eqn];
legend_items = [legend_items,back_means,back_fit,moon_means,moon_fit];

% 
% if strcmp(fan_name, 'G10') > 0
%     xlim([0,1500]);
% else
%     xlim([-1000,2500]);
% end

xlabel('Downstream distance (km)');
ylabel('Mean grain size (mm)');
set(gca, 'FontSize', 12)
hold on;
grid on;

legend(legend_items,legend_labels);

print(f, '-dpdf', ['pdfs/sternberg' '.pdf'])
