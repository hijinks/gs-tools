
% Normalise distances

surfaces = []

sf_fans = fieldnames(distance_sorted);

mode = 0

fig = figure;
for p=1:length(sf_fans);
    current_fan = distance_sorted.(sf_fans{p});
    current_fan_surfaces = fieldnames(current_fan);
    
    last_black = 0;
    last_pink = 0;
        
    for s=1:length(current_fan_surfaces)
        
        current_surface = current_fan.(current_fan_surfaces{s});
        wolmans = current_surface(:,2);
        max_dist = max(cell2mat(current_surface(:,1)));
        
        colours = {'kx', 'b*', 'mo', 'rx'};
        colour_c = {'k', 'b', 'm', 'r'}
        if strcmp(current_fan_surfaces{s}, 'A') > 0
            line_colour = colours{3};
            ccc = colour_c{3};
            t = 0;
        else
            if strcmp(current_fan_surfaces{s}, 'B') < 1
                if strcmp(current_fan_surfaces{s}, 'E') < 1 && strcmp(current_fan_surfaces{s}, 'F') < 1
                    line_colour = colours{1};
                    ccc = colour_c{1};
                    t = 1;
                else
                    line_colour = colours{1};
                    ccc = colour_c{1};
                    t = 1;
                end
            else
                line_colour = colours{3};
                ccc = colour_c{3};
                t = 0;
            end
        end
        
 
        if mode
            for j=1:length(wolmans)
                h = cdfplot(wolmans{j});    
                set(h,'Color',ccc)
                hold on;
            end
            set(h.Parent, 'xlim', [0 250])
            
            if t
               last_pink = h;
            else
               last_black = h; 
            end
        else
            
            norm_dist = cell2mat(current_surface(:,1))./max_dist;
            d84_list = [];
            d50_list = [];
            for j=1:length(wolmans)
                d84_list = [d84_list; prctile(wolmans{j}, 84)];
                d50_list = [d50_list; prctile(wolmans{j}, 50)];
            end
            plot(norm_dist, d84_list, line_colour);
    %         plot(norm_dist, d50_list, line_colour);
            ylim([0,150]);
            xlim([0,1.1]);
            ylabel('Grain size (mm)');
            xlabel('Normalise downstream distance');
            hold on;
        end
    end
end
if mode
    title('Grain size distribtions for fan surfaces in Death Valley')
    xlabel('Long axis grain size (mm)')
    legend([last_pink, last_black], {'Holocene & older', 'Modern'}, 'Location', 'SE')
    set(fig,'XScale','log');

end
