function [Vect_popr, Reg_min, reg_param ] = gn_regul(S,b,ster_meth)

       [Us,Ss,Vs] = csvd(S);
       
       if(ster_meth==1)
           [reg_min,G,reg_param] = gcv(Us, Ss, b, 'tsvd');
           [poprawka,rho,eta] = tsvd(Us, Ss, Vs, b, reg_min); 
       elseif(ster_meth==2)
           [reg_min,G,reg_param] = gcv(Us, Ss, b, 'Tikh');
           [poprawka,rho,eta] = tikhonov(Us, Ss, Vs, b, reg_min);
       elseif(ster_meth==3)
           [reg_min,rhoL,Eta,reg_param] =  l_curve(Us, Ss, b, 'Tikh');
           %[reg_min,G,reg_param] = gcv(Us, Ss, b, 'dsvd');
           [poprawka,rho,eta] = dsvd(Us, Ss, Vs, b, reg_min);
       elseif(ster_meth==4)
           [reg_min,rhoL,Eta,reg_param] =  l_curve(Us, Ss, b, 'tsvd');
           [poprawka,rho,eta] = tsvd(Us, Ss, Vs, b, reg_min);
       elseif(ster_meth==5)
           [reg_min,rhoL,Eta,reg_param] =  l_curve(Us, Ss, b, 'Tikh');
           [poprawka,rho,eta] = tikhonov(Us, Ss, Vs, b, reg_min);
% %        elseif(ster_meth==6)
% %            [poprawka,lambda] = discrep(Us,Ss,Vs,b,100,0)
% %            pause
       else
           error('nieobslugiwana technika regularyzacji');
       end;
       
       Vect_popr = real(poprawka);
       Reg_min = reg_min;
end