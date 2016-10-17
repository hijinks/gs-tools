    colors = ['b' 'b' 'b' 'b' 'm' 'm' 'm' 'm' 'k' 'k' 'k'];
    symbols = ['o' 'o' 'o' 'o' 'd' 'd' 'd' 'd' 'x' 'x' 'x'];   
    
    color_scatter = [];
    symbol_scatter = [];
    
    for k=1:length(a_constant)
        
        c_arr = char(1,length(a_constant{k}));
        s_arr = char(1,length(a_constant{k}));
        
        c_arr(1:length(a_constant{k})) = colors(k);
        s_arr(1:length(a_constant{k})) = symbols(k);
    end