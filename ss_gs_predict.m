X = 29.7;                  %# A3 paper size
Y = 21.0;                  %# A3 paper size
xMargin = 0;               %# left/right margins from page borders
yMargin = 2;               %# bottom/top margins from page borders
xSize = X - 2*xMargin;     %# figure size on paper (widht & hieght)
ySize = Y - 2*yMargin;     %# figure size on paper (widht & hieght)

csv_dir = ['.' filesep 'jfits2'];

dir_search = subdir(csv_dir);

surfaces = [];
ag = nan(length(dir_search),1);
bg = nan(length(dir_search),1);
cg = nan(length(dir_search),1);
C1 = nan(length(dir_search),1);
C2 = nan(length(dir_search),1);
CV = nan(length(dir_search),1);
row_names = cell(length(dir_search),1);
% fan_names = {'G8', 'G10', 'T1', 'SR1'};
fan_names = {'G8', 'G10', 'T1'};
% fans = {g8_data, g10_data, t1_data, sr1_data};
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

ss_cumul = [];
gs_cumul = [];
J_values = {};
gs_predictions = {};

fit_ss = [];
fit_fraction = [];
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
             ag1 = dataArray{:, 11};
             bg1 = dataArray{:, 12};
             cg1 = dataArray{:, 13};
        %     C3 = dataArray{:, 14};
        %     C4 = dataArray{:, 15};
        %     CV2 = dataArray{:, 16};
        
            a = str2num(ag1{1});
            b = str2num(bg1{1});
            c = str2num(cg1{1});

            stdev = surface_data.stdev;
            means = surface_data.mean;
            
            J_vals = c:.01:3;
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
x1 = -2:1:5;
y1 = polyval(p,x1);
figure;
scatter(sort_ss_cumul, sort_gs_cumul, 'x', 'MarkerEdgeColor', [.8,.8,.8]);
hold on;
[hl, hp] = boundedline(x1, y1, gof.rmse, 'k' ,'alpha');
ylim([0,250]);
xlabel('\xi');
ylabel('Grain size');

figure
all_gs_histogram;
hold on;
surf_size = size(fit_fraction);
for u=1:surf_size(2)
	gs = (fit_ss(:,u)*p(1))+p(2);
    plot(gs, fit_fraction(:,u), 'k-');
    xlim([0,300]);
    hold on;
end
xlabel('Grain size (mm)');
ylabel('f_{norm}');
title('Field vs. Predicted Grain size distrubition');

gs_J1 = [];
figure;
for h=1:length(gs_predictions)
    p1 = plot(gs_predictions{h}, J_values{h}, '-', 'Color', [.7,.7,.7] );
    gs_J1(h) = interp1(J_values{h},gs_predictions{h},[1]);
    hold on;
    plot(gs_J1(h), 1, 'kx');
    hold on;
end

textLoc(['J = 1 at ',num2str(floor(min(gs_J1))), ' - ', num2str(ceil(max(gs_J1))), 'mm'], 'east');
gs_x = 0:1:300;
% Fedele & Paola 2007
a_f = 0.8;
b_f = 0.2;
c_f = 0.15;
J_vals = c_f:.01:3;
ss_vars = -log((J_vals-c_f)/a_f)/b_f;
gs_f_p = (ss_vars*p(1))+p(2);
p2 = plot(gs_f_p, J_vals, 'k-', 'LineWidth', 2);

hold on;

p3 = plot([-200,300], [1,1], 'k--');
xlabel('Grain size (mm)');
ylabel('J');

legend([p1, p2, p3], {'Alluvial Fans', 'Fedele & Paola 2007', 'J = 1'});
xlim([0,200]);
title('Relative mobility curves');


       