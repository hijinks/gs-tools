inputs = {'2', 'test3', '42ov4'}
new = {}
for p=1:length(inputs)
    this = inputs{p}
    t = isstrprop(this, 'digit')
    new_string = ''
    for tt=1:length(t)
       if t(tt) > 0
        new_string = [new_string, num2words_fast(str2num(this(tt)))]
       else
        new_string = [new_string, this(tt)]
       end
    end
    new = [new, new_string]
end
