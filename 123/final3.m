prompt='what is the length of the beam?-';
length=input(prompt);

%taking no of supports and hinges
prompt= 'how many pinned or roller supports are there?-';
 s1=input(prompt);
 s2=zeros(s1,1);
 for i=1:s1
  string = sprintf('Please type location of the roller support %d . -  ',i);
     prompt = string; 
     s2(i)=input(prompt);
 end
 prompt= 'how many hinges are there?-';
 s3=input(prompt);
 s4=zeros(s3,1);
 for k=1:s3
      string = sprintf('Please type location of the hinge %d . -  ',k);
     prompt = string; 
     s4(k)=input(prompt);
 end
 %calculating determinancy of structure
 d1=zeros(s1,s1);
  for i=1:s1
         d1(1,i)=1;
     end
     for k=1:s1
         d1(2,k)=(s2(k)-s2(1));
     end
     %taking right side of hinge moment=0
     for i=1:s3
         for k=1:s1;
         if(s2(k)>s4(i))
             d1(i+2,k)=s2(k)-s4(i);
         end
         end
     end
    
     [e,f]=size(d1);
     if(e~=f)
         disp('structure is unstable');
     end
     if(e==f)
         d2=det(d1);
        if(d2==0)
            disp('structure is not determinant');
            
        end
        if(d2~=0)
            disp('structure is detrminant');
            %taking point load values
 prompt= 'how many point loads are acting on the beam?-';
 g=input(prompt);
 point=zeros(g,2);
 dx=(1/10);
p=(0:dx:length)';
n=size(p,1);
p1=zeros(n,1);
 for i=1:g
 string = sprintf('Please type the value of the application of load in kilo newton of no %d . -  ',i);
     prompt = string; 
 point(i,1)=input(prompt)*(10^(3));
 string = sprintf('Please type  distance of the application of load in metre of no %d . -  ',i);
    prompt = string;
 point(i,2)=input(prompt);
 end
            %taking variable loads
prompt='how many variable loads are there?-';
n2=input(prompt);
v2=zeros(n,1);
m2=zeros(n,1);
c=[]
range=[]
h=zeros(n,1);
h2=zeros(n,1);
for u=1:n2
    
string = sprintf('Please type the function of the variable load in   newton  %d . -  ',u);
    prompt = string;

c=input(prompt);
string=sprintf('please type range of the variable load %d-',u);
prompt=string;
range=input(prompt);
k=0;l=0;
for i=1:n
    if(range(1)==p(i))
        k=i;
    end
    if(range(2)==p(i))
        l=i
    end
end
m=zeros(n,1);
for o=k:l
    m(o)=polyval(c,p(o));
end

h=zeros(n,1);
for i=1:n
    h(i)=m(i)*dx;
end

h2=h2+h;


end
%calculating E and I
prompt= 'what modulus of elasticity in GPa?-';
 E1=input(prompt);
 E=E1*10^(9);
 prompt='how many partitions of beam are there?'
 t1=input(prompt);
 I=zeros(n,1);
 c2=[]
 range2=[]
 c3=[]
 t2=0;t3=0;
 %calculating I
%  for y1=1:t1
%      string = sprintf('Please type the width  %d . -  ',y1);
%     prompt = string;
%     c2=input(prompt);
%   string=sprintf('please type the length %d-',y1);
%   prompt=string;
%   c3=input(prompt);
%   string=sprintf('please type the range %d-',y1);
%   prompt=string;
%   range2=input(prompt)
%   for y2=1:n
%     if(range2(1)==p(y2))
%         t2=y2;
%     end
%     if(range2(2)==p(y2))
%         t3=y2;
%     end
% end
%   for y3=t2:t3
% I(y3)=(((polyval(c2,y3))*((polyval(c3,y3))^(3)))/12);
%   end
%  end
%combining point loads and variable loads
I = 1.26*10^-3;
p2=zeros(n,1);
p2=h2;

 for i=1:n
     for k=1:g
     if(point(k,2)==p(i))
         p2(i)=h2(i)+point(k,1);
     end
     end
 end
 %constant moments
 moment=xlsread('moment.xlsx');
[q,w]=size(moment);
p3=0;

%finding reactions at supports
%s1-no of pinned or roller supports s2-location of supports 
%s3-no of hinges s4-location of hinges
b1=zeros(s1,1);
x=zeros(s1,1);
for i=1:n
    %Fy=0
    b1(1)=p2(i);
    %taking moment about first support
    if(p(i)>s2(1))
    b1(2)=p2(i)*(p(i)-s2(1));
    end
    if(p(i)<=s2(1))
        b1(2)=-p2(i)*(s2(1)-p(i));
    end
        %taking moment right side of hinge =0
    for k=1:s3
        if(p(i)>s4(k))
            b1(k+2)=p2(i)*(p(i)-s4(k));
        end
    end
    x=x+(d1\b1);
    
end
%calculating reactions from constant moments
if(moment(1,2)<=length)
    for k=1:q
    p3=p3+moment(k,1);
end    
b2=zeros(s1,1);
    b2(1)=0;
    b2(2)=-p3;
    for i=1:s3
        for k=1:q
        if(moment(k,2)>s4(i))
            b2(i+2)=b2(i+2)-moment(k,1);
        end
        end
    end
    x2=zeros(s1,1);x3=zeros(s1,1);
        x2=d1\b2;
         p3=zeros(n,1);
 for i=1:s1
     for k=1:n
         if(s2(i)==p(k))
             p3(k)=p3(k)-x2(i);
         end
     end
 end 
     %calculating shear force and bending moment from constant moments
 v2=zeros(n,1);bm2=zeros(n,1);
 for i=1:n
     for j=1:i
         v2(i)=v2(i)-p3(j);
     end
 end
 for i=1:n
     for j=1:i
         bm2(i)=bm2(i)-p3(j)*(p(i)-p(j));
     end
 end
 
 for i=1:q
     for j=1:n
         if(p(j)>moment(i,2))
             bm2(j)=bm2(j)-moment(i,1);
         end
     end
 end
end
if(moment(1,2)>length)
    bm2=zeros(n,1);
end
        
        x3=x2+x;
 %calculating shear force and bending moment
 for i=1:s1
     for k=1:n
         if(s2(i)==p(k))
             p2(k)=p2(k)-x(i);
         end
     end
 end


 
 v1=zeros(n,1);bm1=zeros(n,1);
 for i=1:n
     for j=1:i
     v1(i)=v1(i)-p2(j);
     end
 end
 %calculating bm from variable and point loads
 for i=1:n
     bm1(i)=0;
     for j=1:i
         bm1(i)=bm1(i)-p2(j)*(p(i)-p(j));
     end
 end
 bmf=bm1+bm2;
 vf=v1+v2;
 
 
 
 
 %calculating deflection of the beam
 x4=zeros(s1,1);
  bm3=zeros(n,1);
  f1=zeros(n,1);
 u1=zeros(n,1);
 b3=zeros(s1,1);
 d=zeros(n,1);
 b3(1)=1;A2=0;
     f2=zeros(n,1);
 for i1=1:n
     u1=zeros(n,1);
     u1(i1)=1;
     if(p(i1)>s2(1))
         b3(2)=1*(p(i1)-s2(1));
     end
     if(p(i1)<=s2(1))
         b3(2)=-1*(s2(1)-p(i1));
     end
     for i2=1:s3
         if(p(i1)<=s4(i2))
             b3(i2+2)=0;
         end
         if(p(i1)>s4(i2))
             b3(i2+2)=1*(p(i1)-s4(i2));
         end
     end
     x4=d1\b3;
     for i3=1:s1
         for i4=1:n
             if(s2(i3)==p(i4))
                 u1(i4)=u1(i4)-x4(i3);
             end
         end
     end
     %calculating bm due to unit load
     bm3=zeros(n,1);
     for i5=1:n
         bm3(i5)=0;
         for i6=1:i5
             bm3(i5)=bm3(i5)-(u1(i6)*(p(i5)-p(i6)));
         end
     end
     
    
     for i8=1:n
         f1(i8)=(bmf(i8)*bm3(i8));
     end
     for i9=1:n
         f2(i9)=(f1(i9))/(I);
     end
     f2=f2/E;
     
     
     A=0;
     for i7=1:n
         A=A+((f2(i7))*dx);
     end
     
     
     d(i1)=A;
    
     
 end
             
        end
     end
     

 
 

         
         
         
         
         
         
     
             
    
    
    

    
        
        
    
    
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
