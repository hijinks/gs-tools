addpath('./scripts');
addpath('./lib');

fans = fieldnames(distance_sorted);
ds_surface = distance_sorted.SR1.D;
surface_data = sr1_data{4};

fan_data = {g8_data, g10_data, t1_data, sr1_data};

Jprocess = struct();

csv_dir = ['.' filesep 'jfits'];

previous_params = false;

if exist(csv_dir, 'dir')
   dir_search = subdir(csv_dir);
   previous_params = struct();
   for l=1:length(dir_search)
        [pathstr,fname,ext] = fileparts(dir_search(l).name);
        fpath = dir_search(l).name;
        delimiter = ',';
        formatSpec = '%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%q%q%q%*s%*s%*s%[^\n\r]';
        fileID = fopen(fpath,'r');
        dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);

        fclose(fileID);
        
        ag = dataArray{:, 1};
        bg = dataArray{:, 2};
        cg = dataArray{:, 3};
        
        previous_params.(fname) = struct('ag',str2num(ag{2}),...
            'bg',str2num(bg{2}),'cg',str2num(cg{2}));

        %% Clear temporary variables
        clearvars filename delimiter formatSpec fileID dataArray ans;
   end
end



for u=1:length(fans)
    fan_surfaces = distance_sorted.(fans{u});
    current_fan = fan_data{u};
    surfaces_names = fieldnames(fan_surfaces);
    for w=1:length(surfaces_names)
        ds_surface = fan_surfaces.(surfaces_names{w});
        surface_data = current_fan{w};
        surface_name = [fans{u} '_' surface_data.name];
        if isstruct(previous_params)
            if isfield(previous_params,surface_name)
                Jprocess.(surface_name) = {ds_surface,surface_data, previous_params.(surface_name)};
            else
                Jprocess.(surface_name) = {ds_surface,surface_data};
            end
        else
            Jprocess.(surface_name) = {ds_surface,surface_data};
        end
    end
end


JtweakOptions(Jprocess);
