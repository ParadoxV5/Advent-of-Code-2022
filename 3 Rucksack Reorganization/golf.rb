# Both Parts: 123 chars
f=->a{(a.map{_1.chomp.bytes.uniq}.inject(:&)[0]+20)%58};i=*$<;p i.sum{f[_1.scan /.{#{_1.size/2}}/]},i.each_slice(3).sum(&f)