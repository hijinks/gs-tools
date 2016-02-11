groups = {'bobby'}
input = {'coarse_sam', 'coarse_stephen', 'fines'};

data = struct();

for g=1:length(groups)
    data.(groups{g}) = {};
end

for o=1:length(input)
    fnames = fieldnames(data);
    rank = [];
    
    sp = strsplit(input{o}, '_');
    
    for f=1:length(fnames)
        % Comparing
        rank = [rank, strdist(sp{1}, fnames{f})];
    end
    
    [M,I] = min(rank)
    if M > 2
        groups = [groups, sp{1}]
        data.(sp{1}) = {}
        I = length(groups)
    end  
    group = groups{I};
    data.(group) = [data.(group), input{o}]
end