% Plot per fan per surface self similarity curves
Y = 29.7;                  %# A3 paper size
X = 21.0;                  %# A3 paper size
xMargin = 0;               %# left/right margins from page borders
yMargin = 1;               %# bottom/top margins from page borders
xSize = X - 2*xMargin;     %# figure size on paper (widht & hieght)
ySize = Y - 2*yMargin;     %# figure size on paper (widht & hieght)

export = 0;
fannames = {'G8', 'G10', 'T1'};

fan_data = {g8_data, g10_data, t1_data};
f1 = figure('Menubar','none');
set(f1, 'Position', [0,0, 1200, 800])
set(f1, 'PaperSize',[X Y]);
set(f1, 'PaperPosition',[0 yMargin xSize ySize])
set(f1, 'PaperUnits','centimeters');

total_percent = [];
fan_surface_wolmans = {};

for fn=1:length(fannames)
    cf = distance_sorted.(fannames{fn});
    fan_data = fans{fn};
    s_names = fieldnames(cf);
    subplot(2,3,fn);
    surface_wolmans = {};
    
    for sn=1:length(s_names)

        h = title([fannames{fn} ' - Surface ' s_names{sn}]);
        surface_data = fan_data{sn};
        surface = cf.(s_names{sn});
        
        surface_wolman = cell2mat(surface(:,2));
        surface_wolman(isnan(surface_wolman)) = [];
        dif = length(bigval) - length(surface_wolman);
        pad = nan(dif,1);
        surface_wolman = [surface_wolman;pad];
        surface_wolmans = [surface_wolmans,surface_wolman];
    end    
    fan_surface_wolmans = [fan_surface_wolmans; surface_wolmans]; 
    %boxplot(surface_wolmans, 'DataLim', [0 201], 'ExtremeMode', 'clip', 'symbol', '','Labels', s_names);

end

for u=1:length(fan_names)
    
    current_fan = fan_data{u};
    current_fan_name = fan_names{u};
    
    for w=1:length(current_fan)
        
        surface_data = current_fan{w};
        wolmans = surface_data.wolmans;
        
        sub_pos = subplotNumbers.(current_fan_name);
        subplot(5,3,sub_pos(w));
        xp = -5:.5:5;
        all_x = [];
        all_y = [];
        
        if export < 1
            %figure;
        end
        
        sums_total = 0;
        bin_totals = zeros(1,length(xp)-1);
        all_y = [];
        
%         for k=1:length(wolmans)
%            h = cdfplot(wolmans{k});
%            set(h,'Color',color)
%            hold on;
%         end

        prms = nchoosek(1:1:length(fan_names),2);
        p_vals = [];
        k_vals = [];
        h_vals = [];
        ktest_mat = zeros(length(wolmans), length(wolmans));
        
        for p=1:length(prms)
            [H,P, KSSTAT] = kstest2(wolmans{prms(p,1)}, wolmans{prms(p,2)},'Alpha',0.05);
            ktest_mat(prms(p,1),prms(p,2)) = H+1;
            h_vals = [h_vals; H];
            k_vals = [k_vals; KSSTAT];
        end
        
        k = tabulate(h_vals);
        total_percent = [total_percent; k(1,3)];
        ktest_mat = tril(ktest_mat, length(wolmans))'+ktest_mat;
        pcolor(ktest_mat);
        cmap = jet(20);
        cmap = flipud(cmap(1:10,:));
        
        cmap(1,:) = [0 0 0];
        cmap(2:end-1,:) = repmat([0 1 0], length(cmap(2:end-1,:)), 1);
        cmap(end,:) = [1,1,1];
        axis square;
        caxis manual
        caxis([0 2]);
        colormap(cmap);
        set(gca,'XTickLabel','')
        set(gca,'YTickLabel','')
        textLoc([num2str(round(k(1,3))) '% pass'], 'SouthOutside')
        if export < 1
           title([current_fan_name ' ' surface_data.name]);
        else
            [file,path] = uiputfile('*.csv', 'Save Charts', ...
                [current_fan_name '_' surface_data.name]);
            dlmwrite([path file],[xp(2:end)',all_y],'delimiter',',','precision',3)
        end
        
    end
end

print(f1, '-dpdf', ['pdfs/figure_a2.pdf'])
