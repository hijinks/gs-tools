X = 29.7;                  %# A3 paper size
Y = 21.0;                  %# A3 paper size
xMargin = 0;               %# left/right margins from page borders
yMargin = 2;               %# bottom/top margins from page borders
xSize = X - 2*xMargin;     %# figure size on paper (widht & hieght)
ySize = Y - 2*yMargin;     %# figure size on paper (widht & hieght)

csv_dir = ['.' filesep 'data' filesep 'jfits'];

dir_search = subdir(csv_dir);

surfaces = [];

a_range_all = [];
b_range_all = [];

row_names = cell(length(dir_search),1);
fnames = {};
fan_categories = {};
surfaces = {};
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

            formatSpec = '%f%f%f%f%f%f%f%f%f%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%[^\n\r]';

            %% Open the text file.
            fileID = fopen(dir_search(j).name,'r');

            textscan(fileID, '%[^\n\r]', startRow-1, 'WhiteSpace', '', 'ReturnOnError', false);
            dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'ReturnOnError', false);

            fclose(fileID);

            a_range = str2double(dataArray{:, 25});
            a_range(isnan(a_range)) = [];
            a_range_all = [a_range_all; a_range];
            
            
            b_range = str2double(dataArray{:, 26});
            b_range(isnan(b_range)) = [];
            b_range_all = [b_range_all; b_range];


            clearvars filename delimiter startRow formatSpec fileID dataArray ans;
        end
    end
end

figure

gscatter(a_range_all,b_range_all)
title('Ag relative to Bg');
xlabel('Ag');
ylabel('Bg');
ylim([1 4]);
xlim([0 .4]);