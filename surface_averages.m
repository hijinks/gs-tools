
fan_names = {'G10', 'G8'};
fans = {g10_data,g8_data}
surface_names = struct()
surface_data = struct()


for j=1:length(fans)
    fan = fans{j};
    fan_surfaces = [];
    fan_surface_names = [];
    fan_averages = [];
    fan_name = fan_names{j};
    for i=1:length(fan)
        surf = fan{i};
        fan_surface_names = [fan_surface_names,surf.name];
        site_averages = mean(surf.mean);
        site_d84 = mean(surf.d84);
        site_d50 = mean(surf.d50);
        row = [site_averages,site_d50,site_d84];
        fan_surfaces = [fan_surfaces;row];
    end
    surface_names.(fan_name) = fan_surface_names;
    surface_data.(fan_name) = fan_surfaces;
end

fans_to_plot = fieldnames(surface_data);
for p=1:length(fans_to_plot)
   fan_name = fans_to_plot(p);
   sn = surface_names.(fan_name{1});
   f = surface_data.(fan_name{1});
   x_dat = [1:length(sn)];
   figure
   ax = gca;
   plot_styles = ['o','x','*']
   for k=1:3
      plot(x_dat, f(:,k), plot_styles(k), 'MarkerSize', 10, 'Color', 'k');
      hold on;
   end
   NumTicks = length(sn)+2;
   xlim([-1 length(sn)]+1);
   ylim([20 120])
   L = get(gca,'XLim');
   set(ax,'XTick',linspace(L(1),L(2),NumTicks))
   labels = {[]}
   for l=1:length(sn)
      labels = [labels,sn(l)]
   end
   title(strcat(fan_name,' Surface Averages'));
   ax.XTickLabel = labels;
   xlabel('Surfaces');
   ylabel('Grain size (mm)');
   legend('Mean','D50', 'D84', 'Location','NorthWest')
   set(gca,'fontsize', 12);
end