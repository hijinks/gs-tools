% California map axes
figure; ax = usamap('california');
setm(ax, 'FFaceColor', [.5 .7 .9])
title('California map')

% read shapefile of US states with names and locations
states = geoshape(shaperead('usastatehi.shp', 'UseGeoCoords', true));

% display map
geoshow(states, 'Parent',ax)

% find states within the shown axes limits (California and Nevada)
latlim = getm(ax, 'MapLatLimit');
lonlim = getm(ax, 'MapLonLimit');
idx = ingeoquad(states.LabelLat, states.LabelLon, latlim, lonlim);

% latitude/longitude coordinates and corresponding labels
lat = states(idx).LabelLat;
lon = states(idx).LabelLon;
txt = states(idx).Name;

% plot coordinates
%plot(lat, lon, 'rx')
linem(lat, lon, 'LineStyle','none', 'LineWidth',2, 'Color','r', ...
    'Marker','x', 'MarkerSize',10)
textm(lat, lon, txt, 'HorizontalAlignment', 'left', 'VerticalAlignment','top')

