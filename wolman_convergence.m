
fannames = {'G8', 'G10', 'T1'};

fans = {g8_data, g10_data, t1_data};

plot_i = 0;

figure;
clrs = colormap(cool);
converged_values = [];

for fn=1:length(fannames)
    fan_data = fans{fn};
    for sn=1:length(fan_data)
        surface_data = fan_data{sn};
        
        means = zeros(length(surface_data.wolmans), 1);
        
        for wm=1:length(surface_data.wolmans)
            wolman = surface_data.wolmans{wm};
            
            cumul_mean = zeros(length(wolman),1);
            for k = 1:length(wolman);
              cumul_mean(k) = mean(wolman(1:k));
            end
            
            normalised = cumul_mean(end)./cumul_mean;
            
            converged_values = [converged_values; abs(1-normalised(end-10))];
            
            plot(normalised, 'Color', datasample(clrs,1));
            xlim([0 100]);
            ylim([0 25]);
            hold on;
        end
    end
end

plot(1:1:200, ones(1,200), 'k--', 'LineWidth', 2);