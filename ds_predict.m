function [downstream_m, grain_ds,subs, X, A, Depo] = ds_predict(dist, width, params)
    
    % 100 years
    u0 = params.uplift;
    years = params.yrs;
    uplift = u0*years;
    lx = params.lx;

    input_qs = params.qs; % m3/yr

    w_min = floor(min(width));
    w_max = ceil(max(width));

    ns = lx; % Basin

    l_norm = dist/lx;
    
    subsidence_coords = linspace(0,1,7000);
    basin_coords = linspace(0,1,lx);
    lambda = 0.7;
    
    switch params.sub_profile
        case 'box'
            subs = -uplift*ones(1,length(l_norm));
        case 'normal_expo'
            % Normal expo
            decay = 2.2; % -ln(.5)/.375
            subs = -uplift*exp(-decay*subsidence_coords);            
    end
    
    subs = subs(1:lx);
       
    X = interp1(dist,width,1:ns);
    X = inpaint_nans(X, 4);
    X(X<0) = 0;
 
    A = abs(X.*-subs);
    Qs_depo = cumtrapz(A);
    Depo = trapz(A);
    Qs_fine = params.qs-Qs_depo;
    Qs_fine(Qs_fine<0) = 0;
    
    R_star = lambda.*lx.*(A./Qs_fine);

    Y_star = abs(cumtrapz(cumtrapz(diff(basin_coords).*diff(R_star))));

    grainpdf0 = params.grainpdf; % initial grain size pdf log(D50)
    phi0 = mean(params.phi); % standard deviation of the sediment supply log(D84/D50)
    C1 = params.C1;
    Cv = mean(params.Cv);
    C2 = params.C2;
    Cmult = C2/C1;
    
    grain_ds = grainpdf0+(phi0*Cmult)*(exp(-C1*Y_star)-1);

    grain_ds = grain_ds*1000;
    downstream_m = linspace(min(dist),max(dist),length(grain_ds));

end