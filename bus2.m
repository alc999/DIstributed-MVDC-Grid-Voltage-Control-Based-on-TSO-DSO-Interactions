 function[v2,PG2,C1]=bus2(v1,v2,v3,v4,B,PL2)
PG2max= 0.333333;
% PG1max= 0.333333;
% PG1last = 0.3;
PG2last = 0.3;
% PG3last=0.1;
% PG4last=0.04;
Iijmax= 10.8;
% v1(4,4)= zeros;
% v2(4,4)= zeros; 
% v3(4,4)= zeros; 
% v4(4,4)= zeros; 
% B(4,1)=zeros;
G = [36,-18,0,-18;
     -18,44,-13,-13;
     0,-13,35,-22;
     -18,-13,-22,53;];

for i = 1:1
 B(:,i+1)= B(:,i)+ (1/3)*((v2(:,i)-v1(:,i))+(v2(:,i)-v3(:,i))+(v2(:,i)-v4(:,i))); 
  fun2 = @(y)(0.00142*y(1)^2+ 7.2*y(1)+1*(y(1)-PG1last)+(2e6/2)*((y(2)-v2(1,i))^2+(y(3)-v2(2,i))^2+(y(4)-v2(3,i))^2+(y(5)-v2(4,i))^2 +(1/3)*(y(2)*(v2(1,i)-v1(1,i))+y(3)*(v2(2,i)-v1(2,i))+y(5)*(v2(4,i)-v1(4,i))+y(3)*(v2(2,i)-v3(2,i))+y(4)*(v2(3,i)-v3(3,i))+y(5)*(v2(4,i)-v3(4,i))+y(2)*(v2(1,i)-v4(1,i))+y(3)*(v2(2,i)-v4(2,i))+y(4)*(v2(3,i)-v4(3,i))+y(5)*(v2(4,i)-v4(4,i)))+B(1,i+1)*y(2)+B(2,i+1)*y(3)+B(3,i+1)*y(4)+B(4,i+1)*y(5)));                
A = [];
b = [];
Aeq = [1, 0   ,0    ,0   ,  0, 0, -1,0,0,0;
       0,G(2,1),G(2,2),G(2,3),G(2,4),-1,0,0,0,0;
       0,-1,    1,     0,    0,0,0,1*(1/G(2,1)),0,0;
       0,0,    1, -1,   0,    0,0,0,1*(1/G(2,3)),0;
       0,0,    1, 0,   -1,    0,0,0,0,1*(1/G(2,4));
       % 0,1,0,0,0,0,0,0;
   % 0,1,0,0,0,0,0,0;
     ];
beq = [PL2;0;0;0;0];
lb= [0,0.9,0.9,0.9,0.9,(-3*Iijmax),-1,(-1*Iijmax),(-1*Iijmax),(-1*Iijmax)];
ub= [PG2max,1.1,1.1,1.1,1.1,(3*Iijmax),1,(1*Iijmax),(1*Iijmax),(1*Iijmax)];
nonlcon = @cofun2;
y0 = [0.2,1,1,1,1,0,0,0,0,0];
options = optimoptions(@fmincon,'Algorithm','sqp');
[y,exitflag] = fmincon(fun2,y0,A,b,Aeq,beq,lb,ub,nonlcon,options)
y
exitflag
v2(1,i+1)=y(2);
v2(2,i+1)=y(3);
v2(3,i+1)=y(4);
v2(4,i+1)=y(5);
PG2=y(1);
C1=B(:,i+1);

% [v1,PG1]=bus1(v2,v3,v4);
% [v3,PG3]=bus3(v1,v2,v4);
% [v4,PG4]=bus4(v1,v2,v3);
end
 end
