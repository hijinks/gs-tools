nx = 3;
surface = sr1_data{nx};
ss_dat = surface.ss;
dist_dat = surface.distance;

    ss = surface.ss;
    ed = -4.5:1:8.5;
    xp = [-4:1:8];
    all_x = [];
    all_y = [];
    
    for k=1:length(ss)
       [N,edges] = histcounts(ss{k}, ed);
%       plot(xp,N, 'Color' , [.7 .7 .7]);
%       hold on;
       all_x = [all_x; xp];
       all_y = [all_y; N];
    end
    
% SS frequency data
freq = sum(all_y,1);
total  = sum(freq);
bins = all_x(1,:);
freq_norm = freq/total;


ss = ss_dat{nx};






% ss = linspace(-2, 5, 100)'
n = 7;
C1_range = linspace(.55, .9, n)
% Theoretical limit of Cv = 0.7 - 0.87
% CV = mean(surface.cv_norm);
CV = 1.11
C2_range = C1_range./CV;

ag = .5;
bg = .8;
cg = .15;

idx = 1:length(ss);

jfun = @(x)((ag*exp(-bg*x))+cg);

rc = 4; % Choice within the range
C1 = 0.6
C2 = 0.540514;

% J = cellfun(jfun, ss, 'UniformOutput', false);
J = arrayfun(jfun, ss);
Jprime = diff([eps; J])./diff([eps; ss]);

% Jprime = inpaint_nans(Jprime);
% Jprime = interp1(1:length(Jprime), Jprime, 1:1:100)'

% Interpolation is wrong!!!

phi = (1./(C1.*(1+(C2/C1).*ss))).*(1-(1./J))-(Jprime./J);
sym = diff([eps; phi])./diff([eps; ss]);
sym(isinf(sym)) = nan;
sym = inpaint_nans(sym);
sigma = cumtrapz(sym);
expsigma = exp(sigma);
expsigma = interp1(1:length(expsigma), expsigma, 1:1:100)';
dsig_dss = diff(expsigma)./diff(ss);
dsig_dss(isinf(dsig_dss)) = nan;
dsig_dss = inpaint_nans(dsig_dss)

int_constant = .5/trapz(dsig_dss);

fraction = expsigma*int_constant;

figure;

R_star = 1;
xx = linspace(min(dist_dat), max(dist_dat), length(ss))./max(dist_dat);
J = J';

djdx = diff(J)./diff(xx)
djdx(isinf(djdx)) = nan;
djdx(isnan(djdx)) = nan;
djdx = inpaint_nans(djdx)
djdx = interp1(1:length(djdx), djdx, 1:1:100);

dfdx = (R_star*(-(1./J))).*(-(1./J).*(djdx));
F_smooth = smooth(f);
dd = diff(F_smooth)./diff(ss)
dd(isinf(dd)) = nan;
dd = inpaint_nans(dd)
dd = interp1(1:length(dd), dd, 1:1:100)';
plot(ss,dd)


