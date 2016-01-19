%For calculation of moment
prompt = 'What is the length of the beam? - ';
Length = input(prompt);
M = xlsread('MOMENT.xlsx');
[m,n] = size(M);
apm = zeros(1,m);      %define a matrix for applied moment
apma = zeros(1,m);     %define a matrix for point of application of moment
for z=1:m
    apm(z) = M(z,1);
    apma(z) = M(z,2);
end
Va = 0;
Vb = 0;
for r=1:m
    Va = Va + apm(1,r);
    Vb = Vb  - apm(1,r);
end
Va = Va/Length;
Vb = Vb/Length;
delta_x = Length/100000;
x = (0:delta_x:Length)';
N = size(x,1);
V = zeros(N,1);
M = V;
for S=1:N
    V(S) = Va;
    M(S) = Va*x(S);
    for y = 1:m
        if(x(S) >= apma(1,y))
            V(S) = V(S);
            M(S) = M(S) - apm(1,y);
        end
    end
end
plot(x,V)
