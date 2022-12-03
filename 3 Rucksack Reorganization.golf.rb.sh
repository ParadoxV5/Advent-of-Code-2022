# Part 1: 70 chars
#p $<.sum{((_1.slice!(0,_1.size/2).bytes.uniq&_1.bytes.uniq)[0]+20)%58}
# Part 2: 69 chars
#p $<.each_slice(3).sum{|g|(g.map{_1.bytes.uniq}.inject(:&)[0]+10)%58}
#
# Both Parts: 123 chars
cat input.txt | ruby -e 'f=->a{(a.map{_1.chomp.bytes.uniq}.inject(:&)[0]+20)%58};i=*$<;p i.sum{f[_1.scan /.{#{_1.size/2}}/]},i.each_slice(3).sum(&f)'
