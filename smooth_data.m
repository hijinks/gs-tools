figure
plot(field_x, field_y)
hold on;
plot(field_x, smooth(field_y,'lowess'));