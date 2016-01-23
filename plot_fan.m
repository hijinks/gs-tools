%figure;
% for s=1:length(surfaces)
%    cs = surfaces{s}
%    scatter(cs.distance,cs.mean)
%    hold on;
% end
edges = [-4,-3,-2,-1,0,1,2,3,4,5,6,7,8]
ss_vals = {}
for s=1:length(s_data)
    cs = s_data{s}
    ss_t = {}
    for y=1:length(cs.ss)
        values = [0,0,0,0,0,0,0,0,0,0,0,0,0]
        Y = discretize(cs.ss{y},edges)
        for u=1:length(Y)
           if isnan(Y(u)) < 1
            values(Y(u)) =  values(Y(u)) + 1
           end
        end
        ss_t = [ss_t;values]
        
        %plot(N,edges)
        %hold on;
    end
    ss_vals = {ss_vals,ss_t}
end

% averaged_ss = [];
% % Average each column
% for p=1:length(edges)
%     averaged_ss = [averaged_ss,mean(ss_vals(:,p))]
% end


for ss=1:length(ss_vals)
   sssss = ss_vals{ss}
   for sss=1:length(sssss)
       figure;
       plot(edges,sssss(sss,:));
       hold on;
   end
end
plot(edges, averaged_ss, '-ok', 'LineWidth',3);


