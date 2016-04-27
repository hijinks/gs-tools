% Find the self-similar solution for surfaces

function ss_fit(surface)

    ss = surface.ss;
    ed = -4.5:1:8.5;
    xp = [-4:1:8];
    all_x = [];
    all_y = [];
    for k=1:length(ss)
       [N,edges] = histcounts(ss{k}, ed);
       plot(xp,N, 'Color' , [.7 .7 .7]);
       hold on;
       all_x = [all_x; xp];
       all_y = [all_y; N];
    end

    plot(all_x,all_y, 'x');
    hold on;
    [XOut,YOut] = consolidator(all_x,all_y, 'median');

    cubic_fit = fit(XOut',YOut','cubicinterp')
    h = plot(cubic_fit);
    set(h, 'LineWidth',1.5, 'Color', 'k')

    xsmall = [-4:.1:8];
    yFitted = feval(cubic_fit,xsmall);

    [ypk,idx] = findpeaks(yFitted);
    xpk = xsmall(idx);
    [M,I] = max(ypk);
    cmid = xpk(I)

    plot([cmid cmid], [-10,60], '-r')
    text(cmid+.1, 10, ['\leftarrow' num2str(cmid)], 'Color', 'red')
    xlabel('Similarity Variable');
    ylabel('Frequency');
end

