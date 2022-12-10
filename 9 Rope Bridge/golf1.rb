# Part 2: 131 chars
h=t=0i
a=[]
while v=$<.getc
gets.to_i.times{h+=1i**(v.ord%15)
d=h-t
d.abs2>3&&t+=(d.real<=>0)+(d.imag<=>0).i
a<<t}end
p a.uniq.size