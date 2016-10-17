function [s_C1, s_C2] = C1_C2(distance_sorted)

    fans = fieldnames(distance_sorted);

    s_C1 = struct();
    s_C2 = struct();

    for u=1:length(fans)

        fan_surfaces = distance_sorted.(fans{u});
        surfaces_names = fieldnames(fan_surfaces);

        s_C1.(fans{u}) = struct();

        for w=1:length(surfaces_names)


            fs = fan_surfaces.(surfaces_names{w});
            dist = cell2mat(fs(:,1));
            dist = dist-dist(1);
            dist = dist./dist(end);
            stdevs = zeros(1,length(dist));
            means = zeros(1,length(dist));
            wolmans = fs(:,2);

            for j=1:length(dist)
                wm = wolmans{j};
                wm(isnan(wm)) = [];
                stdevs(j) = std(wm);
                means(j) = mean(wm);
            end

            std_diff = abs(diff(stdevs))*-1;
            mean_diff = abs(diff(means))*-1;
            dist_diff = diff(dist);

            C1 = [];
            C2 = [];

            for h=1:length(stdevs)-1
                C1 = [C1;(-1/stdevs(h))*(std_diff(h)/dist_diff(h))];
                C2 = [C2;(-1/means(h))*(mean_diff(h)/dist_diff(h))];
            end

            s_C1.(fans{u}).(surfaces_names{w}) = mean(C1);
            s_C2.(fans{u}).(surfaces_names{w}) = mean(C2);
        end

    end
end