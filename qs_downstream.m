addpath('./scripts');
addpath('./lib');

output_path = ('./dump/predictions');

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
fan_lengths.T1 = 2554;
fan_lengths.SR1 = 2141;
fan_lengths.Backthrust = 7000;
fan_lengths.Moonlight = 6000;

fan_qs = struct();

fan_qs.G10.BQART = struct('Holocene',236.2917141373,'LGM',220.6560794152);
fan_qs.G10.Fastscape = struct('Holocene',213.7996,'LGM',251.4558);
fan_qs.G8.BQART = struct('Holocene',993.6777875663,'LGM',927.9252368494);
fan_qs.G8.Fastscape = struct('Holocene',716.8146,'LGM',843.0836);
fan_qs.T1.BQART = struct('Holocene',1321.149545,'LGM',1233.727894);
fan_qs.T1.Fastscape = struct('Holocene',1628.738,'LGM',1915.748);

fan_qs.SR1.BQART = struct('Holocene',712.0582853,'LGM',664.9407);

fan_qs.Backthrust.Q2c = 2981;
fan_qs.Backthrust.Modern = 2400;
fan_qs.Moonlight.Q2c = 2366;

for f=1:length(fan_names)
   	fan_ds = distance_sorted.(fan_names{f});
    fan_ls = fan_lobes.(fan_names{f});
    fan_ls_s = fieldnames(fan_ls);
    cf = distance_sorted.(fan_names{f});

    f_qs = fan_qs.(fan_names{f});

    for s=1:length(fan_ls_s)

        rows = 2;
        fig = figure('Menubar','none');
        set(fig, 'Position', [0,0, 1200, 800])
        set(fig, 'PaperSize',[X Y]);
        set(fig, 'PaperPosition',[0 yMargin xSize ySize])
        set(fig, 'PaperUnits','centimeters');
        set(gca,'visible','off')
        sb1 = subplot(2,2, 1);
        surface_ds = cf.(fan_ls_s{s});
        
        if isstruct(surface_ds) % Mitch's data
            d84s = surface_ds.d84;
            d50s = surface_ds.d50;
            means = surface_ds.mean;
            distance = surface_ds.distance;
            field_ds = boundedline(distance, means, ones(1,length(means))/1000, '-x', 'cmap', [0.5    0.5    0.5]);
            field_d84 = boundedline(distance, d84s, ones(1,length(means))/1000, '-x', 'cmap', [0.8    0.8    0.8]);
            
            params = struct();
            params.uplift = 0.0005; %m/yr
            params.yrs = 1;
            params.lx = fan_lengths.(fan_names{f});
            params.C1 = surface_ds.c1;
            params.Cv = surface_ds.cv;
            params.C2 = surface_ds.c2;
            params.grainpdf =  means(1)/1000;
            params.phi = params.grainpdf*surface_ds.cv;

            params.sub_profile = 'normal_expo';

            shp = fan_ls.(fan_ls_s{s});
            ds = fan_ds.(fan_ls_s{s});
            dist = surface_ds.width(:,1);
            width = surface_ds.width(:,2);
            qs_models = [fan_ls_s];
        else
            origins = fan_origins.(fan_names{f});   
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
            
            fan_data = fans{f};
            surface = fan_data{s};
            
            distance = cell2mat(surface_ds(:,1));

            initial_wolman = surface_ds{1,2};
            initial_wolman(isnan(initial_wolman)) = [];

            field_ds = boundedline(distance, means, errors, '-x', 'cmap', [0.5    0.5    0.5]);
            field_d84 = boundedline(distance, d84s, errors, '-x', 'cmap', [0.8    0.8    0.8]);
            C1 = .7;
            CV = mean(surface.cv_norm);
            C2 = C1/CV;    
        
            params = struct();
            params.uplift = 0.0005; %m/yr
            params.yrs = 1;
            params.lx = fan_lengths.(fan_names{f});
            params.C1 = C1;
            params.Cv = CV;
            params.C2 = C2;
            params.grainpdf =  means(1)/1000;
            params.phi = params.grainpdf*CV;

            params.origin_x = origins(1);
            params.origin_y = origins(2);
            params.sub_profile = 'normal_expo';

            shp = fan_ls.(fan_ls_s{s});
            ds = fan_ds.(fan_ls_s{s});
            [dist, width] = lobe_width(shp, ds, [origins(1),origins(2)]);
            qs_models = fieldnames(f_qs);
        end
               
        legend_plots = [field_ds, field_d84];
        legend_labels = {'Field Mean', 'Field D84'};
        
        qs_list = {};
        for k=1:length(qs_models)
           qs_model = qs_models{k};
           model_data = f_qs.(qs_model);
           
           if isstruct(f_qs.(qs_model))
                climates = fieldnames(f_qs.(qs_model));
                model_data = f_qs.(qs_model);
           else
                climates = {qs_model};
                model_data = struct(qs_model, f_qs.(qs_model));
           end
           
           for j=1:length(climates)
               
               climate_scenario = climates{j};
               params.qs = model_data.(climate_scenario);
               qs_list = [qs_list; {[qs_model ' - ' climate_scenario], params.qs}];
               [downstream_m,grain_ds,subs, fan_width, A, Depo] = ds_predict(dist, width, params);

               predicted_ds = plot(downstream_m, grain_ds, '-');
               legend_plots = [legend_plots, predicted_ds];
               legend_labels = [legend_labels, [climate_scenario,' (',qs_model, ')']];
               
           end
        end
        
        h_legend = legend(legend_plots, legend_labels, 'Location', 'best')
        set(h_legend,'FontSize',5);
        xlabel('Distance (m)');
        ylabel('Grain size(mm)');
        
        hold on;

        run_params = {
            ['\bf System length ', '\rm ',  num2str(params.lx), ' m'];
            ['\bf CV', '\rm ',  num2str(CV)];
            ['\bf C1 ', '\rm ',  num2str(C1)];
            ['\bf C2 ', '\rm ', num2str(C2)];
            ['\bf Pdf ', '\rm ',  num2str(mean(params.grainpdf)), ' mm'];
        };
     
        for h=1:length(qs_list(:,1));
            qs_val = qs_list(h,:);
            run_params = [run_params; ['\bf ',qs_val{1},' ', '\rm ',  num2str(qs_val{2})]];
        end

    
        run_params = [run_params; ['\bf Deposited ', '\rm ',  num2str(Depo),  ' m^3/yr']];
        run_params = [run_params; ['\bf Uplift ', '\rm ',  num2str(params.uplift), ' m/yr']];
       
        v = axis;
        ylim([0 max(d84s)+10]);
        
        sb2 = subplot(2,2, 2);
        plot(fan_width);
        title('Fan width');
        xlabel('Distance (m)');
        ylabel('Width (m)');
        ylim([0, 5000]);
        sb3 = subplot(2,2, 3);
        plot(subs);
        title('Subsidence profile');
        xlabel('Distance (m)');
        ylabel('Depth (m)');
        sb4 = subplot(2,2, 4);
        set(sb4,'visible','off')
        t=textLoc(run_params,'northwest');
        supertitle([fan_names{f} '-' fan_ls_s{s}]);
        print(fig, '-dpdf', [output_path '/' fan_names{f} '_' fan_ls_s{s} '.pdf'])

    end
end
