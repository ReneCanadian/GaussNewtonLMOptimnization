
function [info, tab_val_f, f_val_min, reg_min, time, iterations ,magnitude_difference, calculated_parameters_ret] = lm_RunWithNoiseData(noise_data, init_parameters,t, true_parameters)
    
    [data, Jacobian] = ringdown_func(true_parameters, t);    
    options = optimoptions('lsqcurvefit','SpecifyObjectiveGradient',true,'Algorithm','levenberg-marquardt','FunctionTolerance', 1e-12);
    fun1 = @ringdown_func;

    tic
    [calculated_parameters, resnorm, residual,exitflag,output] = lsqcurvefit(fun1,init_parameters,t,noise_data,[],[]);
    time = toc;

    calculated_parameters_ret= calculated_parameters;
    iterations = output.iterations;
    [true_parameters, calculated_parameters]
    magnitude_difference = abs(norm(true_parameters) - norm(calculated_parameters));

    iterations = output.iterations;
    calculated_parameters_ret= calculated_parameters;
    magnitude_difference = errare(true_parameters',calculated_parameters_ret',2);
    reg_min = 0; %Not sure what it should be as lsqcurvefit does not return this info
    f_val_min = theta(noise_data,lm_func(t,calculated_parameters'));
    if exitflag == 1
        info = 1; %Coverged
    else
        info = 0; %Not Converged
    end
    tab_val_f = 0; %Not sure what it should be as lsqcurvefit does not return this info
    TReg_min = 0; %Not sure what it should be as lsqcurvefit does not return this info
%     figure(1)
%     hold on;
%     plot(t,noise_data);
%     grid on;
%     plot(t,ringdown_func(init_parameters, t));
%     hold on;
%     plot(t,ringdown_func(calculated_parameters, t));
%     grid on;
%     legend('init', 'calculated','true')
end

