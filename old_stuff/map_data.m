colours = {};

groups = {};

% Group data by name per site

figure
grid on

[grapevine, D] = geotiffread('maps/clipped.tif');
R = grapevine(:,:,1);
G = grapevine(:,:,2);
B = grapevine(:,:,3);

mapshow(cat(3,R,G,B), D)
title('Fan downstream transects')
g8_surface_sites = struct();
g10_surface_sites = struct();

for si=1:length(g8_data)
    cs = g8_data(si);
    cs = cs{1};
    s_group = [];
    s_sites = [];
    s_distances = [];
    for ri=1:length(cs.meta)
       cs_meta = cs.meta{ri};
       crds = strsplit(cs_meta.location, ' ');
       if length(crds) > 1
            crd1 = crds(1);
            crd2 = crds(2);
            coords = [str2num(crd1{1}), str2num(crd2{1})];
            s_group = [s_group; coords];
            s_sites = [s_sites; str2num(cs_meta.site)];
            s_distances = [s_distances;cs.distance(cs_meta.w_id)]
            %t = text(str2num(crd1{1})+10, str2num(crd2{1}), cs_meta.site)
            %t.FontSize = 12;
            %t.Color = [1 1 1];
       end
       
    end
    s_info = [s_group,s_distances,s_sites];
    s_info = sortrows(s_info,3);
    g8_surface_sites.(cs.name) = s_info;
end

for si=1:length(g10_data)
    cs = g10_data(si);
    cs = cs{1};
    s_group = [];
    s_sites = [];
    s_distances = [];
    for ri=1:length(cs.meta)
       cs_meta = cs.meta{ri};
       crds = strsplit(cs_meta.location, ' ');
       if length(crds) > 1
            crd1 = crds(1);
            crd2 = crds(2);
            coords = [str2num(crd1{1}), str2num(crd2{1})]
            %text(str2num(crd1{1}), str2num(crd2{1}), cs_meta.site)
            s_group = [s_group; coords];
            s_sites = [s_sites; str2num(cs_meta.site)];
            s_distances = [s_distances;cs.distance(cs_meta.w_id)];
       end
       
    end
    s_info = [s_group,s_distances,s_sites];
    if isempty(s_info) < 1
        s_info = sortrows(s_info,3)
        g10_surface_sites.(cs.name) = s_info;
    end
end

cs = g10_data(end);
cs = cs{1};
s1g = [];
s2g = [];
s1d = [];
s2d = [];
s1n = [];
s2n = [];
for ri=1:length(cs.meta)
   cs_meta = cs.meta{ri};
   crds = strsplit(cs_meta.location, ' ');
   if length(crds) > 1
        crd1 = crds(1);
        crd2 = crds(2);
        coords = [str2num(crd1{1}), str2num(crd2{1})]
%         text(str2num(crd1{1}), str2num(crd2{1}), cs_meta.site)
        if str2double(cs_meta.site) < 8
            s1g = [s1g; coords];
            s1d = [s1d;cs.distance(cs_meta.w_id)]; 
            s1n = [s1n; str2num(cs_meta.site)];
        else
            s2g = [s2g; coords];
            s2d = [s2d;cs.distance(cs_meta.w_id)]; 
            s2n = [s2n; str2num(cs_meta.site)];
        end
        
   end
end

s_info = [s1g,s1d,s1n];
s_info = sortrows(s_info,3);
g10_surface_sites.Ea = s_info;

s_info = [s2g,s2g,s2n];
s_info = sortrows(s_info,3);
    
g10_surface_sites.Eb = s_info;







mapshow(g8_surface_sites.A(:,1),g8_surface_sites.A(:,2), 'Color', 'm')
mapshow(g8_surface_sites.B(:,1),g8_surface_sites.B(:,2), 'Color', 'k')
mapshow(g8_surface_sites.C(:,1),g8_surface_sites.C(:,2), 'Color', 'g')
mapshow(g8_surface_sites.D(:,1),g8_surface_sites.D(:,2), 'Color', 'r')

mapshow(g8_surface_sites.A(:,1),g8_surface_sites.A(:,2),'DisplayType', 'point', 'MarkerEdgeColor', 'm')
mapshow(g8_surface_sites.B(:,1),g8_surface_sites.B(:,2),'DisplayType', 'point', 'MarkerEdgeColor', 'k')
mapshow(g8_surface_sites.C(:,1),g8_surface_sites.C(:,2),'DisplayType', 'point', 'MarkerEdgeColor', 'g')
mapshow(g8_surface_sites.D(:,1),g8_surface_sites.D(:,2),'DisplayType', 'point', 'MarkerEdgeColor', 'r')

mapshow(g10_surface_sites.A(:,1),g10_surface_sites.A(:,2), 'Color', 'm')
mapshow(g10_surface_sites.B(:,1),g10_surface_sites.B(:,2), 'Color', 'k')
mapshow(g10_surface_sites.C(:,1),g10_surface_sites.C(:,2), 'Color', 'g')
mapshow(g10_surface_sites.D(:,1),g10_surface_sites.D(:,2), 'Color', 'r')
mapshow(g10_surface_sites.Ea(:,1),g10_surface_sites.Ea(:,2), 'Color', 'b')
mapshow(g10_surface_sites.Eb(:,1),g10_surface_sites.Eb(:,2), 'Color', 'b')

mapshow(g10_surface_sites.A(:,1),g10_surface_sites.A(:,2),'DisplayType', 'point', 'MarkerEdgeColor', 'm')
mapshow(g10_surface_sites.B(:,1),g10_surface_sites.B(:,2),'DisplayType', 'point', 'MarkerEdgeColor', 'k')
mapshow(g10_surface_sites.C(:,1),g10_surface_sites.C(:,2),'DisplayType', 'point', 'MarkerEdgeColor', 'g')
mapshow(g10_surface_sites.D(:,1),g10_surface_sites.D(:,2),'DisplayType', 'point', 'MarkerEdgeColor', 'r')
mapshow(g10_surface_sites.E(:,1),g10_surface_sites.E(:,2),'DisplayType', 'point', 'MarkerEdgeColor', 'b')
set(gca,'fontsize', 18);
latlim = [487527 489255];
lonlim = [4068858 4070296];
