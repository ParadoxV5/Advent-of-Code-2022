# Both Parts: 119 chars
A=[]
P=->n=0{$<.map{|l|l['..']&&break;n+=l['d ']?P[]:l.to_i};A<<n;n}
R=P[]-4e7
p A.sum{_1<=1e5?_1:0},A.filter{_1>=R}.min