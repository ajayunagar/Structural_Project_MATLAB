clear all;

input_data = 'Frame Input.xlsx';
nodal_data = xlsread(input_data,'Nodal data');
member_data = xlsread(input_data,'Member Data');
nofn = length(nodal_data(:,1));
nofm = length(member_data(:,1));
n1 = member_data(:,2);
n2 = member_data(:,3);
x1 = nodal_data(n1,2);
x2 = nodal_data(n2,2);
y1 = nodal_data(n1,3);
y2 = nodal_data(n2,3);

%Material Properties
L = sqrt((x2-x1).^2 + (y2 - y1).^2);
A = member_data(:,4);
I = member_data(:,5);
E = member_data(:,6);

%Member load info.

py1 = member_data(:,7); 
ay1 = member_data(:,8);
py2 = member_data(:,9);
ay2 = member_data(:,10);
py3 = member_data(:,11);
ay3 = member_data(:,12);
q1 = member_data(:,13); 
q2 = member_data(:,14); 
a1 = member_data(:,15); 
a2 = member_data(:,16); 
m  = member_data(:,17); 
am = member_data(:,18);

%Initialization

dof= zeros(6,1,nofm);
T = zeros(6,6,nofm);
K_e_local= zeros(6,6,nofm);
K_e_global= zeros(6,6,nofm);
Fj_e_local= zeros(6,1,nofm);
Fj_e_global= zeros(6,1,nofm);
K_assembled = zeros(3*nofn,3*nofn);
Fj_assembled = zeros(3*nofn,1);
D_member_local= zeros(6,1,nofm);
F_member= zeros(6,1,nofm);

for i = 1:nofm
    
    T(:,:,i) = transformationmatrix(L(i),x1(i),y1(i),x2(i),y2(i));
    
    K_e_local(:,:,i) = stiffnessmatrix(L(i),A(i),I(i),E(i));
    K_e_global(:,:,i) = T(:,:,i)'*K_e_local(:,:,i)*T(:,:,i);
    
    Fj_e_local(:,:,i) = equivalentjointload(L(i),py1(i),ay1(i),py2(i),ay2(i),py3(i),ay3(i),q1(i),q2(i),a1(i),a2(i),m(i),am(i));
    Fj_e_global(:,:,i) = T(:,:,i)'*Fj_e_local(:,:,i);
    
    dof(:,:,i) = [3*n1(i)-2; 3*n1(i)-1; 3*n1(i); 3*n2(i)-2; 3*n2(i)-1; 3*n2(i)];
    K_assembled(dof(:,:,i),dof(:,:,i)) = K_assembled(dof(:,:,i),dof(:,:,i)) + K_e_global(:,:,i);
    Fj_assembled(dof(:,:,i),1) = Fj_assembled(dof(:,:,i),1) + Fj_e_global(:,:,i);
    
end

%% considering support settlement & nodal load

for i = 1:nofn
    
    support_settlement(3*i-2:3*i,1) = nodal_data(i,4:6)';
    F_nodal(3*i-2:3*i,1) = nodal_data(i,7:9)';
    restraints(3*i-2:3*i,1) = nodal_data(i,10:12)';
    
end

F_total = F_nodal - Fj_assembled;

%% identifying restraining degrees of freedom

total_dof = (1:3*nofn)';
restrained_dof = find(restraints == 1);
unrestrained_dof = setdiff(total_dof,restrained_dof);

%% getting active & restrained part of stiffness matrix & force vector

Kaa = K_assembled(unrestrained_dof,unrestrained_dof);
Kra = K_assembled(restrained_dof,unrestrained_dof);
Kar = K_assembled(unrestrained_dof,restrained_dof);
Krr = K_assembled(restrained_dof,restrained_dof);

F_active = F_nodal(unrestrained_dof);
F_fixed_active = Fj_assembled(unrestrained_dof);
F_fixed_restrained = Fj_assembled(restrained_dof);

D_restrained = support_settlement(restrained_dof);

%% solving displacement

D_active = Kaa\((F_active-F_fixed_active) - Kar*D_restrained);

F_restrained =  F_fixed_restrained + Kra*D_active + Krr*D_restrained;

D = support_settlement;
D(unrestrained_dof) = D_active;

%% obtaining member forces

for i = 1:nofm
    
    D_member_local(:,:,i) = T(:,:,i)*D(dof(:,:,i));
    F_member(:,:,i) = Fj_e_local(:,:,i) + K_e_local(:,:,i)*D_member_local(:,:,i);
    
end

%%