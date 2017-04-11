curve_data = struct();
fannames = {'GC', 'HP'};
for fn=1:length(fannames)
    cf = distance_sorted.(fannames{fn});
    fan = fans{fn};
    s_names = fieldnames(cf);
    curve_data.(fannames{fn}) = struct();
    
    for sn=1:length(s_names)
        surface_data = fan{sn};
        
        curve_data.(fannames{fn}).(surface_data.name) = struct();
        dat = cf.(s_names{sn});
        x_data = cell2mat(dat(:,1));
        wolmans = dat(:,2);

        d84s = [];
        d50s = [];
        d25s = [];
        d75s = [];
        means = [];
        
        for wl=1:length(wolmans)
            ww = wolmans{wl};
            ww(isnan(ww))=[];
            d84s = [d84s, prctile(ww, 84)];
            d50s = [d50s, prctile(ww, 50)];
            d25s = [d25s, prctile(ww, 25)];
            d75s = [d75s, prctile(ww, 75)];
            means = [means, mean(ww)];
        end
        
        curve_data.(fannames{fn}).(surface_data.name).mean = means;
        curve_data.(fannames{fn}).(surface_data.name).d84 = d84s;
        curve_data.(fannames{fn}).(surface_data.name).d50 = d50s;
        curve_data.(fannames{fn}).(surface_data.name).d25 = d25s;
        curve_data.(fannames{fn}).(surface_data.name).d75 = d75s;
        curve_data.(fannames{fn}).(surface_data.name).distance = x_data;
        
    end
end

GC_A_X = curve_data.GC.A.distance;
GC_A_D50 = curve_data.GC.A.d50;
GC_A_1 = curve_data.GC.A.d50(1);
GC_A_75 = curve_data.GC.A.d75(1);
GC_A_25 = curve_data.GC.A.d25(1);

GC_B_X = curve_data.GC.B.distance;
GC_B_D50 = curve_data.GC.B.d50;
GC_B_1 = curve_data.GC.B.d50(1);
GC_B_75 = curve_data.GC.B.d75(1);
GC_B_25 = curve_data.GC.B.d25(1);

GC_D_X = curve_data.GC.D.distance;
GC_D_D50 = curve_data.GC.D.d50;
GC_D_1 = curve_data.GC.D.d50(1);
GC_D_75 = curve_data.GC.D.d75(1);
GC_D_25 = curve_data.GC.D.d25(1);

HP_A_X = curve_data.HP.A.distance;
HP_A_D50 = curve_data.HP.A.d50;
HP_A_1 = curve_data.HP.A.d50(1);
HP_A_75 = curve_data.HP.A.d75(1);
HP_A_25 = curve_data.HP.A.d25(1);

curve_data.HP.B.d50(8) = [];
curve_data.HP.B.distance(8) = [];

HP_B_X = curve_data.HP.B.distance;
HP_B_D50 = curve_data.HP.B.d50;
HP_B_1 = curve_data.HP.B.d50(1);
HP_B_75 = curve_data.HP.B.d75(1);
HP_B_25 = curve_data.HP.B.d25(1);

HP_C_X = curve_data.HP.C.distance;
HP_C_D50 = curve_data.HP.C.d50;
HP_C_1 = curve_data.HP.C.d50(1);
HP_C_75 = curve_data.HP.C.d75(1);
HP_C_25 = curve_data.HP.C.d25(1);

figure;

% Age boundaries
% Q4
f1 = fill([0 0 4 4], [20 130 130 20], [0.8392    0.9098    0.8510]);
hold on;
% Q3
f2 = fill([4 4 12 12], [20 130 130 20], [0.9373    0.8667    0.8667]);
hold on;
% Qlm/Qay
% f3 = fill([12 12 40 40], [20 130 130 20], [0.9529    0.8706    0.7333]);
% hold on;
% Q2c
f4 = fill([40 40 100 100], [20 130 130 20], [0.8039    0.8784    0.9686]);
hold on;


set(f1,'EdgeColor','None'); 
set(f2,'EdgeColor','None'); 
% set(f3,'EdgeColor','None'); 
set(f4,'EdgeColor','None'); 

plot([0 0 80 80 0], [20 130 130 20 20], 'Color', [0    0    0]);
hold on;
pc_hc_bound = plot([12 12], [0 130], '--', 'LineWidth', 1, 'Color', [0.5 0.5 0.5]);
hold on;

x = [3, 10, 70];
y = [HP_A_1 HP_B_1 HP_C_1];
hp = plot(x,y,':', 'Color', 'k');
yneg = [abs(HP_A_1-HP_A_25) abs(HP_B_1-HP_B_25) abs(HP_C_1-HP_C_25)];
ypos = [abs(HP_A_1-HP_A_75) abs(HP_B_1-HP_B_75) abs(HP_C_1-HP_C_75)];
hold on;
hp_err = errorbar(x,y,yneg,ypos,'o', 'Color', 'k');
hold on;
x = [3-1, 10-1, 70-1];
y = [GC_A_1 GC_B_1 GC_D_1];
gc = plot(x,y,':', 'Color', 'r');
yneg = [abs(GC_A_1-GC_A_25) abs(GC_B_1-GC_B_25) abs(GC_D_1-GC_D_25)];
ypos = [abs(GC_A_1-GC_A_75) abs(GC_B_1-GC_B_75) abs(GC_D_1-GC_D_75)];
hold on;
gc_err = errorbar(x,y,yneg,ypos,'o', 'Color', 'r');
hold on;
ylim([20 130]);
ylabel('Grain size (mm)');
yyaxis right
dh = plot(devils_hole.Age_ka, devils_hole.delta18O, 'Color', 'b');
ax1 = gca; % current axes
ax1.YColor = [0 0 1];

xlim([0 80]);
xlabel('Age ka');
ylabel('Delta O_{18}');

legend([f1, f2, f4, hp, gc, hp_err, gc_err, dh, pc_hc_bound],...
    'Q4', 'Q3', 'Q2c', 'Hanaupah Canyon Grain Size (mm)', ...
    'Galena Canyon Grain Size (mm)', 'HP 25-75%', ...
    'GC 23-75%', 'Devils Hole O_{18}', 'L. Pleistocene-Holocene Boundary',...
    'Location', 'North');

