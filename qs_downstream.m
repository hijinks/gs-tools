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

fan_lengths = struct();
fan_lengths.G8 = 2281;
fan_lengths.G10 = 1103;

fan_qs = struct();
fan_qs.G10 = struct();
fan_qs.G8 = struct();
% fan_qs.G10.BQART = struct('Holocene',236.2917141373,'LGM',220.6560794152);
fan_qs.G10.Fastscape = struct('Holocene',213.7996,'LGM',251.4558);
% fan_qs.G8.BQART = struct('Holocene',993.6777875663,'LGM',927.9252368494);
fan_qs.G8.Fastscape = struct('Holocene',716.8146,'LGM',843.0836);


for f=1:length(fan_names)
   	fan_ds = distance_sorted.(fan_names{f});
    fan_ls = fan_lobes.(fan_names{f});
    fan_ls_s = fieldnames(fan_ls);
    origins = fan_origins.(fan_names{f});
    cf = distance_sorted.(fan_names{f});
    fan_data = fans{f};
    
    f_qs = fan_qs.(fan_names{f});
    
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

        field_ds = boundedline(distance, d50s, errors, '-x', 'cmap', [0.5    0.5    0.5]);

        C1 = .7;
        CV = mean(surface.cv_norm);
        C2 = C1/CV;        
        
        params = struct();
        params.uplift = 0.0005; %m/yr
        params.yrs = 1;
        params.lx = fan_lengths.(fan_names{f});
        params.grainpdf =  log10(d50s(1));
        params.phi = log10(d84s(1)/d50s(1));
        params.C1 = C1;
        params.Cv = CV;
        params.C2 = C2;
        params.origin_x = origins(1);
        params.origin_y = origins(2);
        params.sub_profile = 'normal_expo';
        
        shp = fan_ls.(fan_ls_s{s});
        ds = fan_ds.(fan_ls_s{s});
        [dist, width] = lobe_width(shp, ds, [origins(1),origins(2)]);
        
        legend_plots = [field_ds];
        legend_labels = {'Field Mean'};
        
        qs_models = fieldnames(f_qs);
        for k=1:length(qs_models)
           qs_model = qs_models{k};
           model_data = f_qs.(qs_model);
           climates = fieldnames(f_qs.(qs_model));
           for k=1:length(climates)
               climate_scenario = climates{k};
               params.qs = model_data.(climate_scenario);

               [downstream_m,grain_ds,subs] = ds_predict(shp, ds, dist, width, params);

               predicted_ds = plot(downstream_m, grain_ds, '-');
               legend_plots = [legend_plots, predicted_ds];
               legend_labels = [legend_labels, [climate_scenario,' (',qs_model, ')']];
               
           end
        end

        legend(legend_plots, legend_labels, 'Location', 'SE')

        xlabel('Distance (m)');
        ylabel('Grain size(mm)');
        
        hold on;

        run_params = {['\bf CV', '\rm ',  num2str(CV)], ...
            ['\bf C1 ', '\rm ',  num2str(C1)], ...
            ['\bf C2 ', '\rm ', num2str(C2)]
        };


        textbp(run_params,'EdgeColor', 'black', 'FontSize', 8, 'Parent', sb);
        
        v = axis;
        title(fan_ls_s{s});
        ylim([0 100]);
    end
end
