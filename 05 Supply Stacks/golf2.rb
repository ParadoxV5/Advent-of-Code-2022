# Part 2: 180 chars
d,_,i=*$<.chunk{_1>?!};s=d[1].reverse.map{_1.gsub(/.(.)../m).map{$1[/\w/]}}.transpose.map &:compact;i[1].map{c,f,t=_1.scan(/\d+/).map &:to_i;s[t-1]+=s[f-1].pop c};p s.sum '',&:last