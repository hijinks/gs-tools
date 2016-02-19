function [surface_figures, surface_stats] = surface_plots(fan_name, fan_data)
%SURFACE_PLOTS Produce figures and statistics for each surface
%   
    output_dir = './dump/'

    surface_figures = struct();
    surface_stats = struct();
    
    for si=1:length(fan_data)
        
        cs = fan_data(si);
        cs = cs{1};
        s_group = cell(1,2);
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

    plot_distances = {};
    plot_d84 = {};
    plot_d50 = {};
    plot_mean = {};
    plot_cv = {};

    for gg=1:length(groups)

        % For each surface

        getDat = fan_data{gg};

        distances_g = [];
        d84_g = [];
        d50_g = [];
        mean_g = [];
        cv_g = [];
        std_g = [];

        % Current surface
        cd = groups(gg);
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
                    s_std = [];
                    
                    % For each site group
                    for f=1:length(fnames)

                        l_d84 = [];
                        l_d50 = [];
                        l_mean = [];
                        l_weights = [];
                        l_std = [];
                        
                        % Current site group
                        fn = fnames(f);
                        csg = sisss.(fn{1});

                        for g=1:length(csg)
                            % Group sub data
                            gsd = csg(g);
                            s_weights{f} = str2num(gsd.cover);
                            l_d84(g) = getDat.d84(gsd.id);
                            l_d50(g) = getDat.d50(gsd.id);
                            l_mean(g) = getDat.mean(gsd.id);   
                            l_std(g) = getDat.stdev(gsd.id);
                        end
                        s_mean = [s_mean, mean(l_d84)];
                        s_d84 = [s_d84, mean(l_d84)];
                        s_d50 = [s_d50, mean(l_d50)];
                        s_std = [s_std, mean(l_std(g))];

                    end

                    d84s_tops = [];
                    d50s_tops = [];
                    means_tops = [];
                    std_tops = [];
                        
                    
                    for www=1:length(s_weights)
                        d84s_tops = [d84s_tops, (s_d84(www) * s_weights{www})];
                        d50s_tops = [d50s_tops,(s_d50(www) * s_weights{www})];
                        means_tops = [means_tops,(s_mean(www) * s_weights{www})];
                        std_tops = [std_tops, (s_std(www) * s_weights{www})];
                    end

                    sw = [s_weights{:}];
                    bottom = sum(sw);
                    distances_g = [distances_g, getDat.distance(gsd.id)];
                    d84_g = [d84_g,(sum(d84s_tops)/bottom)];
                    d50_g = [d50_g,(sum(d50s_tops)/bottom)];
                    mean_g = [mean_g,(sum(means_tops)/bottom)];
                    std_g = [std_g,(sum(std_tops)/bottom)];
                    
                end
            end
        end

        plot_distances{gg} = distances_g;
        plot_d84{gg} = d84_g;
        plot_d50{gg} = d50_g;
        plot_mean{gg} = mean_g;
        plot_std{gg} = std_g;
    end

    plotStyle = {'om','ok','og','or','ob','oc'};
    plotStyle3 = {'+m','+k','+g','+r','+b','+c'};
    plotStyle2 = {'-m','-k','-g','-r','-b','-c'};
    surface_names = {'A','B','C','D','E', 'F'};
    
    for pppp=1:length(plot_distances)

        x_data = plot_distances{pppp}./100;
        x_data = x_data*100;
        y_data = plot_d84{pppp};
        
        stdevs = plot_std{pppp};
        
        [xsorted, I] = sort(x_data);
        ysorted = y_data(I);
        pfig = figure;
%         set(pfig, 'Visible', 'off')
        d84_plot = plot(xsorted, ysorted,plotStyle{pppp}, 'LineWidth', 1);
%         errorbar(xsorted,ysorted,stdevs);
        ylim([0,150]);
        
        lm = fitlm(xsorted,ysorted,'linear');
        save('myFile.txt', 'lm', '-ASCII','-append');
        c = lm.Coefficients.Estimate(1);
        mx = lm.Coefficients.Estimate(2);
        mx2 = 0;
        c2 = median(ysorted);
        yfit = xsorted*mx+c;
        yfit2 = xsorted*mx2+c2;
        
        title(surface_names{pppp});
        xlabel('Distance downstream (m)');
        ylabel('Grain size (mm)');
        hold on;
        plot(xsorted,yfit, plotStyle2{pppp}, 'LineWidth', 1)
        hold on;
        plot(xsorted,yfit2, 'k--', 'LineWidth', 1)
        
        x_data = plot_distances{pppp}./100;
        x_data = x_data*100;
        y_data = plot_d50{pppp};
        [xsorted, I] = sort(x_data);
        ysorted = y_data(I);
        
        lm = fitlm(xsorted,ysorted,'linear')
        save('myFile.txt', 'lm', '-ASCII','-append');
        c = lm.Coefficients.Estimate(1);
        mx = lm.Coefficients.Estimate(2);
        mx2 = 0;
        c2 = median(ysorted);
        yfit = xsorted*mx+c;
        yfit2 = xsorted*mx2+c2;
        d50_plot = plot(xsorted, ysorted,plotStyle3{pppp}, 'LineWidth', 1);
%         errorbar(xsorted,ysorted,stdevs);
        
        hold on;
        plot(xsorted,yfit,plotStyle2{pppp}, 'LineWidth', 1);
        
        hold on;
        plot(xsorted,yfit2, 'k--', 'LineWidth', 1)
        set(gca,'fontsize', 18);
%         legend([d50_plot, d84_plot], {'D50', 'D84'});
        surface_figures.(surface_names{pppp}) = pfig;
        surface_stats.(surface_names{pppp}) = struct('lm', lm);
        plot_name = [output_dir, fan_name, '_', surface_names{pppp}, '.pdf']
        print(pfig,plot_name,'-dpdf')
    end

end

