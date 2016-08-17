Y = 29.7;                  %# A3 paper size
X = 21.0;                  %# A3 paper size
xMargin = 0;               %# left/right margins from page borders
yMargin = 1;               %# bottom/top margins from page borders
xSize = X - 2*xMargin;     %# figure size on paper (widht & hieght)
ySize = Y - 2*yMargin;     %# figure size on paper (widht & hieght)

csv_dir = ['.' filesep 'data' filesep 'jfits'];

dir_search = subdir(csv_dir);

surfaces = [];
ag = nan(length(dir_search),1);
bg = nan(length(dir_search),1);
cg = nan(length(dir_search),1);
C1 = nan(length(dir_search),1);
C2 = nan(length(dir_search),1);
CV = nan(length(dir_search),1);
row_names = cell(length(dir_search),1);
fan_names = {'G8', 'G10', 'T1'};
fans = {g8_data, g10_data, t1_data};

fan_surface_data = struct();
for o=1:length(fan_names);
    fdat = fans{o};
    sdat = struct();
    for k=1:length(fdat)
        sdat.(fdat{k}.name) = fdat{k};
    end
    fan_surface_data.(fan_names{o}) = sdat;
end


fnames = {};
fan_categories = {};
surfaces = {};

f1 = figure;
f1 = figure('Menubar','none');
set(f1, 'Position', [0,0, 1200, 800])
set(f1, 'PaperSize',[X Y]);
set(f1, 'PaperPosition',[0 yMargin xSize ySize])
set(f1, 'PaperUnits','centimeters');
% set(f1, 'Visible', 'off');

ss_cumul = [];
gs_cumul = [];
J_values = {};
gs_predictions = {};
subplotNumbers = struct('G8', [1 2], 'G10', [3 4], 'T1', [5 6]);

fit_ss = [];
fit_fraction = [];

ha = tight_subplot(3, 2, [.02 .01], [.1 .05], [.15 .05]);
plot_titles = {};

for j=1:(length(dir_search)),
    [pathstr,fname,ext] = fileparts(dir_search(j).name);
    if strcmp(ext,'.csv') > 0
        row_names{j} = fname;
        fnames{j} = fname;
        if isempty(fname) < 1

            d = strsplit(fname, '_');
            fan_categories = [fan_categories, fname];
            surfaces = [surfaces, d{2}];
            surface_data = fan_surface_data.(d{1}).(d{2});
            delimiter = ',';
            startRow = 2;

            formatSpec = '%f%f%f%f%f%f%f%f%f%q%q%q%q%q%q%q%[^\n\r]';

            %% Open the text file.
            fileID = fopen(dir_search(j).name,'r');

            textscan(fileID, '%[^\n\r]', startRow-1, 'WhiteSpace', '', 'ReturnOnError', false);
            dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'ReturnOnError', false);

            fclose(fileID);
            spp = subplotNumbers.(d{1});
            

            
             J1 = dataArray{:, 1};
        %     Jprime1 = dataArray{:, 2};
        %     phi1 = dataArray{:, 3};
        %     sym1 = dataArray{:, 4};
        %     sigma2 = dataArray{:, 5};
        %     expsym1 = dataArray{:, 6};
        %     intsysmeps1 = dataArray{:, 7};
             fraction1 = dataArray{:, 8};
             ss_var1 = dataArray{:, 9};
        %     int_constant_ana1 = dataArray{:, 10};
             ag1 = dataArray{:, 13};
             bg1 = dataArray{:, 14};
             cg1 = dataArray{:, 15};
        %     C3 = dataArray{:, 14};
        %     C4 = dataArray{:, 15};
        %     CV2 = dataArray{:, 16};
        
            a = str2num(ag1{1});
            b = str2num(bg1{1});
            c = str2num(cg1{1});

            stdev = surface_data.stdev;
            means = surface_data.mean;
            
            J_vals = c:.005:3;
            ss_vars = -log((J_vals-c)/a)/b;
            m_stdev = mean(stdev);
            m_mean = mean(means);
            gs_predict = (ss_vars.*mean(stdev))+mean(means);
            
            xlim([0 200]);
%             ylim([0 3]);
            ss_cumul = [ss_cumul; ss_vars'];
            gs_cumul = [gs_cumul; gs_predict'];
            gs_predictions = [gs_predictions, gs_predict'];
            J_values = [J_values, J_vals'];
            fit_fraction = [fit_fraction,fraction1];
            fit_ss = [fit_ss, ss_var1];
            axes(ha(spp(1)));
            p1 = plot(ss_vars, J_vals, '-', 'Color', clrs.(d{1}).(d{2}) );
            xlim([-2 5]);
            ylim([0 3]);
            hold on;
            ss_vars(isinf(ss_vars)) = [];
            ss_padding = [max(ss_vars),5]
            plot(ss_padding, ones(1, length(ss_padding))*min(J_vals), ':', 'Color', [.7,.7,.7]);
            hold on;
            axes(ha(spp(2)));
            p2 = plot(gs_predict, J_vals, '-', 'Color', clrs.(d{1}).(d{2}) );
            ylim([0 3]);
            hold on;
            gs_predict(isinf(gs_predict)) = [];
            ss_padding = [max(gs_predict),300]
            plot(ss_padding, ones(1, length(ss_padding))*min(J_vals), ':', 'Color', [.7,.7,.7]);
            hold on;
            ylim([0 3]);
        end
    end
end


I = find(gs_cumul<0);
ss_cumul(I) = [];
gs_cumul(I) = [];
[sort_ss_cumul, Ix] = sort(ss_cumul);
sort_gs_cumul = gs_cumul(Ix);

Infindexes = find(isinf(sort_gs_cumul));
sort_gs_cumul(Infindexes) = [];
sort_ss_cumul(Infindexes) = [];

[f, gof] = fit(sort_ss_cumul,sort_gs_cumul,'poly1');
[p, S] = polyfit(sort_ss_cumul,sort_gs_cumul,1);



gs_x = 0:1:300;
% Fedele & Paola 2007
a_f = 0.8;
b_f = 0.2;
c_f = 0.15;
J_vals = c_f:.01:3;
ss_vars = -log((J_vals-c_f)/a_f)/b_f;
gs_f_p = (ss_vars*p(1))+p(2);
for o=1:6
    axes(ha(o));

    f = factor(o);
    
    if f(1) - 2
        p2 = plot(ss_vars, J_vals, 'k--', 'LineWidth', 1);
        hold on;
        plot([-3, 5], [1, 1], 'k:');        
    else
        p2 = plot(gs_f_p, J_vals, 'k--', 'LineWidth', 1);
        set(ha(o),'YTickLabel',''); 
        hold on;
        plot([0, 250], [1, 1], 'k:');
    end
    
    if o < 5
        set(ha(o),'XTickLabel','');
        if o < 3
            textLoc('Fan\bf G8', 'north');
            if o == 1
                title('J curve fits');
            elseif o == 2
                title('J curves grain size');
            end
        else
            textLoc('Fan\bf G10', 'north');
        end
    else
       textLoc('Fan\bf T1', 'north');
       if o == 6
          xlabel('Grain size (mm)');
       else
          xlabel('\xi');
       end
    end
        
    

end
print(f1, '-dpdf', ['pdfs/figure_7.pdf'])
print(f1, '-depsc', ['pdfs/figure_7' '.eps'])
