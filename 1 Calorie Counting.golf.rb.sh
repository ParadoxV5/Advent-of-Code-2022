# Both Parts: 54 chars
cat input.txt | ruby -e '$/="";m=$<.map{_1.split.sum &:to_i}.max 3;p m[0],m.sum'
