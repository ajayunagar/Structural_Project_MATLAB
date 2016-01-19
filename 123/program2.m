%supports;
prompt = 'What is the span of the beam?  =  ';
Length = input(prompt);
prompt = 'say howmany supports you have? (integers only please)  =  ';
support = input(prompt);
sdis = zeros(1,support);
for i = 1:support
    string = sprintf('say at which distance from left end point support %d is acting?  =  ',i);
    prompt = string;
    sdis(1,i) = input(prompt);
end
prompt = 'say howmany hinges you want to provide?(integers only)  =  ';
hinge = input(prompt);
o = 0;
while o<1000
    if(hinge<support-2)
        display('You have to provide atlist "no.of support - 2" hinges');
        prompt = 'Your structure has to be detetminant and stable';
        hinge = input(prompt);
    else
        o=1000;
        break
    end
    o=o+1;
end
q=0;
while q<1000
    if(hinge>support-2)
        display('Sorry! you are providing more hinges than requirement , structure will not be stable');
        prompt = 'your structure has to be determinant';
        hinge = input(prompt);
    else
        q=1000;
        break
    end
    q = q+1;
end

hdis = zeros(1,hinge);
for i = 1:hinge
    string = sprintf('say at which distance from left end hinge support %d is acting?  =  ',i);
    prompt = string;
    hdis(1,i) = input(prompt);
end

%Loading
% (1)Pointload :-
prompt = 'How many Pointloads are acting on a structure? - ';
noofloads = input(prompt);
formatSpec = 'Please add the value of point load no %d  -  ';
pload = zeros(1,noofloads);
pldis = zeros(1,noofloads);
%ask input from users
for i = 1:noofloads
    str = sprintf(formatSpec,i);
    prompt = str;
    pload(i) = input(prompt);
    display(pload(i));
    string = sprintf('Please add distance of the application of load no %d . -  ',i);
    prompt = string;
    pldis(i) = input(prompt);
end
cofactor = zeros(support,support);
Moment = zeros(support,1);
for j=1:2
    for i = 1:noofloads
        Moment(j) = Moment(j)-(pload(i)*(sdis(j)-pldis(i)));
    end
end
for h = 1:hinge
    for i = 1:noofloads
        if(pldis(i)<=hdis(h))
            Moment(h+2) = Moment(h+2) - pload(i)*(hdis(h)-pldis(i));
        end
    end
end
for j=1:2
    for s = 1:support
        cofactor(j,s) = sdis(s) - sdis(j);
    end
end
for h = 1:hinge
    for s = 1:support
        if(sdis(s)<=hdis(h))
            cofactor(h+2,s) = sdis(s) - hdis(h);
        end
    end
end
pReaction = cofactor^-1 * Moment;
delta_x = Length/1000;
x = (0:delta_x:Length)';
N = size(x,1);
plV = zeros(N,1);
plM = plV;
for S = 1:N
    for p = 1:noofloads
        if(pldis(p)<=x(S))
            plV(S) = plV(S) - pload(p);
            plM(S) = plM(S) - pload(p)*(x(S)-pldis(p));
        end
    end
    for r = 1:support
        if(sdis(r)<=x(S))
            plV(S) = plV(S) + pReaction(r);
            plM(S) = plM(S) + pReaction(r)*(x(S) - sdis(r));
        end
    end
end
%(2).Uniform Loading
%input is from excel file named UDL.xlsx
UDL = xlsread('UDL.xlsx');
[m,~] = size(UDL);
valueUDL = zeros(m,1);
stUDL = zeros(m,1);
endUDL = zeros(m,1);
for j = 1:m
    valueUDL(j) = UDL(j,1);
    stUDL(j) = UDL(j,2);
    endUDL(j) = UDL(j,3);
end
uMoment = zeros(support,1);
ucofactor = cofactor;
%creacting two matrix uMoment(B) and ucofactor(A) and A^-1*B will give you
%reaction matrix
for j = 1:2
    for i = 1:m
        if(stUDL(i,1)<=sdis(j))
            if(endUDL(i)<=sdis(j))
                uMoment(j) = uMoment(j) - (endUDL(i)-stUDL(i))*valueUDL(i)*(sdis(j) - (endUDL(i)+stUDL(i))/2);
            else
                uMoment(j) = uMoment(j) - (sdis(j)-stUDL(i))*valueUDL(i)*(sdis(j)-stUDL(i))/2-(endUDL(i)-sdis(j))*valueUDL(i)*(sdis(j)-endUDL(i))/2;
            end
        else
            uMoment(j) = uMoment(j) - (endUDL(i)-stUDL(i))*valueUDL(i)*(sdis(j)-(endUDL(i)+stUDL(i))/2);
        end
    end
end
for h = 1:hinge
    for i =1:m
        if(stUDL(i)<=hdis(h))
            if(endUDL(i)<=hdis(h))
                uMoment(h+2) = uMoment(h+2) - (endUDL(i)-stUDL(i))*valueUDL(i)*(hdis(h) - (endUDL(i)+stUDL(i))/2);
            else
               uMoment(h+2) = uMoment(h+2) - (hdis(h)-stUDL(i))*valueUDL(i)*(hdis(h)-stUDL(i))/2; 
            end
        end
    end
end
uReaction = ucofactor^-1*uMoment;
%Shear and moment
udlV = zeros(N,1);
udlM = zeros(N,1);
for S = 1:N
    for i = 1:m
        if(stUDL(i) < x(S))
            if(endUDL(i) <= x(S))
                udlV(S) = udlV(S) - (endUDL(i)-stUDL(i))*valueUDL(i);
                udlM(S) = udlM(S) - (endUDL(i)-stUDL(i))*valueUDL(i)*(x(S)-(stUDL(i)+endUDL(i))/2);
            else
                udlV(S) = udlV(S) - (x(S)-stUDL(i))*valueUDL(i);
                udlM(S) = udlM(S) - (x(S)-stUDL(i))*valueUDL(i)*(x(S)-stUDL(i))/2;
            end
        end
    end
        for r = 1:support
            if(sdis(r) <= x(S))
                udlV(S) = udlV(S) + uReaction(r);
                udlM(S) = udlM(S) + uReaction(r)*(x(S)-sdis(r));
            end
        end
end
%(3). Linearly varing load
%input from excelfile named LVL.xlsx
LVL = xlsread('LVL.xlsx');
[m,n] = size(LVL);
stvLVL = zeros(m,1);
endvLVL = zeros(m,1);
stLVL = zeros(m,1);
endLVL = zeros(m,1);
for i=1:m
    stvLVL(i) = LVL(i,1);
    endvLVL(i) = LVL(i,2);
    stLVL(i) = LVL(i,3);
    endLVL(i) = LVL(i,4);
end
lMoment = zeros(support,1);
lcofactor = cofactor;
for j = 1:2
    for i = 1:m
        if(stLVL(i)<sdis(j))
            if(endLVL(i)<=sdis(j))
                lMoment(j) = lMoment(j) - (endLVL(i)-stLVL(i))*stvLVL(i)*(sdis(j) - (endLVL(i)+stLVL(i))/2) - (0.5*(endLVL(i) - stLVL(i))*(endvLVL(i)-stvLVL(i))*(sdis(j) - (stLVL(i)+2*endLVL(i))/3));
            else
                lMoment(j) = lMoment(j) - ((sdis(j)-stLVL(i))*stvLVL(i)*(sdis(j)-stLVL(i))/2)- ((1/6)*((endvLVL(i)-stvLVL(i))*(sdis(j)-stLVL(i))/(endLVL(i)-stLVL(i)))*(sdis(j)-stLVL(i))*(sdis(j)-stLVL(i)))+ ((((endvLVL(i)-stvLVL(i))*(sdis(j)-stLVL(i))/(endLVL(i)-stLVL(i)))+ stvLVL(i))*(endLVL(i)-sdis(j))*0.5*(endLVL(i)-sdis(j)))+((1/3)*(endvLVL(i) - (((endvLVL(i)-stvLVL(i))*(sdis(j)-stLVL(i))/(endLVL(i)-stLVL(i)))+stvLVL(i)))*(endLVL(i)-sdis(j))*(endLVL(i)-sdis(j)));
            end
        else
            lMoment(j) = lMoment(j) + ((endLVL(i)-stLVL(i))*stvLVL(i)*((endLVL(i)+stLVL(i))/2)-sdis(j))+(0.5*(endLVL(i)-stLVL(i))*(endvLVL(i)-stvLVL(i))*((stLVL(i)+2*endLVL(i))/3-sdis(j)));
        end
    end
end
for h = 1:hinge
    for i =1:m
        if(stLVL(i)<hdis(h))
            if(endLVL(i)<=hdis(h))
                lMoment(h+2) = lMoment(h+2) - ((endLVL(i)-stLVL(i))*stvLVL(i)*(hdis(h) - (endLVL(i)+stLVL(i))/2))-(0.5*(endLVL(i) - stLVL(i))*(endvLVL(i)-stvLVL(i))*(hdis(h) - (stLVL(i)+2*endLVL(i))/3));
            else
               lMoment(h+2) = lMoment(h+2) - ((hdis(h)-stLVL(i))*stvLVL(i)*(hdis(h)-stLVL(i))/2)- ((1/6)*((endvLVL(i)-stvLVL(i))*(hdis(h)-stLVL(i))/(endLVL(i)-stLVL(i)))*(hdis(h)-stLVL(i))*(hdis(h)-stLVL(i)));
            end
        end
    end
end

lReaction = lcofactor^-1*lMoment;
%calculation of shear and bending moment diagram
lvlV = zeros(N,1);
lvlM = zeros(N,1);
for S=1:N
    for i=1:m
        if(stLVL(i)<x(S))
            if(endLVL(i)<=x(S))
               lvlV(S) = lvlV(S) - ((endLVL(i)-stLVL(i))*stvLVL(i)) - (0.5*(endLVL(i) - stLVL(i))*(endvLVL(i)-stvLVL(i)));
               lvlM(S) = lvlM(S) - ((endLVL(i)-stLVL(i))*stvLVL(i)*(x(S) - ((endLVL(i)+stLVL(i))/2))) - (0.5*(endLVL(i) - stLVL(i))*(endvLVL(i)-stvLVL(i))*(x(S) - ((stLVL(i)+2*endLVL(i))/3)));
            else
                lvlV(S) = lvlV(S) - ((x(S)-stLVL(i))*stvLVL(i)) - (0.5*((endvLVL(i)-stvLVL(i))*(x(S)-stLVL(i))/(endLVL(i)-stLVL(i)))*(x(S)-stLVL(i)));
                lvlM(S) = lvlM(S) - ((x(S)-stLVL(i))*stvLVL(i)*(x(S)-stLVL(i))/2)- ((1/6)*((endvLVL(i)-stvLVL(i))*(x(S)-stLVL(i))/(endLVL(i)-stLVL(i)))*(x(S)-stLVL(i))*(x(S)-stLVL(i)));
            end
        end
    end
    for r = 1:support
            if(sdis(r) <= x(S))
                lvlV(S) = lvlV(S) + lReaction(r);
                lvlM(S) = lvlM(S) + lReaction(r)*(x(S)-sdis(r));
            end
    end
end
%(3). Moment application
prompt = 'How many Moment load are acting on a structure? - ';
nofMoments = input(prompt);
formatSpec = 'Please add the value of Moment load no %d  -  ';
mload = zeros(1,nofMoments);
mldis = zeros(1,nofMoments);
%ask input from users
for i = 1:nofMoments
    str = sprintf(formatSpec,i);
    prompt = str;
    mload(i) = input(prompt);
    string = sprintf('Please add distance of the application of Moment load no %d . -  ',i);
    prompt = string;
    mldis(i) = input(prompt);
end
mMoment = zeros(support,1);
mcofactor = cofactor;
for j = 1:2
    for i = 1:nofMoments
    mMoment(j)=mMoment(j)-mload(i);
    end
end
for h = 1:hinge
    for i = 1:nofMoments
        if(mldis(i)<=hdis(h))
            mMoment(h+2) = mMoment(h+2)-mload(i);
        end  
    end
end
mReaction = mcofactor^-1 * mMoment;
%Calculation of shear fore and bending moment
mV = zeros(N,1);
mM = zeros(N,1);
for S=1:N
    for i = 1:nofMoments
        if(mldis(i)<=x(S))
            mM(S) = mM(S) - mload(i);
        end
    end
    for r=1:support
        if(sdis(r)<=x(S))
            mV(S) = mV(S) + mReaction(r);
            mM(S) = mM(S) + mReaction(r)*(x(S) - sdis(r));
        end
    end
end
V = plV+udlV+lvlV+mV;
M = plM+udlM+lvlM+mM;
M1=M;
V1=V;
%* Deflection calculations
% Using unitload method
%1.Calculating M/E
% E = xlsread('E.xlsx');
% [m,~] = size(E);
% for S=1:N
%     M(S) = M(S);
%     for w = 1:m
%         if(x(S)>=E(w,2))
%             M(S) = M(S)/E(w,1);
%         end
%         if(x(S)>E(w,3))
%             M(S) = M(S)*E(w,1);
%         end
%     end
% end
% % %2.For M/Eb
% widthb = zeros(N,1);
% prompt = ' How many partition of beam you want for width variation? ';
% bpart = input(prompt);
% bstart = zeros(bpart,1);
% bend = bstart;
% bdeg = bstart;
% for i = 1:bpart
%     string1 = sprintf('Starting point of the parition no. %d ',i);
%     prompt = string1;
%     bstart(i) = input(prompt);
%     string2 = sprintf('Ending point of the partition no. %d ',i);
%     prompt = string2;
%     bend(i) = input(prompt);
%     string3 = sprintf('Which degree of equation you want to fit for partition no. %d ? - ',i);
%     prompt = string3;
%     bdeg(i) = input(prompt);
% end
% str = sprintf('You need to provide atleast %d points to fit the equation ',bdeg+1);
% display(str);
% for i = 1:bpart
%     point = zeros(1,bdeg(i)+1);
%     wb = zeros(bdeg(i)+1,1);
%     for g = 1 : bdeg(i)+1
%         str = sprintf('x for point no. %d. - ',g);
%         prompt = str;
%         point(g) = input(prompt);
%         str2 = sprintf('width at point no. %d. - ',g);
%         prompt = str2;
%         wb(g) = input(prompt);
%         l=0;
%         while l <1000
%             if(wb(g)<=0)
%                 display('negative value not possible for width');
%                 prompt = 'please add positive value';
%                 wb(g) = input(prompt);
%             else
%                 l = 1000;
%                 break
%             end
%                 l= l+1;
%         end
%      end
%     matA = zeros(bdeg(i)+1,bdeg(i)+1);
%     for j = 1 : bdeg(i)+1
%         for k = 1:bdeg(i)+1
%             matA(j,k) = point(j)^(k-1);
%         end
%     end
%     coeff = (matA^(-1))*wb;
%    for S=1:N
%         if(x(S)>=bstart(i))
%             for p = 1:bdeg(i)+1
%                 widthb(S) = widthb(S) + coeff(p)*((x(S))^(p-1));
%             if(x(S)>=bend(i))
%                 widthb(S) = widthb(S) - coeff(p)*((x(S))^(p-1));
%             end
%             end
%         end
%     end
% end
% % % %3. For M/Ebd^3
% % depthd = zeros(N,1);
% % prompt = 'How many partition of beam you want for depth variation ? ';
% % dpart = input(prompt);
% % dstart = zeros(dpart,1);
% % dend = dstart;
% % ddeg = dstart;
% % for i=1:dpart
% %     string1 = sprintf('Starting point of the parition no. %d ',i);
% %     prompt = string1;
% %     dstart(i) = input(prompt);
% %     string2 = sprintf('Ending point of the partition no. %d ',i);
% %     prompt = string2;
% %     dend(i) = input(prompt);
% %     string3 = sprintf('Which degree of equation you want to fit for partition no. %d ? - ',i);
% %     prompt = string3;
% %     ddeg(i) = input(prompt);
% % end
% %     str = sprintf('You need to provide atleast %d points to fit the equation ',ddeg+1);
% %     display(str);
% % for i = 1:bpart
% %     point = zeros(1,ddeg(i)+1);
% %     dd = zeros(ddeg(i)+1,1);
% %     for g = 1 : ddeg(i)+1
% %         str = sprintf('x for point no. %d. - ',g);
% %         prompt = str;
% %         point(g) = input(prompt);
% %         str2 = sprintf('depth at point no. %d. - ',g);
% %         prompt = str2;
% %         dd(g) = input(prompt);
% %         l=0;
% %         while l <1000
% %             if(dd(g)<=0)
% %                 display('negative value not possible for depth');
% %                 prompt = 'please add positive value';
% %                 dd(g) = input(prompt);
% %             else
% %                 l = 1000;
% %                 break
% %             end
% %                 l= l+1;
% %         end
% %     end
% %     matA = zeros(ddeg(i)+1,ddeg(i)+1);
% %     for j = 1 : ddeg(i)+1
% %         for k = 1:ddeg(i)+1
% %             matA(j,k) = point(j)^(k-1);
% %         end
% %     end
% %     coeff = (matA^(-1))*dd;
% %     for S=1:N
% %         if(x(S)>=dstart(i))
% %             for p = 1:ddeg(i)+1
% %                 depthd(S) = depthd(S) + coeff(p)*((x(S))^(p-1));
% %             if(x(S)>=dend(i))
% %                 depthd(S) = depthd(S) - coeff(p)*((x(S))^(p-1));
% %             end
% %             end
% %         end
% %     end
% % end
E = 10*10^9;
I = 1.2833*10^-3;

%4.Calculating EI    
for S=1:N
    M(S) = M(S)/(E*I);
end
% %5.unit load moment calculation[==]
mpload=1;
deflection = zeros(N,1);
mplM = zeros(N,1);
for S=1:N
    mpldis = x(S);
    defcofactor = zeros(support,support);
    defMoment = zeros(support,1);
  for j = 1:2
        defMoment(j) = defMoment(j)-(mpload *(sdis(j)-mpldis));
  end
  for h = 1:hinge 
        if(mpldis <= hdis(h))
            defMoment(h+2) = defMoment(h+2) - mpload*(hdis(h) - mpldis);
        end
  end
  for j=1:2
    for s = 1:support
        defcofactor(j,s) = sdis(s) - sdis(j);
    end
  end
  for h = 1:hinge
    for s = 1:support
        if(sdis(s)<=hdis(h))
            defcofactor(h+2,s) = sdis(s) - hdis(h);
        end
    end
  end
defReaction = defcofactor^-1 * defMoment;
  for Z = 1:N
        if(mpldis <= x(Z))
            mplM(Z) = mplM(Z) - mpload*(x(Z)-mpldis);
        end
    for r = 1:support
        if(sdis(r)<=x(Z))
            mplM(Z) = mplM(Z) + defReaction(r)*(x(Z) - sdis(r));
        end
    end
  end
 for T=1:N
        deflection(S) = deflection(S)+M(T)*mplM(T)*delta_x;
 end
end














