# Part 2: 205 chars
X=[0]*10
Y=X.dup
A=[]
while d=$<.getc
gets.to_i.times{(d=~/U|D/?X: Y)[0]+=d.ord<=>80
9.times{|a|x=X[a]-X[b=a+1]
y=Y[a]-Y[b]
(x.abs>1||y.abs>1)&&(X[b]+=x<=>0
Y[b]+=y<=>0)}
A<<[X[-1],Y[-1]]}end
p A.uniq.size