function [downstream_m,grain_ds] = ds_predict(shp, ds, dist, width, params)
    
    % 100 years
    u0 = params.uplift;
    years = params.yrs;
    uplift = u0*years;

    input_qs = params.qs; % m3/yr

    w = interp1(dist,width,1:1:max(dist));

    w_min = floor(min(width));
    w_max = ceil(max(width));

    lx = max(dist);

    ns = length(w); % Basin
    dp = ns; % Basin depth


    w = linspace(w_min,w_max,ns);
    coord_basin = linspace(0,1,ns);

    % Normal expo
    alpha1 = 0.92420; % -ln(.5)/.75
    alpha2 = 1.84839; % -ln(.5)/.375
    subs = -uplift*exp(-alpha2*coord_basin);

    min_sub = min(subs);
    max_sub = max(subs);

    real_length = lx;
    dx = real_length/ns;
    dy = real_length/ns;
    dz = real_length/dp;



    X = linspace(1,w_max,w_max);
    Y = linspace(1,lx,ns);
    Z1 = linspace(min_sub,max_sub,ns);

    [X1,Y2] = meshgrid(X,Y);
    Z = repmat(subs, 1, w_max)';

    ds_vol = nan(length(w),1);
    for j=1:length(w)
        ds_vol(j) = (-subs(j))*(w(j))*dy;
    end


    Z = cumtrapz(ds_vol);

    qs = input_qs*years;

    qsfine = qs-Z;

    grainpdf0 = params.grainpdf; % initial grain size pdf log(D50)
    phi0 = params.phi; % standard deviation of the sediment supply log(D84/D50)
    C1 = params.C1;
    Cv = params.Cv;
    C2 = params.C2;
    Cmult = C2/C1;

    lambda = 0;
    y = (1-lambda)*cumtrapz(Z./qsfine);

    grainpdf = grainpdf0+phi0*Cmult*(exp(-C1*y)-1);

    grain_ds = 10.^grainpdf;

    downstream_m = linspace(min(dist),max(dist),length(coord_basin));

end