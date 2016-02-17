fan_names = {'T1'};
fans = {t1_data}

for j=1:length(fans)
    fan = fans{j};
    fan_surface_names = [];
    fan_name = fan_names{j};
    groups = {};
    
    % For each surface
   for si=1:length(fan)
    
    % Current surface
    cs = fan(si);
    cs = cs{1};
    s_group = cell(1,2);
    
    site_wolmans = struct();
    
    fan_surface_names = [fan_surface_names, cs.name];
    
    % Loop over sites
    for ri=1:length(cs.meta)
        
        cs_meta = cs.meta{ri}
        cover = cs_meta.cover;
        c_name = cs_meta.c_name;
        cda.name = cs_meta.name;
        cda.cover = cover;
        cda.id = cs_meta.w_id;
        cda.distance = cs.distance(cda.id);
        cda.wolman = cs.wolmans{cda.id};
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
        
        % Check if site name exists (eg. t1E-9)
        if sum(strcmp(s_group(:,1), c_name)) > 0
            idx = find(strcmp(c_name,s_group(:,1)));

            % Does sample name prefix exist?
            current_fieldnames = fieldnames(s_group{idx,2});
            rank = [];

            for f=1:length(current_fieldnames)
                % Comparing
                rank = [rank, strdist(gname, current_fieldnames{f})];
            end

            [M,I] = min(rank);
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
   
  
   
    for gg=1:length(groups)
        
        % For each surface
        % Current surface
        cd = groups(gg);
        for ggg=1:length(cd)

            % Site list
            si = cd(ggg);
            si = si{1};
            slist = {};
            
            for siss=1:length(si)

                % Current site
                sisss = si(siss, 2);
                sisss = sisss{1};

                fnames = fieldnames(sisss);
                
                wolman_distances = {};
                
                if length(fnames) > 0

                    s_weights = {};
                    s_wolmans = {};
                    
                    % For each site group
                    for f=1:length(fnames)
                        
                        % Current site group
                        fn = fnames(f);
                        csg = sisss.(fn{1});
                          
                        wolmans = {}
                        
                        for g=1:length(csg)
                            % Group sub data
                            gsd = csg(g);
                            s_weights{f} = str2num(gsd.cover);
                            s_wolmans{f} = gsd.wolman;
                            s_distances{f} = gsd.distance;
                        end

                    end
                    
                    wolman_matrix = []
                    for www=1:length(s_weights)
                        wolman_m = nan(200,s_weights{www});
                        wolman_m(1:length(s_wolmans{www}),1:s_weights{www}) = repmat(s_wolmans{www}, 1, s_weights{www});
                        wolman_matrix = [wolman_matrix, wolman_m];
                    end
                    
                    wolman_column = reshape(wolman_matrix,numel(wolman_matrix),1);
                    if length(wolman_column) < 20000
                        
                    end
                    slist = [slist; {s_distances{1}, gsd.id, wolman_column}];
                end
            end
            site_wolmans.(fan_surface_names(gg)) = slist;
        end
    end
    
    sw_fn = fieldnames(site_wolmans);
    for o=1:length(fan_surface_names)
       % Sort by distance
       sw_n = sw_fn(o);
       sw = site_wolmans.(sw_n{1})
       d_sorted = sortrows(sw,1);
       r = d_sorted(:,3);
       wm = cell2mat(r');
       boxplot(wm);
    end

   

end