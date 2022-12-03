# Part 1: 71 chars
#p $<.sum{((_1.slice!(0,_1.size/2).bytes.uniq&_1.bytes.uniq).sum 20)%58}
# Part 2: 70 chars
#p $<.each_slice(3).sum{|g|(g.map{_1.bytes.uniq}.inject(:&).sum 10)%58}
#
# Both Parts: ? chars
cat input.txt | ruby -e ''
