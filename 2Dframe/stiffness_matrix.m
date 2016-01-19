function [K_local] = stiffness_matrix(l,A,I,E)

a = E*A/l;
b = 12*E*I/(l);
c = 6*E*I/(l^2);
d = 4*E*I/(l);
e = 2*E*I/(l);

K_local = [a 0 0 -a 0 0;0 b c 0 -b c;0 c d 0 -c e;-a 0 0 a 0 0;0 -b -c 0 b -c;0 c e 0 -c d];

end
