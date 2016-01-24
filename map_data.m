colours = {};

groups = {};

% Group data by name per site

surface_sites = struct();

for si=1:length(s_data)
    cs = s_data(si);
    cs = cs{1};
    s_group = [];
    for ri=1:length(cs.meta)
       cs_meta = cs.meta{ri};
       crds = strsplit(cs_meta.location, ' ');
       if length(crds) > 1
            crd1 = crds(1);
            crd2 = crds(2);
            coords = [str2num(crd1{1}), str2num(crd2{1})];
            s_group = [s_group; coords];
       end
    end
    surface_sites.(cs.name) = s_group;
end

figure

[grapevine, D] = geotiffread('maps/clipped.tif');
R = grapevine(:,:,1);
G = grapevine(:,:,2);
B = grapevine(:,:,3);

mapshow(cat(3,R,G,B), D)


mapshow(surface_sites.A(:,1),surface_sites.A(:,2),'DisplayType', 'point', 'MarkerEdgeColor', [0 0 1])
mapshow(surface_sites.B(:,1),surface_sites.B(:,2),'DisplayType', 'point', 'MarkerEdgeColor', [1 0 1])
mapshow(surface_sites.C(:,1),surface_sites.C(:,2),'DisplayType', 'point', 'MarkerEdgeColor', [1 1 0])



