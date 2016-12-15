% Plot per fan per surface self similarity curves

export = 0;
fan_names = {'G8', 'G10', 'T1'};
fan_data = {g8_data, g10_data, t1_data};
figure
for u=1:length(fan_names)
    
    current_fan = fan_data{u};
    current_fan_name = fan_names{u};
    
    for w=1:length(current_fan)
        
        surface_data = current_fan{w};
        ss = surface_data.ss;

        xp = -5:.5:5;
        all_x = [];
        all_y = [];
        
        if export < 1
            %figure;
        end
        
        sums_total = 0;
        bin_totals = zeros(1,length(xp)-1);
        all_y = [];
        
        for k=1:length(ss)
           cdfplot(ss{k});
           hold on;
        end

        if export < 1
           % title([current_fan_name ' ' surface_data.name]);
        else
            [file,path] = uiputfile('*.csv', 'Save Charts', ...
                [current_fan_name '_' surface_data.name]);
            dlmwrite([path file],[xp(2:end)',all_y],'delimiter',',','precision',3)
        end
    end
end