
function gs_stats(data)
    stdDev = std(data);
    d50 = prctile(data,50);
    d84 = prctile(data,84);
    m = mean(data);

    % Coefficient of variation (using mean)
    cv_mean = stdDev/m;
    % Coefficient of variation (using median)
    cv_median = stdDev/d50;

    sorted_data = sort(data)

    ss_data = arrayfun(@(x)((x-m)/stdDev),sorted_data)

