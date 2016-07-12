function [apex_data] = fan_apexes

    filename = 'coordinates/fan_apexes.csv';
    delimiter = ',';
    startRow = 2;
    formatSpec = '%s%f%f%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
    fclose(fileID);
    Name = dataArray{:, 1};
    Latitude = dataArray{:, 2};
    Longitude = dataArray{:, 3};
    clearvars filename delimiter startRow formatSpec fileID dataArray ans;
    
    apex_data = struct();
    for p = 1:length(Name)
        apex_data.(strtrim(Name{p})) = wgs2utm(Latitude(p), Longitude(p));
    end
end