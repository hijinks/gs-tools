function [s_data] = fan_data(fan, index_point)
    s_data = {}
    paths = {};
    filenames = {};
    exts = {};
    sub_dirs = {};
    [ix,iy,iu,iutm1] = wgs2utm(index_point(1),index_point(2));
    coord_table = get_coords('G10_coords.csv',2, 63);

            
    dir_search = subdir('./raw_data');
    extensions = {'.csv', '.yml'};
    
    for j=1:(length(dir_search)),
        [pathstr,name,ext] = fileparts(dir_search(j).name);
        if strmatch(ext, extensions)
            paths = [paths;pathstr];
            filenames = [filenames;name];
            exts = [exts;ext];
            C = strsplit(pathstr,'/');
            for l=3:(length(C))
                n = l-2;
                if length(sub_dirs) < n
                    sub_dirs{n} = {};
                end
                sub_dirs{n} = [sub_dirs{n};C{l}];
            end
        end
    end

    k = size(paths);
    y = k(1);

    col_l = length(sub_dirs) + 2;

    f_vals = cell(y, col_l);

    col_names = {};

    for g=1:length(sub_dirs)
        col_names{g} = strcat('Dir_',num2str(g));
        f_vals(1:y,g) = sub_dirs{g};
    end
    
    f_vals(1:y,(col_l - 1)) = filenames;
    col_names{col_l - 1} = 'Filenames';
    f_vals(1:y, col_l) = exts;
    col_names{col_l} = 'Extension';
    T = cell2table(f_vals,'VariableNames',col_names);
    
    fan_data = T(find(strcmp(fan,T.Dir_1)), :);
    surfaces = unique(fan_data.Dir_2);
    
    for su=1:length(surfaces)
        surface = surfaces{su};
        surface_data = fan_data(find(strcmp(surface,fan_data.Dir_2)), :);

        sites = unique(surface_data.Dir_3);

        data_files = {};
        for s=1:length(sites)
            site_data = surface_data(find(strcmp(sites(s),surface_data.Dir_3)), :);
            types = {};
            data_files{s} = {};
            cur_dat = data_files{s};
            fn = site_data.Filenames;
            for u=1:length(fn)
                fnp = char(fn(u));
                if fnp(1) == '_'
                    types = [types;''];
                else
                    exp = '(?<name>\w+)_(?<type>\w+)';
                    res = regexp(fnp, exp, 'names');
                    if strcmp(res.type, 'old') < 1
                        types = [types;res.name];
                    end
                end
            end
            types = unique(types);
            for r=1:length(types)
                meta_name = strcat(char(types(r)),'_', 'meta');
                wolman_name = strcat(char(types(r)),'_', 'wolman');
                dat.site = sites(s);
                dat.meta = strcat(fan,'/',surface,'/',sites(s),'/',meta_name, '.yml');
                dat.wolman = strcat(fan,'/',surface,'/',sites(s),'/',wolman_name, '.csv');
            end
            
        end

        wolmans = {};
        meta = {};
        coords = {};
        
        
        for d=1:length(data_files)
           df = data_files{d};
           try
               dat = df{1}
               fname = strcat('./raw_data/', dat.wolman);
               mname = strcat('./raw_data/', dat.meta);
               meta_data = YAML.read(mname{1});
               meta{d} = meta_data;
               if sum(strcmp(coord_table.Properties.RowNames, 'G10D-11') > 0
                   coord_name = strcat(fan,surface,'-',dat.site)               
                   coord_row = coord_table({coord_name}, :);
                   coords{d} = [coord_row.lat, coord_row.lon];
               else
                   location = strsplit(meta_data.location,' ');
                   coords{d} = [str2num(location(1)), str2num(location(2))];
               end
               wolmans{d} = csvread(fname{1});
           catch
               
           end
        end
        
        d84_dat = [];
        d50_dat = [];
        distances = [];
        means = [];
        ss_datas = {};
        metas = {};
        wolmans
        for w=1:length(wolmans)
            stdDev = std(wolmans{w});
            d50 = prctile(wolmans{w},50);
            d84 = prctile(wolmans{w},84)
            d84_dat = [d84_dat,d84];
            d50_dat = [d50_dat,d50];
            m = mean(wolmans{w});
            means = [means,m];
            metas = [metas,meta{w}]
            
            % Coefficient of variation (using mean)
            cv_mean = stdDev/m;
            % Coefficient of variation (using median)
            cv_median = stdDev/d50;
            
            distances = [distances,d];
            
            sorted_data = sort(wolmans{w});
            
            ss_data = arrayfun(@(x)((x-m)/stdDev),sorted_data);
            ss_datas{w} = ss_data;
            
            c1 = coords{w};
            [x1,y1,u1,utm1] = wgs2utm(c1(1),c1(2));
            d = sqrt((ix-x1)^2+(iy-y1)^2);
            distances = [distances,d];
        end
        
        sd.name = surface;
        sd.d84 = d84_dat;
        sd.d50 = d50_dat;
        sd.mean = means;
        sd.meta = metas;
        sd.ss = ss_datas;
        sd.distance = distances;
        s_data{su} = sd;
    end
end