function [upper, lower] = J1_bounds(upper_bounds,lower_bounds, mean_std, mean_size)
            
    upper_bounds = upper_bounds';
    lower_bounds = lower_bounds';
    

    function [gs1] = calc_gs(upper,lower, m_stdev, m_mean)
        J_vals = c:.005:3;
        ss_vars = -log((J_vals-c)/a)/b;
        ss_1 = -log((1-c)/a)/b;
        m_stdev = mean(stdev);
        m_mean = mean(means);

        gs_predict = (ss_vars.*mean(stdev))+mean(means);
        Infindexes = find(isinf(gs_predict));
        gs_predict(Infindexes) = [];
        ss_vars(Infindexes) = [];


        f=fit(ss_vars',gs_predict','poly1');
        gs_1 = f.p1*ss_1+f.p2;
    end
end