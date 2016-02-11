function [surface_data] = plot_data(fan_dataset)
    %PLOT_DATA Summary of this function goes here
    %   Detailed explanation goes here

     groups = {}

    % Group data by name per site

    for si=1:length(fan_dataset)
        cs = fan_dataset(si);
        cs = cs{1};
        s_group = cell(1,2)
        for ri=1:length(cs.meta)
            cs_meta = cs.meta{ri};
            cover = cs_meta.cover;
            c_name = cs_meta.c_name;
            cda.name = cs_meta.name;
            cda.cover = cover;
            cda.id = cs_meta.w_id;
            sp = strsplit(cs_meta.name, '_');
            samp_prefix = sp{1};
            t = isstrprop(samp_prefix, 'digit');
            gname = '';
            for tt=1:length(t)
               if t(tt) > 0
                gname = [gname, num2words_fast(str2num(samp_prefix(tt)))];
               else
                gname = [gname, samp_prefix(tt)];
               end
            end

            if strcmp(gname,'')
                gname = 'nil';
            end
            % Check if site name exists (eg. G10E-9)
            if sum(strcmp(s_group(:,1), c_name)) > 0
                idx = find(strcmp(c_name,s_group(:,1)));

                % Does sample name prefix exist?
                current_fieldnames = fieldnames(s_group{idx,2});
                rank = [];

                for f=1:length(current_fieldnames)
                    % Comparing
                    rank = [rank, strdist(gname, current_fieldnames{f})];
                end

                [M,I] = min(rank)
                if M > 2
                    s_group{idx,2}.(gname) = cda;
                else
                    fname = current_fieldnames{I};
                    s_group{idx,2}.(fname) = [s_group{idx,2}.(fname), cda];         
                end

            else
                strcat(gname, c_name);
                s_group = [s_group;{c_name, struct(gname, cda)}];
            end
        end
        s_group(1,:) = [];
        groups{si} = s_group;
    end

    
    surface_plot_data = struct()
    
    for gg=1:length(groups)

        % For each surface
        
        getDat = fan_dataset{gg};
        
        
        distances_g = [];
        d84_g = [];
        d50_g = [];
        mean_g = [];
        cv_g = [];
        sites_g = [];

        % Current surface
        cd = groups(gg)
        for ggg=1:length(cd)

            % Site list
            si = cd(ggg);
            si = si{1};

            for siss=1:length(si)

                % Current site
                sisss = si(siss, 2);
                sisss = sisss{1};

                fnames = fieldnames(sisss);
                if length(fnames) > 0


                    s_weights = {};
                    s_d84 = [];
                    s_d50 = [];
                    s_mean = [];

                    % For each site group
                    for f=1:length(fnames)

                        l_d84 = [];
                        l_d50 = [];
                        l_mean = [];
                        l_weights = [];

                        % Current site group
                        fn = fnames(f)
                        csg = sisss.(fn{1});

                        for g=1:length(csg)
                            % Group sub data
                            gsd = csg(g)
                            s_weights{f} = str2num(gsd.cover);
                            l_d84(g) = getDat.d84(gsd.id);
                            l_d50(g) = getDat.d50(gsd.id);
                            l_mean(g) = getDat.mean(gsd.id);                   
                        end

                        s_d84 = [s_d84, mean(l_d84)]
                        s_d50 = [s_d50, mean(l_d50)]
                        s_mean = [s_mean, mean(l_mean)]

                    end

                    d84s_tops = [];
                    d50s_tops = [];
                    means_tops = [];

                    for www=1:length(s_weights)
                        d84s_tops = [d84s_tops, (s_d84(www) * s_weights{www})]
                        d50s_tops = [d50s_tops,(s_d50(www) * s_weights{www})]
                        means_tops = [means_tops,(s_mean(www) * s_weights{www})]
                    end

                    sw = [s_weights{:}]
                    bottom = sum(sw);
                    meta = getDat.meta(gsd.id)
                    meta = meta{1}
                    sites_g = [sites_g;str2num(meta.site)]
                    distances_g = [distances_g;getDat.distance(gsd.id)];
                    d84_g = [d84_g;(sum(d84s_tops)/bottom)];
                    d50_g = [d50_g;(sum(d50s_tops)/bottom)];
                    mean_g = [mean_g;(sum(means_tops)/bottom)];          
                end
            end
        end

        current_dataset = [distances_g,d84_g,d50_g,mean_g,sites_g]
        current_dataset = sortrows(current_dataset,1);
        surface_plot_data.(getDat.name) = current_dataset;
    end

    plotStyle = {'om','ok','og','or','ob'}
    plotStyle3 = {'+m','+k','+g','+r','+b'}
    plotStyle2 = {'-m','-k','-g','-r','-b'}
    surface_names = {'A','B','C','D','E'}

    surface_data = struct()

    for pppp=1:length(fieldnames(surface_plot_data))
        
        sname = surface_names(pppp);
        d = surface_plot_data.(sname{1});
        
        x_data = d(:,1);
        yd84 = d(:,2);
        yd50 = d(:,3);
        ymean = d(:,4);
        sites = d(:,5);

        p = polyfit(x_data,yd84,1);
        fit84 = polyval(p,x_data);
        p = polyfit(x_data,yd50,1);
        fit50 = polyval(p,x_data);
        p = polyfit(x_data,ymean,1);
        fitmean = polyval(p,x_data);
        sname = surface_names(pppp);
        surface_data.(sname{1}) = struct('d84',yd84,...
            'd50',yd50,'mean',ymean,'distance',x_data,...
            'fit84',fit84,'fit50',fit50,'fitmean',fitmean, 'site', sites);
    end
end

