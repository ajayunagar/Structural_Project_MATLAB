prompt = 'What is the length of the beam?';
Length = input(prompt);
LVLfile = xlsread('LVL.xlsx');
[m,n] = size(LVLfile);
vls = zeros(1,m);
vle = zeros(1,m);
lvls = zeros(1,m);
lvle = zeros(1,m);
for z =1:m
    vls(z) = LVLfile(z,3);
    vle(z) = LVLfile(z,4);
    lvls(z) = LVLfile(z,1);
    lvle(z) = LVLfile(z,2);
end
Va = 0;
Vb = 0;
for r = 1:m
    Va = Va + lvls(1,r)*(vle(1,r) - vls(1,r))*(Length - (vle(1,r)+vls(1,r))/2) + 0.5*(lvle(1,r) - lvls(1,r))*(vle(1,r)-vls(1,r))*(Length - (vls(1,r) + 2*vle(1,r))/3);
    Vb = Vb + lvls(1,r)*(vle(1,r) - vls(1,r))*(vle(1,r)+vls(1,r))/2 + 0.5*(lvle(1,r)-lvls(1,r))*(vle(1,r)-vls(1,r))*(vls(1,r)+2*vle(1,r))/3;
end
Va = Va/Length;
Vb = Vb/Length;
delta_x = Length/100000;
x = (0:delta_x:Length)';
N = size(x,1);
V = zeros(N,1);
M = V;
for S = 1:N
    V(S) = Va;
    M(S) = Va*x(S);
    for y = 1:m
        if(x(S) >= vls(1,y))
            V(S) = V(S) - lvls(1,y)*(x(S) - vls(1,y)) - 0.5*((lvle(1,y)-lvls(1,y))*(x(S)-vls(1,y))^2/(vle(1,y)-vls(1,y)));
            M(S) = M(S) - lvls(1,y)*((x(S)-vls(1,y))^2)/2 - (1/6)*(lvle(1,y)-lvls(1,y))*((x(S)-vls(1,y))^3)/(vle(1,y)-vls(1,y));
        end
        if(x(S) >= vle(1,y))
            V(S) = Va;
            M(S) = Va*x(S);
            for a = 1:y
            V(S) = V(S) - lvls(1,a)*(vle(1,a)-vls(1,a)) - (lvle(1,a)-lvls(1,a))*(vle(1,a)-vls(1,a))/2;
            M(S) = M(S) - lvls(1,a)*(vle(1,a)-vls(1,a))*(x(S)-(vls(1,a)+vle(1,a))/2) - (1/6)*(lvle(1,a)-lvls(1,a))*(vle(1,a)-vls(1,a))*(3*x(S)-vls(1,a)-2*vle(1,a));
            end
        end
        
    end
end
plot(x,V)