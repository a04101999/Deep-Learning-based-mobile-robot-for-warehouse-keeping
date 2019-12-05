%% neural controller for obstacle avoidance *((1./(1+exp(-h)))')
clc; clear all; close all;

s=[19 17 15 13 10 8 6 4 3 2];
vld=[2.85 2.75 2.65 2.4 2 1.5 0.95 0.8 0.6 0.4];
vrd=[2.85 2.75 2.65 2.4 2 1.5 1 0.55 0.2 -0.2];
%%pre[9 7 5 3.5 2.5];
eta=.05;
wl=.1*rand(1,3);
wr=.1*rand(1,3);
a=.1*rand(3,1);
b=.1*rand(3,1);
%E=10*ones(1,100000);
flag=-1;
maxx=-6;
for i=1:200000
    maxx=-5;
 for j=1:10
     h=a*s(j) + b;
     
     
     vl =  wl*(1./(1+exp(-h)));
     vr =  wr*(1./(1+exp(-h)));
     
      
     wrnew = wr + eta*(vrd(j)-vr)*((1./(1+exp(-h)))');
     
     wlnew = wl + eta*(vld(j)-vl)*((1./(1+exp(-h)))');
     k=((1./(1+exp(-h))).*(1-(1./(1+exp(-h)))))';
  %%anew  = a+ eta*((vld(j)-vl)*(wl.*k)*s(j)+(vrd(j)-vr)*(wr.*k)*s(j))';
    anew  = a+ eta*((((vld(j)-vl)*wl).*k)*s(j)+(((vrd(j)-vr)*wr).*k)*s(j))';
    bnew =  b+ eta*((((vld(j)-vl)*wl).*k)*1+(((vrd(j)-vr)*wr).*k)*1)';    %%input for bias is 1
       El=.5*((vld(j)-vl).^2);
       Er=.5*((vrd(j)-vr).^2);
     
     
       wl = wlnew;
       wr = wrnew;
       a  = anew;
       b  = bnew;
      
           
                k =max(El,Er);
            
              
           
               if    k >  maxx
                      maxx=k;
             
                 end 
 end         
             
               E(i)=maxx;
               if E(i) <.001
                   break;
                end
        
end 

%%result
 i
 j
 E(i)
%%plot(E);
a
b

for i=1:10
 
 h=a*s(i) + b;
 
 vl =  wl*(1./(1+exp(-h)))
 vr =  wr*(1./(1+exp(-h)));
 s(i)
 
end
 
 %display("PREDICTION 90 70 50 35 25");
 for i=1:11
     
     
 
%% h=a*pre(i) + b;
 %%vl =  10*wl*(1./(1+exp(-h)));
 %%vr =  10*wr*(1./(1+exp(-h)));
 
 
 
 
end

%%for i=1:60000
%%    for j=1:6
%%        if E(i,j)< bare
%%            bare=E(i,j);
%%       end
%%    end   
%%end
