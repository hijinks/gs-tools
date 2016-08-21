% From wilcock and Crowe [2003]

% Calculating the threshold shear stress of the grain size one standard
% deviation above the mean to that of the grain size one standard deviation
% below the mean

fan_data = {g10_data, g8_data, t1_data};
fan_names = {'G10', 'G8', 'T1'};

rho_w = 1000; % kg/m3 water
rho_g = 1680; % kg/m3 gravel
g = 9.8; % gravitational accel.
t_dimless = 0.06; % dimensionless shear stress for gravel bed rivers
for j=1:length(fan_data)
   fdata = fan_data{j};
   fname = fan_names{j};
   f1 = figure;
   f2 = figure;
   li = {};
   ll = {};  
   for k=1:length(fdata)
       sdata = fdata{k};
       
       t_ratios = zeros(length(sdata.mean), 1);
       t_ratios_wc = zeros(length(sdata.mean), 1);
       x = sdata.distance';

       for l=1:length(sdata.mean)
           mean_gs = sdata.mean(l);
           d50_gs = sdata.d50(l);
           stdev_gs = sdata.stdev(l);
           gs2 = mean_gs-stdev_gs;
           gs1 = mean_gs+stdev_gs;
           
           tcr1 = t_dimless * g * (rho_g - rho_w) * gs1;
           tcr2 = t_dimless * g * (rho_g - rho_w) * gs2;
           
           t_ratios(l) = abs(tcr1/tcr2);
           
           b1 = 0.67/(1+exp(1.5-(gs1/mean_gs)));
           b2 = 0.67/(1+exp(1.5-(gs2/mean_gs)));
           tcr_wc1 = (gs1/d50_gs)^b1;
           tcr_wc2 = (gs2/d50_gs)^b2;
           
           t_ratios_wc(l) = abs(tcr_wc1/tcr_wc2);
           
       end
       
       figure(f1);
       p = plot(x, t_ratios_wc, 'x');
       P = polyfit(x,t_ratios_wc,1);
       yfit = P(1)*x+P(2);
       hold on;
       plot(x, yfit,'k-');
       hold on;
       li = [li, p];
       ll = [ll, sdata.name];
       figure(f2);
       p = plot(x, t_ratios, 'x');
       hold on;

   end
   figure(f1);
   title(fname);
   legend(li,ll);
   figure(f2);
   title(fname);
   legend(li,ll);
end