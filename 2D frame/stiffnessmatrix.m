function [K_local] = stiffnessmatrix(L,A,I,E)

a = E*A/L;
b = 12*E*I/(L^3);
K_local = [a 0 0 -a 0 0;0 b a 0 -b b*L/2;0 b*L/2 b*L^2/3 0 -b*L/2 b*L^2/6;-a 0 0 a 0 0;0 -b -b*L/2 0 b -b*L/2;0 b*L/2 b*L^2/6 0 -b*L/2 b*L^2/3];

end
