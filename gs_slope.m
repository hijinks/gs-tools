% Grain size vs slope

addpath('./topotoolbox');
addpath('./topotoolbox/tools_and_more');

grape_dem = GRIDobj('dems/grapevine_dem3.tif');
grape_dem = inpaintnans(grape_dem);

grotto_dem = GRIDobj('dems/grotto_dem8.tif');
grotto_dem = inpaintnans(grotto_dem);

surfaces = []

sf_fans = fieldnames(distance_sorted);

for p=1:length(sf_fans);
    
    current_fan = distance_sorted.(sf_fans{p});
    
    if strcmp(sf_fans{p}, 'T1') > 0
        dem = grotto_dem;
    else
        dem = grape_dem;
    end
    
    legend_items = [];
    legend_labels = [];
    
    if strcmp(sf_fans{p}, 'T1') > 0
        current_fan_surfaces = fieldnames(current_fan);
        figure;
        for s=1:length(current_fan_surfaces)

            current_surface = current_fan.(current_fan_surfaces{s});
            coords = cell2mat(current_surface(:,3));
            xy = [coords(:,1),coords(:,2)];
            offset = current_surface{1,1};
            [dn,z] = demprofile(dem, 500, coords(:,1), coords(:,2));
            
            
            linearCoefficients = polyfit(dn, z, 1)
            yFit = polyval(linearCoefficients, dn);
            s_plot = plot(dn,yFit);
            
            legend_items = [legend_items, s_plot];
            legend_labels = [legend_labels; current_fan_surfaces{s}];
            
            hold on;
            site_slopes = [];
            site_distances = [];
            site_d84 = [];
            site_d50 = [];
            s1 = [];
            slope_interval = 20;
            for k=1:length(current_surface)
                s1 = interp1(dn+offset,z,current_surface{k}-slope_interval);
                s2 = interp1(dn+offset,z,current_surface{k}+slope_interval);
                if isnan(s1)
                    s1 = interp1(dn+offset,z,current_surface{k});
                end
                site_d84 = [site_d84, prctile(current_surface{k,2},84)];
                site_d50 = [site_d50, prctile(current_surface{k,2},50)];
                opp = s1-s2;
                hyp = slope_interval*2;
                theta = asin(opp/hyp);
                site_distances = [site_distances, current_surface{k}];
                site_slopes = [site_slopes,radtodeg(theta)];
            end
            
            plot(site_d84, site_slopes, 'x');
            xlabel('Grain Size (mm)');
            ylabel('Local slope (degrees)');
            hold on

        end
        legend(legend_items, legend_labels);
        
    end
end
