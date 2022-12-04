# Both Parts: 76 chars
u=v=0;$<.map{a,_,x=_1.bytes;x-=1;u+=(x-a)%3*3+x-86;v+=(x+a)%3+x%3*3+1};p u,v