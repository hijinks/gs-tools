addpath('./scripts');
addpath('./lib');

X = 42.0;                  %# A3 paper size
Y = 29.7;                  %# A3 paper size
xMargin = 0;               %# left/right margins from page borders
yMargin = 4;               %# bottom/top margins from page borders
xSize = X - 2*xMargin;     %# figure size on paper (widht & hieght)
ySize = Y - 2*yMargin;     %# figure size on paper (widht c& hieght)

fan_width_data;

fan_names = fieldnames(fan_lobes);

for f=1:length(fan_names)
   	fan_ds = distance_sorted.(fan_names{f});
    fan_ls = fan_lobes.(fan_names{f});
    fan_ls_s = fieldnames(fan_ls);
    origins = fan_origins.(fan_names{f});
    cf = distance_sorted.(fan_names{f});
    fan_data = fans{f};

    rows = 2;
    cols = ceil(length(fan_ls_s)/rows);
    figure
    
    for s=1:length(fan_ls_s)
   
        sb = subplot(rows,cols, s);
 
        surface = fan_data{s};
        surface_ds = cf.(fan_ls_s{s});

        d84s = zeros(length(surface_ds(:,1)), 1);
        d50s = zeros(length(surface_ds(:,1)), 1);
        d70s = zeros(length(surface_ds(:,1)), 1);
        means = zeros(length(surface_ds(:,1)), 1);
        errors = zeros(length(surface_ds(:,1)), 1);
        
        for k=1:length(surface_ds(:,1))
            site = surface_ds(k,:);
            wm = site{2};
            wm(isnan(wm)) = [];
            errors(k) = (prctile(wm, 60)-prctile(wm, 40))/2;
            d84s(k) = prctile(wm, 84);
            d70s(k) = prctile(wm, 70);
            d50s(k) = prctile(wm, 50);
            means(k) = mean(wm);
        end

        distance = cell2mat(surface_ds(:,1));

        initial_wolman = surface_ds{1,2};
        initial_wolman(isnan(initial_wolman)) = [];

        field_ds = boundedline(distance, d50s, errors, '-x', 'alpha', 'cmap', [0.8196    0.8196    0.8510]);

        C1 = .7;
        CV = mean(surface.cv_norm);
        C2 = C1/CV;        
        
        params = struct();
        params.uplift = 1e-4; %m/yr
        params.qs = 10000; %m^3/yr
        params.yrs = 1;
        params.grainpdf =  log10(d50s(1));
        params.phi = log10(d84s(1)/d50s(1));
        params.C1 = C1;
        params.Cv = CV;
        params.C2 = C2;
        params.origin_x = origins(1);
        params.origin_y = origins(2);

        shp = fan_ls.(fan_ls_s{s});
        ds = fan_ds.(fan_ls_s{s});
        [dist, width] = lobe_width(shp, ds, [origins(1),origins(2)]);
        [downstream_m,grain_ds] = ds_predict(shp, ds, dist, width, params);

        xlabel('Distance (m)');
        ylabel('Grain size(mm)');
        
        hold on;

        run_params = {['\bf CV', '\rm ',  num2str(CV)], ...
            ['\bf C1 ', '\rm ',  num2str(C1)], ...
            ['\bf C2 ', '\rm ', num2str(C2)]
        };

        textbp(run_params,'EdgeColor', 'black', 'FontSize', 8, 'Parent', sb);

        predicted_ds = plot(downstream_m, grain_ds, 'k-');
        legend([field_ds, predicted_ds], {'Field Mean', 'Predicted Mean'}, 'Location', 'SE')

        v = axis;
        title(fan_ls_s{s});
        ylim([0 100]);
    end
end