
plotStyle = {'om','ok','og','or','ob'}
plotStyle2 = {'-m','-k','-g','-r','-b'}
surface_names = {'A','B','C','D','E'}

for u=1:length(s_data)
    figure;
    
    cv_dat = []
    cv_dist = []
    
    for c=1:length(surf.cv_mean)
        
        if surf.cv_mean(c) > 0
            cv_dat = [cv_dat, surf.cv_mean(c)]
            cv_dist = [cv_dist, surf.distance(c)]
        end
    end
    
    surf = s_data{u}
    plot(cv_dist, cv_dat, plotStyle{u})
    title(surf.name)
    p = polyfit(cv_dist,cv_dat,1)
    f = polyval(p,cv_dist);
    hold on;
    xlabel('Distance downstream (m)')
    ylabel('Coefficient of variation')
    plot(cv_dist,f, plotStyle2{u})
    
end
