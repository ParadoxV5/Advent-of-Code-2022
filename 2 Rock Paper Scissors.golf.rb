# Both parts, directly converted from the ordinary solution
#i=*$<;['XYZ'*3,'XXXYYYZZZ'].each{|k|p i.sum{'BCAABCCAB'.chars.zip([' ']*9,k.chars).index(_1.chop.chars)+1}}

# Part 1
#p$<.sum{a,x=_1.unpack 'CxC';(x+~a)%3*3+x-87}
# Part 2
#p$<.sum{a,x=_1.unpack 'CxC';x-=1;(a+x)%3+x%3*3+1}
