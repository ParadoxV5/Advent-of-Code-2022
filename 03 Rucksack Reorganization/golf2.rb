# Part 2: 68 chars
p$<.each_slice(3).sum{|g|(g.map{_1.bytes.uniq}.inject(:&)[0]+10)%58}