output_dir = './dump/'
fan_name = 'g10'

plotStyle1 = {'om','ok','og','or','ob'};
plotStyle3 = {'+m','+k','+g','+r','+b'}
plotStyle4 = {'xm','xk','xg','xr','xb'};
plotStyle2 = {'-m','-k','-g','-r','-b'};

g10_ss = struct();

surface_names = {'A','B','C','D','E'}

for k=1:length(g10_data)
    c = g10_data{k};
    [xsorted, I] = sort(c.distance);
    cv_mean_sorted = c.cv_mean(I);
    cv_median_sorted = c.cv_median(I);
    cv_norm_sorted = c.cv_norm(I);
    p = polyfit(xsorted,cv_mean_sorted,1)
    f = polyval(p,xsorted);
    g10_ss.(c.name) = struct('d',xsorted, 'cv_mean',cv_mean_sorted,...
        'cv_median', cv_median_sorted, 'cv_norm', cv_norm_sorted,...
        'mean_fit', f);
end

g10_ss = struct();

for k=1:length(g10_data)
    c = g10_data{k};
    [xsorted, I] = sort(c.distance);
    cv_mean_sorted = c.cv_mean(I);
    cv_median_sorted = c.cv_median(I);
    cv_norm_sorted = c.cv_norm(I);
    p = polyfit(xsorted,cv_mean_sorted,1)
    f = polyval(p,xsorted);
    g10_ss.(c.name) = struct('d',xsorted, 'cv_mean',cv_mean_sorted,...
        'cv_median', cv_median_sorted, 'cv_norm', cv_norm_sorted,...
        'mean_fit', f);
end

surfA = figure;
plot(g10_ss.A.d, g10_ss.A.cv_mean, plotStyle3{1});
hold on;
plot(g10_ss.A.d, g10_ss.A.mean_fit, plotStyle2{1});
set(gca,'fontsize', 18);
plot_name = [output_dir, fan_name, '_', 'A','_','ss', '.pdf']
ylim([0,1.5]);
xlabel('Distance downstream (m)');
ylabel('Coefficient of variation');
title('A Downstream coefficient of variation')
print(surfA,plot_name,'-dpdf');

surfB = figure;
plot(g10_ss.B.d, g10_ss.B.cv_mean, plotStyle3{2});
hold on;
plot(g10_ss.B.d, g10_ss.B.mean_fit, plotStyle2{2});
set(gca,'fontsize', 18);
plot_name = [output_dir, fan_name, '_', 'B','_','ss', '.pdf'];
xlabel('Distance downstream (m)');
ylabel('Coefficient of variation');
title('B Downstream coefficient of variation')
ylim([0,1.5]);
print(surfB,plot_name,'-dpdf');

surfC = figure;
plot(g10_ss.C.d, g10_ss.C.cv_mean, plotStyle3{3});
hold on;
plot(g10_ss.C.d, g10_ss.C.mean_fit, plotStyle2{3});
title('C Downstream coefficient of variation')
set(gca,'fontsize', 18);
xlabel('Distance downstream (m)');
ylabel('Coefficient of variation');
plot_name = [output_dir, fan_name, '_', 'C','_','ss', '.pdf'];
ylim([0,1.5]);

print(surfC,plot_name,'-dpdf');

surfD = figure;
plot(g10_ss.D.d, g10_ss.D.cv_mean, plotStyle3{4});
hold on;
plot(g10_ss.D.d, g10_ss.D.mean_fit, plotStyle2{4});
set(gca,'fontsize', 18);
plot_name = [output_dir, fan_name, '_', 'D','_','ss', '.pdf'];
ylim([0,1.5]);
title('D Downstream coefficient of variation')
xlabel('Distance downstream (m)');
ylabel('Coefficient of variation');
print(surfD,plot_name,'-dpdf');

surfE = figure;
plot(g10_ss.E.d, g10_ss.E.cv_mean, plotStyle3{5});
hold on;
plot(g10_ss.E.d, g10_ss.E.mean_fit, plotStyle2{5});
set(gca,'fontsize', 18);
plot_name = [output_dir, fan_name, '_', 'E','_','ss', '.pdf'];
ylim([0,1.5]);
title('E Downstream coefficient of variation')
xlabel('Distance downstream (m)');
ylabel('Coefficient of variation');
print(surfE,plot_name,'-dpdf');

ylim([0,1.5]);

