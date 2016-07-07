function [J,ss] = jplot_ss(surface_data, ag, bg ,cg)
    ss = (surface_data.d84-surface_data.mean)./surface_data.stdev;
    jfunc = @(x) (ag*(exp(-bg*x))+cg);
    J = arrayfun(jfunc, ss, 'UniformOutput', true)';
end