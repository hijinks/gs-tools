
ds_surface = distance_sorted.SR1.D;
surface_data = sr1_data{4};
s_mean = [];
s_stdev = [];

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

ed = -3.5:1:5.5;
xp = [-3:1:5];
all_x = [];
all_y = [];

for k=1:length(ss)
   [N,edges] = histcounts(ss{k}, ed);
   all_x = [all_x; xp];
   all_y = [all_y; N];
end

freq_no = numel(all_y);
norm = all_y./freq_no;
sp_x = -3:.1:5;
vq2 = interp1(xp,mean(norm),sp_x,'spline');
vq3 = interp1(xp,mean(all_y),sp_x,'spline');


xdx = .01;
dist_dx = []
for l=1:length(ds_dist)
    if l==length(ds_dist)
       dist_dx(l) = 0; 
    else
       dist_dx(l) = ds_dist(l+1)-ds_dist(l); 
    end
end
ds_x = min(ds_norm):xdx:1;
mean_interp = interp1(ds_norm,s_mean,ds_x,'spline');
stdev_interp = interp1(ds_norm,s_stdev,ds_x,'spline');

int_constant = trapz(sp_x,vq2);

expsym = vq2./int_constant;

CV = mean(surface.cv_norm); 

C1 = [];
C2 = [];

mean_fit = polyfit(ds_x,mean_interp,1);
mean_linear = polyval(mean_fit,ds_x);

stdev_fit = polyfit(ds_x,stdev_interp,1);
stdev_linear = polyval(stdev_fit,ds_x);
% 
% figure
% plot(ds_x, mean_interp);
% hold on;
% plot(ds_x, mean_linear, 'k--');
% 
% figure
% plot(ds_x, stdev_interp);
% hold on;
% plot(ds_x, stdev_linear, 'k--');

% for k=1:length(ds_x)
%     if k == 1
%         k1 = k;
%         k2 = k+1;     
%     else
%         k1 = k-1;
%         k2 = k;
%     end
%     
%     ddx = mean_interp(k1)-mean_interp(k2);
%     stdx = stdev_interp(k1)-stdev_interp(k2);
%     dx = ds_x(k2)-ds_x(k1);
%     cc1 = (1-(1/stdev_interp(k)))*(stdx/dx);
%     cc2 = (1-(1/mean_interp(k)))*(stdx/dx);
%     C1 = [C1;cc1];
%     C2 = [C2;cc2];
% end
% 
% C1_av = mean(C1);
% C2_av = mean(C2);

% Using linear decay

% C1 = (1-(1./stdev_interp))*(stdev_fit(1)*xdx);
% C2 = (1-(1./mean_interp))*(stdev_fit(1)*xdx);
% 
% C1_av = mean(C1);
% C2_av = mean(C2);

% Using 'real' distance dx

for o=1:length(dist_dx)-1
	C1(o) = (1-(1/stdev_interp(o)))*(stdev_fit(1)/dist_dx(o));
	C2(o) = (1-(1/mean_interp(o)))*(stdev_fit(1)/dist_dx(o));    
end

C1_av = mean(C1);
C2_av = mean(C2);

% Duller et al. 2010 values
C1_av = .7;
% C2_av = .5;
C2_av = C1_av/CV;
ss_var = -3:.1:5;

ag = .9;
bg = .2;
cg = .15;

jfunc = @(x) (ag*(exp(-bg*x))+cg);

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
    phi(p) = (1/(C1_av*(1+(C2_av/C1_av)*ss_var(p))))*(1-(1/J(p)))-(Jprime(p)/J(p));
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
    
    ss_change = ss_var(k1)-ss_var(k2);
    expsym_change = expsym(k1)+expsym(k2);
    intsysmeps(r) = 0.5*expsym_change*ss_change;
end

int_val = abs(sum(intsysmeps));
int_constant_ana = freq_no/int_val;
fraction = expsym*int_constant_ana;

% figure
% plot(ss_var,fraction)
% hold on;
% plot(sp_x, vq3)
% hold on;
% plot(all_x,all_y, 'x')
