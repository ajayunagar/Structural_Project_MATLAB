%pointload Bending Moment and Shear force diagrams
prompt = 'What is the length of the beam?';
Length = input(prompt);
prompt = 'Howmany Pointloads are acting on a structure?';
noofloads = input(prompt);
formatSpec = 'Please add the value of point load no %d';
pl = zeros(1,noofloads);
l = zeros(1,noofloads);
n = 0;

while n < noofloads
    n = n+1;
    str = sprintf(formatSpec,n);
    prompt = str;
    pl(n) = input(prompt);
    display(pl(n));
    string = sprintf('Please add distance of the application of load no %d .',n);
    prompt = string;
    l(n) = input(prompt);
    display(l(n));
end

Vb = 0;
for c = 1:noofloads
    Vb = Vb + pl(1,c)*l(1,c);
end
Vb = Vb/Length;
Totalload = 0;
for z = 1:noofloads
    Totalload = Totalload + pl(1,z);
end
Va = Totalload - Vb;
delta_x = Length/1000;
x = (0:delta_x:Length)';
N = size(x,1);
V = zeros(N,1);
M = V;
for S = 1:N
    V(S) = Va;
    M(S) = Va * x(S);
    for v = 1:noofloads
        if(x(S) >= l(1,v))
            V(S) = V(S) - pl(1,v);
            M(S) = M(S) - pl(1,v)*(x(S) - l(1,v));
        end
    end
end
plot(x,M)
%deflection curve computing
E = xlsread('E.xlsx');
[m,n] = size(E);
for S=1:N
    M(S) = M(S);
    for w = 1:m
        if(x(S)>=E(w,2))
            M(S) = M(S)/E(w,1);
        end
        if(x(S)>=E(w,3))
            M(S) = M(S)*E(w,1);
        end
    end
end
widthb = xlsread('widthb.xlsx');
[m,n] = size(widthb);
for S = 1:N
    M(S) = M(S);
    for b = 1:m
        if(x(S)>=widthb(b,3))
            M(S) = M(S)*(widthb(b,4)-widthb(b,3))/((widthb(b,2)-widthb(b,1))*(x(S)-widthb(b,3))+widthb(b,1)*(widthb(b,4)-widthb(b,3)));
        end
        if(x(S)>=widthb(b,4))
            M(S) = M(S)*((widthb(b,2)-widthb(b,1))*(x(S)-widthb(b,3))+widthb(b,1)*(widthb(b,4)-widthb(b,3)))/(widthb(b,4)-widthb(b,3));
        end
    end
end
depthd = xlsread('depthd.xlsx');
[m,n] = size(depthd);
for S = 1:N
    M(S) = M(S);
    for d = 1:m
        if(x(S)>=depthd(d,3))
            M(S) = M(S)/(((depthd(d,2)-depthd(d,1))*(x(S)-depthd(d,3))/(depthd(d,4)-depthd(d,3)))+depthd(d,1))^3;
        end
        if(x(S)>=depthd(d,4))
            M(S) = M(S)*(((depthd(d,2)-depthd(d,1))*(x(S)-depthd(d,3))/(depthd(d,4)-depthd(d,3)))+depthd(d,1))^3;
        end
    end
end
M = 12*M;
cVa = 0;
cVb = 0;
for S = 1:N
    cVa = cVa - M(S)*delta_x*(Length - x(S));
    cVb = cVb - M(S)*delta_x*x(S);
end
cVa = cVa/Length;
cVb = cVb/Length;
cM = zeros(N,1);
for S = 1:N
    cM(S) = cVa*x(S);
    for v = 1:S
        if(x(S) >= x(v))
            cM(S) = cM(S) +M(v)*delta_x*(x(S)-x(v));
        end
    end
end
plot(x,cM)
