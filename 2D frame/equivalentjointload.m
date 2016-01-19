function [Fj] = equivalentjointload(L,py1,ay1,py2,ay2,py3,ay3,q1,q2,a,b,m,am)

if py1 ~= 0
    f31 = py1*ay1*(1-ay1/L)^2 ;
    f61 = -py1*((ay1/L)^2)*(L-ay1);
    f21 = py1*(1 - ay1/L) + (f31 + f61)/L;
    f51 = py1*ay1/L - (f31 + f61)/L;
    Fj1 = [0;f21;f31;0;f51;f61];
else
    Fj1 = zeros(6,1);
end
if py2 ~= 0
    f312 = py2*ay2*(1-ay2/L)^2 ;
    f612 = -py2*((ay2/L)^2)*(L-ay2);
    f212 = py2*(1 - ay2/L) + (f31 + f61)/L;
    f512 = py2*ay2/L - (f31 + f61)/L;
    Fj12 = [0;f212;f312;0;f512;f612];
else
    Fj12 = zeros(6,1);
end
if py3 ~= 0
    f313 = py3*ay3*(1-ay3/L)^2 ;
    f613 = -py3*((ay3/L)^2)*(L-ay3);
    f213 = py3*(1 - ay3/L) + (f31 + f61)/L;
    f513 = py3*ay3/L - (f31 + f61)/L;
    Fj13 = [0;f213;f313;0;f513;f613];
else
    Fj13 = zeros(6,1);
end
if q1 ~= 0 && q2 ~= 0
    c = @(x) (q1 + (q2 - q1)*x./b).*x.*(1-x./L).^2;
    d = @(x) (q1 + (q2 - q1)*x./b).*(L-x).*(x./L).^2;
    e = @(x) (q1 + (q2 - q1)*x./b).*(1-x./L);
    f = @(x) (q1 + (q2 - q1)*x./b).*x./L;
    f32 = integral(c, a,b+a) ;
    f62 = -integral(d, a,b+a);
    f22 = integral(e, a,b+a) + (f32 + f62)/L;
    f52 = integral(f, a,b+a) - (f32 + f62)/L;
    Fj2 = [0;f22;f32;0;f52;f62];
else
    Fj2 = zeros(6,1);
end

if m ~= 0
    f33 = -m*(1-am/L)*(1-3*am/L);
    f63 = m*am*(2*L-3*am)/L^2;
    f23 = (f33 + f63)/L;
    f53 = -(f33 + f63)/L;
    Fj3 = [0;f23;f33;0;f53;f63];
else
    Fj3 = zeros(6,1);
end

Fj = (Fj1 + Fj12 + Fj13 + Fj2 + Fj3);

end