# Both Parts: 118 chars
A=[];P=->n{$<.map{|l|l['..']?break:n+=l['d ']?P[0]:l.to_i};A<<n;n};R=P[-4e7];p A.sum{_1<=1e5?_1:0},A.filter{_1>=R}.min