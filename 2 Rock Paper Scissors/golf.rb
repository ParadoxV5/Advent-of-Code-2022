# Both Parts, directly converted from the ordinary solution
#i=*$<;['XYZ'*3,'XXXYYYZZZ'].each{|k|p i.sum{'BCAABCCAB'.chars.zip([' ']*9,k.chars).index(_1.chop.chars)+1}}

# Part 1: 39 chars
#p$<.sum{a,_,x=_1.bytes;(x+~a)%3*3+x-87}

# Part 2: 44 chars
#p$<.sum{a,_,x=_1.bytes;x-=1;(a+x)%3+x%3*3+1}

# Both Parts: 76 chars
u=v=0;$<.map{a,_,x=_1.bytes;x-=1;u+=(x-a)%3*3+x-86;v+=(x+a)%3+x%3*3+1};p u,v
