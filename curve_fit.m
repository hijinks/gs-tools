curve_data = struct();

for fn=1:length(fannames)
    cf = distance_sorted.(fannames{fn});
    s_names = fieldnames(cf);
    curve_data.(fannames{fn}) = struct();
    
    for sn=1:length(s_names)
        surface_data = fan_data{sn};
        
        curve_data.(fannames{fn}).(fan_data{sn}.name) = struct();
        dat = cf.(s_names{sn});
        x_data = cell2mat(dat(:,1));
        wolmans = dat(:,2);

        d84s = [];
        d50s = [];
        means = [];
        
        for wl=1:length(wolmans)
            ww = wolmans{wl};
            ww(isnan(ww))=[];
            d84s = [d84s, prctile(ww, 84)];
            d50s = [d50s, prctile(ww, 50)];
            means = [means, mean(ww)];
        end
        
        curve_data.(fannames{fn}).(fan_data{sn}.name).mean = means;
        curve_data.(fannames{fn}).(fan_data{sn}.name).d84 = d84s;
        curve_data.(fannames{fn}).(fan_data{sn}.name).d50 = d50s; 
        curve_data.(fannames{fn}).(fan_data{sn}.name).distance = x_data;
        
    end
end

GC_A_X = curve_data.GC.A.distance;
GC_A_D50 = curve_data.GC.A.d50;
GC_A_1 = curve_data.GC.A.d50(1);

GC_B_X = curve_data.GC.B.distance;
GC_B_D50 = curve_data.GC.B.d50;
GC_B_1 = curve_data.GC.B.d50(1);

GC_C_X = curve_data.GC.C.distance;
GC_C_D50 = curve_data.GC.C.d50;
GC_C_1 = curve_data.GC.C.d50(1);

HP_A_X = curve_data.HP.A.distance;
HP_A_D50 = curve_data.HP.A.d50;
HP_A_1 = curve_data.HP.A.d50(1);

curve_data.HP.B.d50(8) = [];
curve_data.HP.B.distance(8) = []

HP_B_X = curve_data.HP.B.distance;
HP_B_D50 = curve_data.HP.B.d50;
HP_B_1 = curve_data.HP.B.d50(1);

HP_C_X = curve_data.HP.C.distance;
HP_C_D50 = curve_data.HP.C.d50;
HP_C_1 = curve_data.HP.C.d50(1);

figure
plot([2, 10, 70],[HP_A_1 HP_B_1 HP_C_1],'x');
hold on;
plot([2, 10, 70],[GC_A_1 GC_B_1 GC_C_1],'x');

