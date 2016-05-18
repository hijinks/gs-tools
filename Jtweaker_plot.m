csv_dir = ['.' filesep 'jfits'];

dir_search = subdir(csv_dir);

surfaces = [];
ag = zeros(length(dir_search),1);
bg = zeros(length(dir_search),1);
cg = zeros(length(dir_search),1);
C1 = zeros(length(dir_search),1);
C2 = zeros(length(dir_search),1);
CV = zeros(length(dir_search),1);
row_names = cell(length(dir_search),1);
for j=1:(length(dir_search)),
    [pathstr,fname,ext] = fileparts(dir_search(j).name);
    row_names{j} = fname;
    delimiter = ',';
    startRow = 2;

    formatSpec = '%f%f%f%f%f%f%f%f%f%q%q%q%q%q%q%q%[^\n\r]';

    %% Open the text file.
    fileID = fopen(dir_search(j).name,'r');

    textscan(fileID, '%[^\n\r]', startRow-1, 'WhiteSpace', '', 'ReturnOnError', false);
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'ReturnOnError', false);

    fclose(fileID);

%     J1 = dataArray{:, 1};
%     Jprime1 = dataArray{:, 2};
%     phi1 = dataArray{:, 3};
%     sym1 = dataArray{:, 4};
%     sigma2 = dataArray{:, 5};
%     expsym1 = dataArray{:, 6};
%     intsysmeps1 = dataArray{:, 7};
%     fraction1 = dataArray{:, 8};
%     ss_var1 = dataArray{:, 9};
%     int_constant_ana1 = dataArray{:, 10};
%     ag1 = dataArray{:, 11};
%     bg1 = dataArray{:, 12};
%     cg1 = dataArray{:, 13};
%     C3 = dataArray{:, 14};
%     C4 = dataArray{:, 15};
%     CV2 = dataArray{:, 16};

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

T = table(ag,bg,cg,C1,C2,CV,'RowNames',row_names);

% Fedele & Paola 2007
a_f = 0.8;
b_f = 0.2;
c_f = 0.15;

figure
subplot(3,2,1);
plot(ag, 'x');
hold on;
plot(1:1:length(ag), ones(1,17).*a_f, '-k');
hold on;
a_m = mean(ag);
plot(1:1:length(ag), ones(1,17).*a_m, '--b');
ylim([0,1]);
xlim([1,length(ag)]);
title('ag');

subplot(3,2,2);
plot(bg, 'x');
hold on;
plot(1:1:length(bg), ones(1,17).*b_f, '-k');
hold on;
b_m = mean(bg);
plot(1:1:length(ag), ones(1,17).*b_m, '--b');
xlim([1,length(bg)]);
title('bg');

subplot(3,2,3);
plot(cg, 'x');
hold on;
plot(1:1:length(cg), ones(1,17).*c_f, '-k');
hold on;
c_m = mean(cg);
plot(1:1:length(cg), ones(1,17).*c_m, '--b');
xlim([1,length(cg)]);
title('cg');

subplot(3,2,4);
plot(C2, 'x');
hold on;
C2_m = mean(C2);
plot(1:1:length(C2), ones(1,17).*C2_m, '--b');
title('C2');

subplot(3,2,5);
plot(CV, 'x');
hold on;
CV_m = mean(CV);
plot(1:1:length(CV), ones(1,17).*CV_m, '--b');
title('CV');
