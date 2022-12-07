# Both Parts: 58 chars
I=gets.chars;p [4,14].map{|l|(l..).find{!I[_1-l,l].uniq!}}