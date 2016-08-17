
fnames = fieldnames(distance_sorted);
gs = [];
for o=1:length(fnames)
   snames = fieldnames(distance_sorted.(fnames{o}));
   
   for s=1:length(snames)
       sdata = distance_sorted.(fnames{o}).(snames{s});
       wdata = cell2mat(sdata(:,2));
       wdata = reshape(wdata,numel(wdata), 1);
       wdata(isnan(wdata)) = [];
       gs = [gs;wdata];
   end
end

[N,edges] = histcounts(gs, 21);
distr = N / sum(N);
edges(1) = []
bar(edges, distr, 'FaceColor',[.7 .7 .7]);