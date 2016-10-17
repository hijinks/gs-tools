
function AutoJ(Jprocess)
    
    FIT = 1;
    s_mean = [];
    s_stdev = [];

    surfaces = fieldnames(Jprocess);
    
    surface_letters = {};
    fan_categories = surfaces';
    
    a_constant = {};
    b_constant = {};
    c_constant = {};
    
    figure;
    
    for p=1:length(surfaces)

        sd = Jprocess.(surfaces{p});

        ds_surface = sd{1};
        surface_data = sd{2};
        surface_name = surfaces{p};
        surface_letters{p} = surface_data.name;
        
        ag = .02;
        bg = 2;
        cg = .1;

        ds_size = size(ds_surface);

        for j=1:ds_size(1)
            wol = ds_surface{j,2};
            wol(isnan(wol)) = [];
            s_mean = [s_mean; mean(wol)];
            s_stdev = [s_stdev; std(wol)];
        end
        
        ds_dist = cell2mat(ds_surface(:,1));
        ds_norm = ds_dist./max(ds_dist);

        ss = surface_data.ss;

        ed = -5.5:.5:5.5;
        xp = [-5:.5:5.5];
        all_x = [];
        all_y = [];

        sums_total = 0;
        bin_totals = zeros(1,length(xp)-1);
        
        a_vals = zeros(1,length(ss));
        b_vals = zeros(1,length(ss));
        c_vals = zeros(1,length(ss));
        
              
        for k=1:length(ss)
            [N,edges] = histcounts(ss{k}, xp);
            % Frequency Density
            fD = N./sum(N);
            bin_totals = bin_totals+N;
        
            field_y = N./sum(N);
            field_x =xp(1:end-1);
            
            CV = surface_data.cv_norm(k);

            C1_av = .7;
            C2_av = C1_av/CV;

            ss_var = -5:.5:6;

            if FIT > 0
                options = optimoptions('lsqcurvefit','Algorithm','levenberg-marquardt');
                [v,resnorm,residuals] = lsqcurvefit(@fractionOnly, [ag,bg,cg], field_x, ...
                    field_y', [1e-4,1e-4,1e-4]);

                ag = v(1);
                bg = v(2);
                cg = v(3);

            else
                residuals = 0;
                resnorm = 0;
            end

            [J, Jprime, phi, sym, expsym, intsysmeps, sigma, int_val, ...
            int_constant_ana, fraction] = calcFraction([ag,bg,cg], ss_var, C1_av, C2_av);     

            if cg > 1
                anomaly = [surfaces{p}, k];
                
                plot(ss_var, fraction, 'r', 'LineWidth',3);
                hold on;
                
            else
                plot(ss_var, fraction, 'b');
                hold on;
            end
            
            a_vals(k) = ag;
            b_vals(k) = bg;
            c_vals(k) = cg;
            
        end
        ylim([0 1]);
        title(surfaces{p});
        
        a_constant{p} = a_vals;
        b_constant{p} = b_vals;
        c_constant{p} = c_vals;
        
    end
    
    save('constants', 'a_constant', 'b_constant', 'c_constant');
    
    function fraction = fractionOnly(j_params, ss_data)
        [J, Jprime, phi, sym, expsym, intsysmeps, sigma, int_val, int_constant_ana, fraction] = calcFraction(j_params, ss_data, C1_av, C2_av);
    end

    a_scatter = [];
    b_scatter = [];
    c_scatter = [];
    
    % Scan every fan

    colors = ['b' 'b' 'b' 'b' 'm' 'm' 'm' 'm' 'k' 'k' 'k'];
    symbols = ['o' 'o' 'o' 'o' 'd' 'd' 'd' 'd' 'x' 'x' 'x'];   
    
    surface_scatter = [];
    
    
    for k=1:length(a_constant)
        

        f_arr = cell(1,length(a_constant{k}));
        
        f_arr(1:length(a_constant{k})) = fan_categories(k);
        
        surface_scatter = [surface_scatter; f_arr'];
        
        x = (ones(length(a_constant{k}), 1))*k';
        y = a_constant{k}';
        a_col = [x,y];
        a_scatter = [a_scatter; a_col];

        x = (ones(length(b_constant{k}), 1))*k';
        y = b_constant{k}';
        b_col = [x,y];
        b_scatter = [b_scatter; b_col];

        x = (ones(length(c_constant{k}), 1))*k';
        y = c_constant{k}';
        c_col = [x,y];
        c_scatter = [c_scatter; c_col];
    end
    
%     algorithm_error(a_constant, a_constant_x, b_constant, b_constant_x, c_constant, c_constant_x);
    
	colormap bone

    % Fedele & Paola 2007a_f = 0.8;
    a_f = 0.8;
    b_f = 0.2;
    c_f = 0.15;

    % Mitch
    a_mi = 0.15;
    b_mi = 2.2;
    c_mi = 0.15;
    
    
    figure;
    subplot(1,3,1);
    gscatter(a_scatter(:,1),a_scatter(:,2), surface_scatter, colors, symbols);
    %labelpoints(a_scatter(:,1),a_scatter(:,2),surface_letters');
    %ylim([0 1]);
    xlim([0,length(a_constant)+1]);
    set(gca,'xticklabel',{[]});
    hold on;
    plot(0:1:length(c_constant)+1, (ones(length(c_constant)+2, 1))*a_f, '--k');
    
    title('ag');
    
    subplot(1,3,2);
    gscatter(b_scatter(:,1),b_scatter(:,2), surface_scatter, colors, symbols);
    %labelpoints(b_scatter(:,1),b_scatter(:,2),surface_letters');
    %ylim([0 5]);
    xlim([0,length(a_constant)+1]);
    set(gca,'xticklabel',{[]});
    hold on;
    plot(0:1:length(c_constant)+1, (ones(length(c_constant)+2, 1))*b_f, '--k');
    title('bg');
    
    subplot(1,3,3);
    gscatter(c_scatter(:,1),c_scatter(:,2), surface_scatter, colors, symbols);   
   % labelpoints(1:1:length(a_vals),a_vals,surface_letters');
    %ylim([0 1]);
    xlim([0,length(a_constant)+1]);   
    set(gca,'xticklabel',{[]});
    hold on;
    plot(0:1:length(c_constant)+1, (ones(length(c_constant)+2, 1))*c_f, '--k');
    title('cg');
end

function [J, Jprime, phi, sym, expsym, intsysmeps, sigma, int_val, ...
    int_constant_ana, fraction] = calcFraction(j_params, ss_var, C1, C2)
    
    jfunc = @(x) (j_params(1)*(exp(-j_params(2)*x))+j_params(3));

    J = arrayfun(jfunc, ss_var, 'UniformOutput', true)';
    Jprime = zeros(length(ss_var), 1);
    phi = zeros(length(ss_var), 1);
    sym = zeros(length(ss_var), 1);
    expsym = zeros(length(ss_var), 1);
    intsysmeps = zeros(length(ss_var), 1);
    sigma = zeros(length(ss_var), 1);

    for p=1:length(ss_var)    
        if p == 1
            k1 = p;
            k2 = p+1;     
        else
            k1 = p-1;
            k2 = p;
        end
        ss_change = ss_var(k1)-ss_var(k2);
        J_change = J(k1)-J(k2);
        Jprime(p) = J_change/ss_change;
        phi(p) = (1/(C1*(1+(C2/C1)*ss_var(p))))*(1-(1/J(p)))-(Jprime(p)/J(p));
        phi_change = phi(k1)+phi(k2);
        sym(p) = 0.5*phi_change*ss_change;    
    end

    for y=1:length(sym)
        if y > 1
            sigma(y) = sigma(y-1)+sym(y);
        else
            sigma(y) = sym(y);
        end
        expsym(y) = exp(-sigma(y));
    end

    for r=1:length(sigma)
        if r == 1
            k1 = r;
            k2 = r+1;
        else
            k1 = r-1;
            k2 = r;      
        end

        ss_change = abs(ss_var(k1)-ss_var(k2));
        expsym_change = expsym(k1)+expsym(k2);
        intsysmeps(r) = 0.5*expsym_change*ss_change;
    end

    int_val = sum(intsysmeps);
    int_constant_ana = 1/int_val;
    fraction = intsysmeps*int_constant_ana;
end

function algorithm_error(a,ax, b, bx, c, cx)
    a_trust = [];
    a_leven = [];
    for p=1:length(a)
        a_trust = [a_trust; a{p}'];
        a_leven = [a_leven; ax{p}'];
    end

    b_trust = [];
    b_leven = [];
    for p=1:length(b)
        a_trust = [b_trust; b{p}'];
        a_leven = [b_leven; bx{p}];
    end
    
    c_trust = [];
    c_leven = [];
    for p=1:length(c)
        c_trust = [c_trust; c{p}'];
        c_leven = [c_leven; cx{p}'];
    end
    
    figure;
    plot(a_trust, a_leven, 'x');
    title('a algorithm error');
    
    figure
    plot(b_trust, b_leven, 'x');
    title('b algorithm error');
    
    figure
    plot(c_trust, c_leven, 'x');
    title('c algorithm error');
    
end