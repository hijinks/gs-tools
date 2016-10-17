function [upper, lower] = ss_range(upper_bounds, lower_bounds, mean, stdev)
    
    ss_outputs = zeros(8,1000);
    a_vals = [upper_bounds(1),lower_bounds(1)];
    b_vals = [upper_bounds(2),lower_bounds(2)];
    c_vals = [upper_bounds(3),lower_bounds(3)];
    
    figure;
    
    d = 0;
    for i=1:2
        % a values
        a = a_vals(i);
        
        for j=1:2
            % b values
            b = b_vals(j);
            
            for k=1:2
                % c values
                c = c_vals(k);
                
                d = d+1;
                J_vals = c:.005:3;
                ss_outputs(d,1:numel(J_vals)) = -log((J_vals-c)/a)/b;
                ss_test = -log((J_vals-c)/a)/b;
                gs_predict = (ss_test.*stdev+mean);
                plot(gs_predict, J_vals);
                hold on;
                
                xp = [-10:.5:10.5];
                
                [N,edges] = histcounts(ss_test, xp);
                fD = N./sum(N);
                field_x =xp(1:end-1);   
                ss_outputs = ss_outputs(find(ss_outputs,1,'first'):find(ss_outputs,1,'last'));
            end
        end
    end
    
    upper = max(ss_outputs);
    lower = min(ss_outputs);
end