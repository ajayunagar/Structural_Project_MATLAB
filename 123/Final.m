%Final sCript
%pointload 
prompt = 'What is the length of the beam? - ';
Length = input(prompt);
prompt = 'How many Pointloads are acting on a structure? - ';
noofloads = input(prompt);
formatSpec = 'Please add the value of point load no %d  -  ';
pl = zeros(1,noofloads);
l = zeros(1,noofloads);
nforpl = 0;
%ask input from users
while nforpl < noofloads
    nforpl = nforpl+1;
    str = sprintf(formatSpec,nforpl);
    prompt = str;
    pl(nforpl) = input(prompt);
    string = sprintf('Please add distance of the application of load no %d . -  ',nforpl);
    prompt = string;
    l(nforpl) = input(prompt);
    display(l(nforpl));
end

pVb = 0;
for c = 1:noofloads
    pVb = pVb + pl(1,c)*l(1,c);
end
pVb = pVb/Length;
Totalload = 0;
for z = 1:noofloads
    Totalload = Totalload + pl(1,z);
end
pVa = Totalload - pVb;
delta_x = Length/1000;
x = (0:delta_x:Length)';
N = size(x,1);
pV = zeros(N,1);
pM = pV;
for S = 1:N
    pV(S) = pVa;
    pM(S) = pVa * x(S);
    for v = 1:noofloads
        if(x(S) >= l(1,v))
            pV(S) = pV(S) - pl(1,v);
            pM(S) = pM(S) - pl(1,v)*(x(S) - l(1,v));
        end
    end
end
%UDL
UDLfile = xlsread('UDL.xlsx');
[m,n] = size(UDLfile);
udlVa = 0;
udlVb = 0;
for i =1:m
    udlVa = udlVa + ((UDLfile(i,1)) * (UDLfile(i,3) - UDLfile(i,2))*(Length - (UDLfile(i,3) + UDLfile(i,2))/2));
    udlVb = udlVb + (UDLfile(i,1)) * (UDLfile(i,3) - UDLfile(i,2))*(UDLfile(i,3) + UDLfile(i,2))/2;
end
udlVa = udlVa/Length;
udlVb = udlVb/Length;
upl = zeros(1,m);
uls = zeros(1,m);
ule = zeros(1,m);
for z=1:m
    upl(z) = (delta_x)*(UDLfile(z,1));
    uls(z) = UDLfile(z,2);
    ule(z) = UDLfile(z,3);
end
udlV = zeros(N,1);
udlM = udlV;
for S = 1:N
    udlV(S) = udlVa;
    udlM(S) = udlVa*x(S);
    for y = 1:m
        if(x(S) >= uls(1,y))
            udlV(S) = udlV(S) - UDLfile(y,1)*(x(S) - uls(1,y));
            udlM(S) = udlM(S) - UDLfile(y,1)*(x(S) - uls(1,y))^2/2;
        end
        if(x(S) >= ule(1,y))
            udlV(S) = udlVa;
            udlM(S) = udlVa*x(S);
            for a = 1:y
            udlV(S) = udlV(S) - UDLfile(a,1)*(ule(1,a) - uls(1,a));
            udlM(S) = udlM(S) - UDLfile(a,1)*(ule(1,a) - uls(1,a))*(x(S) - (ule(1,a)+uls(1,a))/2);
            end
        end
        
    end
end
%LVL
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
lvlVa = 0;
lvlVb = 0;
for r = 1:m
    lvlVa = lvlVa + lvls(1,r)*(vle(1,r) - vls(1,r))*(Length - (vle(1,r)+vls(1,r))/2) + 0.5*(lvle(1,r) - lvls(1,r))*(vle(1,r)-vls(1,r))*(Length - (vls(1,r) + 2*vle(1,r))/3);
    lvlVb = lvlVb + lvls(1,r)*(vle(1,r) - vls(1,r))*(vle(1,r)+vls(1,r))/2 + 0.5*(lvle(1,r)-lvls(1,r))*(vle(1,r)-vls(1,r))*(vls(1,r)+2*vle(1,r))/3;
end
lvlVa = lvlVa/Length;
lvlVb = lvlVb/Length;
lvlV = zeros(N,1);
lvlM = lvlV;
for S = 1:N
    lvlV(S) = lvlVa;
    lvlM(S) = lvlVa*x(S);
    for y = 1:m
        if(x(S) >= vls(1,y))
            lvlV(S) = lvlV(S) - lvls(1,y)*(x(S) - vls(1,y)) - 0.5*((lvle(1,y)-lvls(1,y))*(x(S)-vls(1,y))^2/(vle(1,y)-vls(1,y)));
            lvlM(S) =lvlM(S) - lvls(1,y)*((x(S)-vls(1,y))^2)/2 - (1/6)*(lvle(1,y)-lvls(1,y))*((x(S)-vls(1,y))^3)/(vle(1,y)-vls(1,y));
        end
        if(x(S) >= vle(1,y))
            lvlV(S) = lvlVa;
            lvlM(S) = lvlVa*x(S);
            for a = 1:y
            lvlV(S) = lvlV(S) - lvls(1,a)*(vle(1,a)-vls(1,a)) - (lvle(1,a)-lvls(1,a))*(vle(1,a)-vls(1,a))/2;
            lvlM(S) = lvlM(S) - lvls(1,a)*(vle(1,a)-vls(1,a))*(x(S)-(vls(1,a)+vle(1,a))/2) - (1/6)*(lvle(1,a)-lvls(1,a))*(vle(1,a)-vls(1,a))*(3*x(S)-vls(1,a)-2*vle(1,a));
            end
        end
        
    end
end
%For calculation of moment
M = xlsread('MOMENT.xlsx');
[m,n] = size(M);
apm = zeros(1,m);      %define a matrix for applied moment
apma = zeros(1,m);     %define a matrix for point of application of moment
for z=1:m
    apm(z) = M(z,1);
    apma(z) = M(z,2);
end
mVa = 0;
mVb = 0;
for r=1:m
    mVa = mVa + apm(1,r);
    mVb = mVb  - apm(1,r);
end
mVa = mVa/Length;
mVb = mVb/Length;
mV = zeros(N,1);
mM = mV;
for S=1:N
    mV(S) = mVa;
    mM(S) = mVa*x(S);
    for y = 1:m
        if(x(S) >= apma(1,y))
            mV(S) = mV(S);
            mM(S) = mM(S) - apm(1,y);
        end
    end
end
Va = pVa + udlVa + lvlVa + mVa;
Vb = pVb + udlVb + lvlVb + mVb;
V = pV + udlV + lvlV + mV;
M = pM + udlM + lvlM + mM;
M1 = M;
V1 = V;
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
