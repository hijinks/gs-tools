X = 29.7;                  %# A3 paper size
Y = 21.0;                  %# A3 paper size
xMargin = 0;               %# left/right margins from page borders
yMargin = 2;               %# bottom/top margins from page borders
xSize = X - 2*xMargin;     %# figure size on paper (widht & hieght)
ySize = Y - 2*yMargin;     %# figure size on paper (widht & hieght)

csv_dir = ['.' filesep 'data', filesep, 'jfits'];

dir_search = subdir(csv_dir);

surfaces = [];
ag = nan(length(dir_search),1);
bg = nan(length(dir_search),1);
cg = nan(length(dir_search),1);
C1 = nan(length(dir_search),1);
C2 = nan(length(dir_search),1);
CV = nan(length(dir_search),1);
row_names = cell(length(dir_search),1);
fnames = {};
fan_categories = {};
surfaces = {};
f1 = figure;
colormap winter

for j=1:(length(dir_search)),
    [pathstr,fname,ext] = fileparts(dir_search(j).name);
    if strcmp(ext,'.csv') > 0
        row_names{j} = fname;
        fnames{j} = fname;
        if isempty(fname) < 1

            d = strsplit(fname, '_')
            fan_categories = [fan_categories, fname];
            surfaces = [surfaces, d{2}];
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
        %     fraction1 = dataArray{:, 8};
             ss_var1 = dataArray{:, 9};
        %     int_constant_ana1 = dataArray{:, 10};
        %     ag1 = dataArray{:, 11};
        %     bg1 = dataArray{:, 12};
        %     cg1 = dataArray{:, 13};
        %     C3 = dataArray{:, 14};
        %     C4 = dataArray{:, 15};
        %     CV2 = dataArray{:, 16};
        
        
            pv = plot(ss_var1, J1);
            title('Self-similar relative mobility curves');
            set(gca,'yscale','log');
            set(gca,'fontsize',14);
            ylabel('J');
            xlabel('\xi');
            xlim([-2,5]);
            hold on;
            
            
            aglist = dataArray{1, 11};
            ag(j) = str2double(aglist{1});

            bglist = dataArray{1, 12};
            bg(j) = str2double(bglist{1});

            cglist = dataArray{1, 13};
            cg(j) = str2double(cglist{1});

            c1list = dataArray{1, 14};
            C1(j) = str2double(c1list{1});

            c2list = dataArray{1, 15};
            C2(j) = str2double(c2list{1});

            cvlist = dataArray{1, 16};
            CV(j) = str2double(cvlist{1});

            clearvars filename delimiter startRow formatSpec fileID dataArray ans;
        end
    end
end

a = 0.9;
b = 0.2;
c = 0.15;
jfunc = @(x) (a*(exp(-b*x))+c);
J = arrayfun(jfunc, ss_var1, 'UniformOutput', true)';
p5 = plot(ss_var1, J, 'k--');
legend([p5, pv], {'Fedele & Paola 2007', 'Surface fits'});
print(f1, '-dpdf', ['dump/allfits2.pdf'])

fnames = fnames(~cellfun('isempty',fnames));
ag(isnan(ag)) = [];
bg(isnan(bg)) = [];
cg(isnan(cg)) = [];
C1(isnan(C1)) = [];
C2(isnan(C2)) = [];
CV(isnan(CV)) = [];

T = table(ag,bg,cg,C1,C2,CV,'RowNames',fnames');




% Fedele & Paola 2007
a_f = 0.8;
b_f = 0.2;
c_f = 0.15;

% Mitch
a_mi = 0.15;
b_mi = 2.2;
c_mi = 0.15;
C1_mi = 0.7;
C2_mi = 0.88;
CV_mi = 0.8;


f = figure('Menubar','none');
set(f, 'Position', [0,0, 1200, 800])
set(f, 'PaperSize',[X Y]);
set(f, 'PaperPosition',[0 yMargin xSize ySize])
set(f, 'PaperUnits','centimeters');
% set(f, 'Visible', 'off');
subplot(2,3,1);
gscatter(1:1:length(ag),ag,fan_categories', '', '', '', 'off');
set(gca,'fontsize',14);
labelpoints(1:1:length(ag),ag,surfaces');

set(gca,'xticklabel',{[]});
hold on;

% F & P
plot(0:1:length(ag)+1, ones(1,length(ag)+2).*a_f, '-k');
hold on;

% Mitch
plot(0:1:length(ag)+1, ones(1,length(ag)+2).*a_mi, '--r');
hold on;

a_m = mean(ag);
plot(0:1:length(ag)+1, ones(1,length(ag)+2).*a_m, '--b');
ylim([0,1]);
xlim([0,length(ag)+1]);
title('ag');
textbp('Non-linear fit');

subplot(2,3,2);
set(gca,'fontsize',14);
gscatter(1:1:length(bg),bg,fan_categories');
labelpoints(1:1:length(bg),bg,surfaces');
set(gca,'xticklabel',{[]});
hold on;

% F & P

plot(0:1:length(bg)+1, ones(1,length(bg)+2).*b_f, '-k');

hold on;

% Mitch
plot(0:1:length(bg)+1, ones(1,length(bg)+2).*b_mi, '--r');
hold on;

b_m = mean(bg);
plot(0:1:length(bg)+1, ones(1,length(bg)+2).*b_m, '--b');
xlim([0,length(bg)+1]);

ylim([0 5]);
title('bg');
textbp('Non-linear fit');

subplot(2,3,3);
gscatter(1:1:length(cg),cg,fan_categories', '', '', '', 'off');
set(gca,'fontsize',14);
labelpoints(1:1:length(cg),cg,surfaces');
set(gca,'xticklabel',{[]});
hold on;

% F & P
p1 = plot(0:1:length(cg)+1, ones(1,length(ag)+2).*c_f, '-k');
hold on;

% Mitch
p2 = plot(0:1:length(cg)+1, ones(1,length(ag)+2).*c_mi, '--r');
hold on;

c_m = mean(cg);
p3 = plot(0:1:length(cg)+1, ones(1,length(ag)+2).*c_m, '--b');
xlim([0,length(cg)+1]);
ylim([0 1]);
title('cg');
legend([p1,p2,p3], {'Fedele & Paola 2007', 'D''Arcy et al. 2016', 'Sam 2015 (Averaged)'});
textbp('Non-linear fit');

subplot(2,3,4);
gscatter(1:1:length(C1),C1,fan_categories', '', '', '', 'off');
set(gca,'fontsize',14);
labelpoints(1:1:length(C1),C1,surfaces');
set(gca,'xticklabel',{[]});

hold on;
C1_m = mean(C1);
plot(0:1:length(C1)+1, ones(1,length(ag)+2).*C1_m, '--b');

hold on;
% Mitch
plot(0:1:length(C1)+1, ones(1,length(ag)+2).*C1_mi, '--r');
xlim([0,length(C1)+1]);
ylim([0 1]);
title('C1');
textbp('Fixed');

subplot(2,3,5);
gscatter(1:1:length(C2),C2,fan_categories', '', '', '', 'off');
set(gca,'fontsize',14);
labelpoints(1:1:length(C2),C2,surfaces');
set(gca,'xticklabel',{[]});

hold on;
C2_m = mean(C2);
plot(0:1:length(C2)+1, ones(1,length(ag)+2).*C2_m, '--b');

hold on;
% Mitch
plot(0:1:length(C2)+1, ones(1,length(ag)+2).*C2_mi, '--r');
xlim([0,length(C2)+1]);
ylim([0 1.5]);
title('C2');
textbp('Field Derived');

subplot(2,3,6);
gscatter(1:1:length(CV),CV,fan_categories', '', '', '', 'off');
set(gca,'fontsize',14);
labelpoints(1:1:length(CV),CV,surfaces');
set(gca,'xticklabel',{[]});
hold on;
CV_m = mean(CV);
plot(0:1:length(CV)+1, ones(1,length(ag)+2).*CV_m, '--b');

hold on;
% Mitch
plot(0:1:length(CV)+1, ones(1,length(ag)+2).*CV_mi, '--r');
xlim([0,length(CV)+1]);
ylim([0 1.5]);
title('CV');
textbp('Field Derived');
% print(f, '-dpdf', ['dump/jfits2.pdf'])

disp(a_m);
disp(b_m);
disp(c_m);

