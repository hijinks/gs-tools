
% Normalise distances

surfaces = []

sf_fans = fieldnames(distance_sorted);

fig = figure;

for p=1:length(sf_fans)
    current_fan = distance_sorted.(sf_fans{p});
    current_fan_surfaces = fieldnames(current_fan);
        
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

