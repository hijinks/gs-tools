function [J,ss] = jplot_ss(surface_data, ag, bg ,cg, percentile)

    if strcmp(percentile, 'd84') > 0
        ss = (surface_data.d84-surface_data.mean)./surface_data.stdev;
    elseif strcmp(percentile, 'd50') > 0
        ss = (surface_data.d50-surface_data.mean)./surface_data.stdev;
    end
    jfunc = @(x) (ag*(exp(-bg*x))+cg);
    J = arrayfun(jfunc, ss, 'UniformOutput', true)';
end