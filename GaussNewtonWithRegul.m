%tutorial https://www.youtube.com/watch?v=mWhrMQrTecE&t=1065s
function [out] = GaussNewtonWithRegul(x,y, init_parameters, regul)
%%function [calculated_parameters, iteration_to_conv] = GaussNewtonWithRegul(x,y, init_parameters, regul)
tolerance = 10^-6;
tolerance_fun = 10^-6;
iter_max = 100;
length_input = length(x);
init_parameters = init_parameters';
alp = 1; % dlugosc kroku
iarm=0;
flag_out = 0;
damp=0.25;

value_fval=zeros(1,iter_max+1);
TReg_min=zeros(1,iter_max);                                 % WHY NO +1?
f0 = theta(y,lm_func(x,init_parameters'));
value_fval(1,1)= f0;
%pause

for iter = 1:iter_max
    
    
    flag_out = 0;
    y0 = init_parameters(1);
    A = init_parameters(2);
    tc = init_parameters(3);
    fr = init_parameters(4);
    fi = init_parameters(5);

    for i = 1:length_input
        e=exp(1);
        f(i) = y0 + A *e.^(-tc.*x(i)) .* sin(2*pi*fr.*x(i)+fi);
        j(i,1) = 1;
        j(i,2) = sin(fi + 2*pi*fr*x(i))/e^(x(i)*tc);
        j(i,3) = -(A*x(i)*sin(fi + 2*pi*fr*x(i))*log(e))/e^(x(i)*tc);
        j(i,4) = (2*A*x(i)*pi*cos(fi + 2*pi*fr*x(i)))/e^(x(i)*tc);
        j(i,5) = (A*cos(fi + 2*pi*fr*x(i)))/e^(x(i)*tc);

        d(i) = y(i) - f(i);
    end
    
  
    if regul==0
        delta_a = (j'*j)\(j'*d');
        Reg_min = 0;
    elseif regul==1
        [delta_a, Reg_min, reg_param ] = gn_regul(j,d',regul);
    elseif regul==2
        [delta_a, Reg_min, reg_param ] = gn_regul(j,d',regul);
         %delta_a
         %pause
    elseif regul==3                                        
        [delta_a, Reg_min, reg_param ] = gn_regul(j,d',regul);
    elseif regul==4
        [delta_a, Reg_min, reg_param ] = gn_regul(j,d',regul);
    elseif regul==5
        [delta_a, Reg_min, reg_param ] = gn_regul(j,d',regul);
    else
        error('GN:regul |--> nieobslugiwany tryb regularyzacji<1--5>')
    end;
   
    TReg_min(1,iter) = Reg_min;
    init_parameters_0 = init_parameters;
    init_parameters = init_parameters + damp*alp*delta_a';
    obfun_previous = lm_func(x,init_parameters_0');
    obfun_current = lm_func(x,init_parameters');

    %Checkking if we're heading in the right direction
    f0 = theta(y,obfun_previous);
    f1 = theta(y,obfun_current);
    if (f0>f1) value_fval(1,iter+1) = f1;  end
    
    
    if (value_fval(1,iter) - value_fval(1,iter+1))< tolerance_fun;  flag_out = 1; end;
    
    

	while(f1 >= f0)
		iarm=iarm+1;
		alp=alp/2;
        init_parameters = init_parameters_0 + damp*alp*delta_a';
        obfun_current = lm_func(x,init_parameters');
		f1 = theta(y,obfun_current);
        if (f0>f1) value_fval(1,iter+1) = f1;  end;
  		%pause
        if(iarm > 10) 
            disp(' Armijo error in Gauss-Newton')
            %pause
            init_parameters = init_parameters_0;
            alp = 1;
            flag_out = 1;
            break; 
        end
    end
   
    if (iter==iter_max) flag_out=1; end;


   if((abs(delta_a(1)) < tolerance && abs(delta_a(2)) < tolerance && abs(delta_a(3)) < tolerance && abs(delta_a(4)) < tolerance && abs(delta_a(5)) < tolerance)||flag_out)
    if (flag_out) disp("not converged!"); out.info = 0; end
    if (~flag_out) disp("converged!"); out.info = 1; end
    
    out.iteration_to_conv = iter;
    out.calculated_parameters = init_parameters';
    out.reg_min = Reg_min;
    out.f_val_min = theta(y,lm_func(x,init_parameters'));
    out.tabfv = value_fval;
    out.reg = TReg_min;
    break;
   end
end

end