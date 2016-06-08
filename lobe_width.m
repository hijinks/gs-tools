function [D,W] = lobe_width(shp, ds_data, origin)
    S = shaperead(shp);
    fields = fieldnames(S);
    width_lines = struct();

    widths = zeros(1,length(S));
    downstream = zeros(1,length(S));
    centre_points = cell(1,length(S));
    utm_y = [];
    utm_x = [];
    utm_lines = {};

    for l=1:length(S)
        line = S(l);
        utm_x1 = line.X(1);
        utm_x2 = line.X(end-1);
        utm_y1 = line.Y(1);
        utm_y2 = line.Y(end-1);

        utm_y = [utm_y;utm_y1;utm_y2];
        utm_x = [utm_x;utm_x1;utm_x2];

        utm_lines{l} = [utm_x1,utm_y1,utm_x2,utm_y2];

        %[utm_x1,utm_y1,u1,utm1] = wgs2utm(x1,y1);
        %[utm_x2,utm_y2,u2,utm2] = wgs2utm(x2,y2);

        if utm_x1 > utm_x2
            x_coords = [utm_x1 utm_x2];
        else
            x_coords = [utm_x2 utm_x1];
        end

        if utm_y1 > utm_y2
            y_coords = [utm_y1 utm_y2];
        else
            y_coords = [utm_y2 utm_y1];
        end

        widths(l) = sqrt((utm_x1-utm_x2)^2+(utm_y1-utm_y2)^2);
        centre_points{l} = [((x_coords(1)+x_coords(2))/2) ((y_coords(1)+y_coords(2))/2)];
        downstream(l) = sqrt((origin(1)-centre_points{l}(1))^2+(origin(2)-centre_points{l}(2))^2);
    end

    xlim = [min(utm_x), max(utm_x)];
    ylim = [min(utm_y), max(utm_y)];
% 
%     axesm utm
%     setm(gca,'zone','11n');
%     plot([S.X],[S.Y], 'k:');
% 
%     for k=1:length(utm_lines)
%         lcoords = utm_lines{k};
%         cp = centre_points{k};
%         plot([lcoords(1); lcoords(3)],[lcoords(2);lcoords(4)], 'r*');
%         plot(cp(1),cp(2),'g*');
%     end

%     downstream = downstream-min(downstream);
    [D,I]=sort(downstream);
    W=widths(I);
end