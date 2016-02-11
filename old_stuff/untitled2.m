groups = {}

for si=1:length(s_data)
    cs = s_data(si);
    cs = cs{1};
    s_group = cell(1,2)
    for ri=1:length(cs.meta)
        cs_meta = cs.meta{ri};
        cover = cs_meta.cover;
        c_name = cs_meta.c_name;
        cda.name = cs_meta.name;
        cda.cover = cover;
        cda.id = cs_meta.w_id;
        if sum(strcmp(s_group(:,1), c_name)) > 0
            idx = find(strcmp(c_name,s_group(:,1)))
            s_group{idx,2} = [s_group{idx,2}, cda]
        else
            s_group = [s_group;{c_name, {cda}}];
        end
    end
    s_group(1,:) = []
    groups{si} = s_group;
end


plot_distances = {}
plot_d84 = {}
plot_d50 = {}
plot_mean = {}

for gg=1:length(groups)
    getDat = s_data{gg};
    
    distances_g = [];
    d84_g = [];
    d50_g = [];
    mean_g = [];
    cd = groups(gg)
    for ggg=1:length(cd)
        si = cd(ggg);
        si = si{1};
        for siss=1:length(si)
            sisss = si(siss, 2);
            sisss = sisss{1};
            if length(sisss) > 1
                
                ssssdat = sisss{1};
                distances_g = [distances_g,getDat.distance(ssssdat.id)];
                nnnn = length(sisss);
                weights = zeros(1,nnnn);
                d84s = zeros(1,nnnn);
                d50s = zeros(1,nnnn);
                means = zeros(1,nnnn);
                
                for sfdsfds=1:nnnn
                    dsads = sisss{sfdsfds};
                    weights(sfdsfds) = str2num(dsads.cover);
                    d84s(sfdsfds) = getDat.d84(dsads.id);
                    d50s(sfdsfds) = getDat.d50(dsads.id);
                    means(sfdsfds) = getDat.mean(dsads.id);                     
                end
                
                d84s_tops = 0;
                d50s_tops = 0;
                means_tops = 0;
                
                for www=1:length(weights)
                    d84s_tops = [d84s_tops, (d84s(www) * weights(www))];
                    d50s_tops = [d50s_tops,(d50s(www) * weights(www))];
                    means_tops = [means_tops,(means(www) * weights(www))];
                end
                bottom = sum(weights);

                d84_g = [d84_g,(sum(d84s_tops)/bottom)];
                d50_g = [d50_g,(sum(d50s_tops)/bottom)];
                mean_g = [mean_g,(sum(means_tops)/bottom)];               
            else
                ssssdat = sisss{1};
                distances_g = [distances_g,getDat.distance(ssssdat.id)];
                d84_g = [d84_g,getDat.d84(ssssdat.id)];
                d50_g = [d50_g,getDat.d50(ssssdat.id)];
                mean_g = [mean_g,getDat.mean(ssssdat.id)];             
            end
        end
    end
    
    
    plot_distances{gg} = distances_g;
    plot_d84{gg} = d84_g;
    plot_d50{gg} = d50_g;
    plot_mean{gg} = mean_g;
end



