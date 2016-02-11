
g10 = plot_data(g10_data);
g8 = plot_data(g8_data);

plotStyle1 = {'om','ok','og','or','ob'};
plotStyle3 = {'+m','+k','+g','+r','+b'};
plotStyle4 = {'xm','xk','xg','xr','xb'};
plotStyle2 = {'-m','-k','-g','-r','-b'};

figure


plot(g10.A.distance, g10.A.d84, plotStyle4{5})
hold on
plot(g10.C.distance, g10.C.d84, plotStyle3{1})
hold on
plot(g10.E.distance, g10.E.d84, plotStyle1{2})
hold on
legend('Surface A', 'Surface C', 'Surface E')
plot(g10.A.distance, g10.A.fit84, plotStyle2{5}, 'LineWidth', 1)
hold on
plot(g10.E.distance, g10.E.fit84, plotStyle2{2}, 'LineWidth', 1)
hold on
plot(g10.C.distance, g10.C.fit84, plotStyle2{1}, 'LineWidth', 1)
xlabel('Distance from fan apex (m)')
ylabel('D84 Grain size (mm)')
title('Downstream grain size G10 fan')
hold on
set(gca,'fontsize', 18);

ylim([0,150])

figure


plot(g8.A.distance, g8.A.d84, plotStyle4{5})
for u=1:length(g8.A.distance)
    text(g8.A.distance(u)+20, g8.A.d84(u), num2str(g8.A.site(u)))
end

hold on
plot(g8.C.distance, g8.C.d84, plotStyle3{2})
for u=1:length(g8.C.distance)
    text(g8.C.distance(u)+20, g8.C.d84(u), num2str(g8.C.site(u)))
end
hold on
plot(g8.D.distance, g8.D.d84, plotStyle3{1})
for u=1:length(g8.D.distance)
    text(g8.D.distance(u)+20, g8.D.d84(u), num2str(g8.D.site(u)))
end
legend('Surface A', 'Surface C', 'Surface D')

plot(g8.A.distance, g8.A.fit84, plotStyle2{5})
hold on;
plot(g8.C.distance, g8.C.fit84, plotStyle2{2})
hold on;
plot(g8.D.distance, g8.D.fit84, plotStyle2{1})
hold on;
