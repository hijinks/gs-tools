addpath('./scripts');
addpath('./lib');

fannames = fieldnames(distance_sorted);

X = 42.0;                  %# A3 paper size
Y = 29.7;                  %# A3 paper size
xMargin = 0;               %# left/right margins from page borders
yMargin = 4;               %# bottom/top margins from page borders
xSize = X - 2*xMargin;     %# figure size on paper (widht & hieght)
ySize = Y - 2*yMargin;     %# figure size on paper (widht c& hieght)
    
for fn=1:length(fannames)
    cf = distance_sorted.(fannames{fn});
    fan_data = fans{fn};
    s_names = fieldnames(cf);
    
    fig = figure;

    set(fig,'Visible','off');
    set(fig, 'PaperSize',[X Y]);
    set(fig, 'PaperPosition',[0 yMargin xSize ySize])
    set(fig, 'PaperUnits','centimeters');

    rows = 2;
    cols = ceil(length(s_names)/rows);

    for sn=1:length(s_names)
        
        sb = subplot(rows,cols, sn);
 
        surface = fan_data{sn};
        surface_ds = cf.(s_names{sn});
        
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

        field_ds = boundedline(distance, means, errors, '-x', 'alpha', 'cmap', [0.8196    0.8196    0.8510]);

        C1 = .7;
        CV = mean(surface.cv_norm);
        C2 = C1/CV;

        grainpdf0 = log10(d50s(1)) ; % initial grain size pdf log(D50)
        phi0 = log10(d84s(1)/d50s(1)); % standard deviation of the sediment supply log(D84/D50)

        nx = 50;
        x = linspace(distance(1), distance(end), nx);
        y_star = linspace(0, 1, nx);
        mean_gs_predict = zeros(nx, 1);

        for k=1:length(x)
            pr = grainpdf0+phi0*(C2/C1)*(exp(-C1*y_star(k)-1));
            mean_gs_predict(k) = 10.^pr;
        end

        xlabel('Distance (m)');
        ylabel('Grain size(mm)');
        
        hold on;

        run_params = {['\bf CV', '\rm ',  num2str(CV)], ...
            ['\bf C1 ', '\rm ',  num2str(C1)], ...
            ['\bf C2 ', '\rm ', num2str(C2)]
        };

        textbp(run_params,'EdgeColor', 'black', 'FontSize', 8, 'Parent', sb);

        predicted_ds = plot(x, mean_gs_predict, 'k-');
        legend([field_ds, predicted_ds], {'Field Mean', 'Predicted Mean'}, 'Location', 'SE')

        v = axis;
        title(s_names{sn});
        ylim([0 100]);
    end
    
    stitle = supertitle(fannames{fn});
    pos = get(stitle, 'position');
    set(stitle,'position',[0.4 1.0090 0.4]);
    set(gca, 'FontSize', 14);
    
    print(fig, '-dpdf', ['dump/ds_predictions/' fannames{fn} '_predictions' '.pdf'])

end
