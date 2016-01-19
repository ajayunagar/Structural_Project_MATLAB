prompt = 'What is the length of the beam?';
Length = input(prompt);
UDLfile = xlsread('UDL.xlsx');
[m,n] = size(UDLfile);
Va = 0;
Vb = 0;
for i =1:m
    Va = Va + ((UDLfile(i,1)) * (UDLfile(i,3) - UDLfile(i,2))*(Length - (UDLfile(i,3) + UDLfile(i,2))/2));
    Vb = Vb + (UDLfile(i,1)) * (UDLfile(i,3) - UDLfile(i,2))*(UDLfile(i,3) + UDLfile(i,2))/2;
end
Va = Va/Length;
Vb = Vb/Length;
delta_x = Length/100000;
x = (0:delta_x:Length)';
upl = zeros(1,m);
uls = zeros(1,m);
ule = zeros(1,m);
z = 0;
while z<m
    z = z+1;
    upl(z) = (delta_x)*(UDLfile(z,1));
    uls(z) = UDLfile(z,2);
    ule(z) = UDLfile(z,3);
end
N = size(x,1);
V = zeros(N,1);
M = V;
for S = 1:N
    V(S) = Va;
    M(S) = Va*x(S);
    for y = 1:m
        if(x(S) >= uls(1,y))
            V(S) = V(S) - UDLfile(y,1)*(x(S) - uls(1,y));
            M(S) = M(S) - UDLfile(y,1)*(x(S) - uls(1,y))^2/2;
        end
        if(x(S) >= ule(1,y))
            V(S) = Va;
            M(S) = Va*x(S);
            for a = 1:y
            V(S) = V(S) - UDLfile(a,1)*(ule(1,a) - uls(1,a));
            M(S) = M(S) - UDLfile(a,1)*(ule(1,a) - uls(1,a))*(x(S) - (ule(1,a)+uls(1,a))/2);
            end
        end
        
    end
end
plot(x,V)
    