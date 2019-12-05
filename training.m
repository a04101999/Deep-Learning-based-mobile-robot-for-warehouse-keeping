%% neural controller for obstacle avoidance *((1./(1+exp(-h)))')
clc; clear all; close all;
s = [ 5; 10 ;15; 20; 25; 31; 34; 40; 42; 43; 47; 50; 55; 58; 65; 70; 75; 79; 81; 82; 85; 90; 95; 100; 104; 105; 109; 115; 128; 131; 150; 160; 165; 170; 175; 180; 185; 190; 195; 200; 201; 202; 210; 220; 250; 260; 280; 300; 400; 600; 1000 ]; 
vld=[47; 47; 47; 47; 47; 47; 47; 48; 48; 49; 55; 40; 48; 96; 49; 55; 60; 48; 96; 96; 96; 96; 96; 96;  47;  47;  95;  95;  95;  95;  95;  95;  95; 95;    95;  95;  95;  95;  95;  95;  47;  47; 47;   47;  47;  47;  47;  47;  47;  47 ; 47  ];
vrd=[0;  0;   0;  0;  0;  0;  0; 48; 48; 49; 55; 96; 96; 96; 49; 55; 60; 48; 96; 48; 48; 48; 48 ;48;  95;  47;  95;  95;  95;  95;  95;  95;  95;  95;  95;  95;  95;  95;  95;   95;   0;   0 ;  0;   0 ;  0 ;  0 ;  0 ;   0;   0 ;  0 ;  0 ];
b= 1;
eta=2;

  W = rand(10,1);
W_b = rand(10,1);
W_l =rand(1,10);
W_r =rand(1,10);

E =ones(1,60000);

for i=1:60000
 for j=1:50
    %%feed forward
     h1=s(j)*W + W_b(j);
     
     v_a = 1/(1+exp(-h1));
     
     h_l = W_l*v_a';
     h_r = W_r*v_a';
     
     vl = 1./(1+ exp(-h_l));
     vr = 1./(1+ exp(-h_r));
     
   
     
    El = 0.5*(vld(j)-vl)^2;
    Er = 0.5*(vrd(j)-vl)^2;
    
    %%back propogation
  del_Bl = vl*(1-vl)*(vld(j) - vl);
  del_Br = vr*(1-vr)*(vrd(j) - vr);
    W_lnew = W_l + eta*(vld(j)-vl)*vl'; 
     W_rnew = W_r + eta*(vrd(j)-vr)*vr';
     
     del_A = v_a*(1 -v_a)'*[W_l.*del_Bl ; W_r.*del_Bl];
      Wnew  = W+ (eta*del_A*s(j))';
       W_bnew= W_b+ eta*del_A'*b; 
   
      %%input for bias is 1
      
       W_l = W_lnew;
       W_r = W_rnew;
       W  = Wnew;
       b  = W_bnew;
      
    E_itr(j) =max(E);         
             if E(j) <.0001
                 break;
             end
 end 
end 

%%result
i;
j;
E(i);
%%plot(E);

for i=1:50
 
 h1=W*s(i) + W_b;
 v_l = W_l*(1./(1+exp(-h1)));
 v_r = W_r*(1./(1+exp(-h1)));
 
end
 
%%results
v_l
v_r
 W
 W_l
 W_r
 W_b
