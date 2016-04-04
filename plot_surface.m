
function plot_surface(d_sorted)

        x_data = cell2mat(d_sorted(:,1));
        wolmans = d_sorted(:,2);
        d84s = []
        d50s = []
        means = []
        
        for wl=1:length(wolmans)
            d84s = [d84s, prctile(wolmans{wl}, 84)];
            d50s = [d50s, prctile(wolmans{wl}, 50)];
            means = [means, mean(wolmans{wl})];
        end
                
        d84_plot = plot(x_data, d84s,'xk', 'LineWidth', 1);
        ylim([0,150]);
        
        lm = fitlm(x_data,d84s,'linear');
        c = lm.Coefficients.Estimate(1);
        mx = lm.Coefficients.Estimate(2);
        mx2 = 0;
        c2 = median(d84s);
        yfit = x_data*mx+c;
        yfit2 = x_data*mx2+c2;
        
        title('');
        xlabel('Distance downstream (m)');
        ylabel('Grain size (mm)');
        hold on;
        plot(x_data,yfit, 'k--', 'LineWidth', 1)
        hold on;
        plot(x_data,yfit2, 'k-', 'LineWidth', 1)
        
        lm = fitlm(x_data,d50s,'linear')
        c = lm.Coefficients.Estimate(1);
        mx = lm.Coefficients.Estimate(2);
        mx2 = 0;
        c2 = median(d50s);
        yfit = x_data*mx+c;
        yfit2 = x_data*mx2+c2;
        d50_plot = plot(x_data, d50s,'ok', 'LineWidth', 1);
        
        hold on;
        plot(x_data,yfit,'k--', 'LineWidth', 1);
        
        hold on;
        plot(x_data,yfit2, 'k-', 'LineWidth', 1)
%         legend([d50_plot, d84_plot], {'D50', 'D84'});
end