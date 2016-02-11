g8 = plot_data(g8_data);

plotStyle1 = {'om','ok','og','or','ob'}
plotStyle3 = {'+m','+k','+g','+r','+b'}
plotStyle4 = {'xm','xk','xg','xr','xb'}
plotStyle2 = {'-m','-k','-g','-r','-b'}

figure

plot(g8.A.distance, g8.A.d84, plotStyle4{5})
hold on
plot(g8.B.distance, g8.B.d84, plotStyle3{1})
hold on
plot(g8.C.distance, g8.C.d84, plotStyle3{2})
hold on
plot(g8.D.distance, g8.D.d84, plotStyle3{3})
hold on
legend('Surface A', 'Surface B', 'Surface C', 'Surface D')
plot(g8.A.distance, g8.A.fit84, plotStyle2{5}, 'LineWidth', 1)
hold on
plot(g8.B.distance, g8.B.fit84, plotStyle2{1}, 'LineWidth', 1)
hold on
plot(g8.C.distance, g8.C.fit84, plotStyle2{2}, 'LineWidth', 1)
hold on
plot(g8.D.distance, g8.D.fit84, plotStyle2{3}, 'LineWidth', 1)
xlabel('Distance from fan apex (m)')
ylabel('D84 Grain size (mm)')
title('Downstream grain size g8 fan')