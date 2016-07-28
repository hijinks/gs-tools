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

J_1 = struct('G8', struct('A', 0, 'B', 0, 'C', 0, 'D', 0), 'G10', struct('A', 0, 'B', 0, 'C', 0, 'D', 0), 'T1', struct('A', 0, 'C', 0, 'E', 0));
stdev_s = struct('G8', struct('A', 0, 'B', 0, 'C', 0, 'D', 0), 'G10', struct('A', 0, 'B', 0, 'C', 0, 'D', 0), 'T1', struct('A', 0, 'C', 0, 'E', 0));
means_s = struct('G8', struct('A', 0, 'B', 0, 'C', 0, 'D', 0), 'G10', struct('A', 0, 'B', 0, 'C', 0, 'D', 0), 'T1', struct('A', 0, 'C', 0, 'E', 0));

vert_position1 = [1,3,5];
vert_position2 = [2,4,6];


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

            formatSpec = '%f%f%f%f%f%f%f%f%f%q%q%q%q%q%q%q%q%q%[^\n\r]';

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
             means = dataArray{:, 16};
             stdev = dataArray{:, 17};
        %     CV2 = dataArray{:, 18};
        
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
            
            J_1.(d{1}).(d{2}) = interp1(J_vals,gs_predict,[1]);
            means_s.(d{1}).(d{2}) = mean(means);
            stdev_s.(d{1}).(d{2}) = mean(stdev);
            
            xlim([0 200]);
%             ylim([0 3]);
            ss_cumul = [ss_cumul; ss_vars'];
            gs_cumul = [gs_cumul; gs_predict'];
            gs_predictions = [gs_predictions, gs_predict'];
            J_values = [J_values, J_vals'];
            fit_fraction = [fit_fraction,fraction1];
            fit_ss = [fit_ss, ss_var1];
            
        end
    end
end

% Prep fan data
color_map = [[0 0.4980 0]; [0.8706 0.4902 0]; [0.8 0 0]; [0.2039 0.3020 0.4941]; [1 0 1]; [0 0 0]];
line_styles = {'-','-k','-g','-r','-b','-c'};
point_styles = {'xm','xk','xg','xr','xb','xc'};
line_point_styles = {'x-','xk-','xg-','xr-','xb-','xc-'};
% Downstream fining plots
fannames = {'G8', 'G10', 'T1'};

fans = {g8_data, g10_data, t1_data};

fannames = fieldnames(distance_sorted);

plot_i = 0;
for fn=1:length(fannames)

    cf = distance_sorted.(fannames{fn});
    s_names = fieldnames(cf);
    surface_names = s_names;
    legend_items = {};
    legend_labels = [];
    surface_wolmans = [];
    surface_d84s = [];
    J_values = [];
    stdev_values = [];
    means_values = [];
    J_labels = s_names;
    
    for sn=1:length(s_names)
        surface = cf.(s_names{sn});
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
        max_dist = max(distances);
        norm_dist = distances./max_dist;
        wolmans = cell2mat(surface(:,2)');
        d84s = zeros(1,len);
        errors = zeros(1,len);
        
        J_values = [J_values; J_1.(fannames{fn}).(s_names{sn})];
        stdev_values = [stdev_values; means_s.(fannames{fn}).(s_names{sn})];
        means_values = [means_values; stdev_s.(fannames{fn}).(s_names{sn})];
    end
    
    subplot(3,2,vert_position2(fn));
    j1 = plot(J_values, 'x-');
       
    ylim([0, 30]);
    end_v = length(s_names)+.5;
    xlim([.5, end_v]);
    set(gca,'xtick',1:length(s_names), 'xticklabel',s_names)
    title([fannames{fn}, ' surface relative mobility (J=1)'])
    xlabel('Surfaces');
    ylabel('Grain size (mm)');
    
    subplot(3,2,vert_position1(fn));
    boxplot(surface_wolmans, 'DataLim', [0 200], 'ExtremeMode', 'clip', 'symbol', '','Labels', surface_names);

    hold on;
    sd = plot(surface_d84s, 'kx-');
    hold on;
    std = plot(stdev_values, 'mo-');
    
    
    xlabel('Surfaces');
    ylabel('Grain size(mm)');
    set(gca,'xtick',1:length(s_names), 'xticklabel',s_names)
    legend([sd,std], {'D84', 'Stdev'}, 'Location', 'northwest');
    title([fannames{fn}, ' surface grain size variation']);
    ylim([0 200]);
end

print(f1, '-dpdf', ['pdfs/figure_8' '.pdf'])
print(f1, '-depsc', ['pdfs/figure_8' '.eps'])
