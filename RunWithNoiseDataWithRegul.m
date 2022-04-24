function [info, tab_val_f, f_val_min, reg_min, time, iterations ,magnitude_difference, calculated_parameters_ret] = RunWithNoiseDataWithRegul(noise_db, init_parameters,t, true_parameters, regul)
%%function [time, iterations ,magnitude_difference, calculated_parameters_ret] = RunWithNoiseDataWithRegul(noise_db, init_parameters,t, true_parameters, regul)

global val
global val2
data = lm_func(t, true_parameters);

noise_data = awgn(data, noise_db, 'measured');
    val = [val; errare(noise_data,data,1)]; %norm(noise_data-data)/norm(data)
    val2 = [val2; errare(noise_data,data,1)];
    tic
    out = GaussNewtonWithRegul(t, noise_data, init_parameters, regul);
    time = toc;
    
    iterations = out.iteration_to_conv;
    calculated_parameters_ret= out.calculated_parameters;
    magnitude_difference = errare(true_parameters',calculated_parameters_ret',2);
    reg_min = out.reg_min;
    f_val_min = out.f_val_min;
    info = out.info;
    tab_val_f=out.tabfv;
    TReg_min = out.reg;
    
    [true_parameters, calculated_parameters_ret]
    %pause

    figure(2)
     hold on;
    plot(t,noise_data);
    grid on;
    plot(t,lm_func(t, init_parameters));
    hold on;
    plot(t,lm_func(t,calculated_parameters_ret));
    grid on;
   
    legend('init', 'calculated','true')
    
    figure(10)
    hold on
    grid on;
    plot(t, ones(size(t))*errare(noise_data,data,1));
    str_val = num2str(val);
    legend(str_val);
    title('norm(noise)')
    
    figure(11)
    semilogy([1:iterations], tab_val_f(1:iterations),'-s');
    hold on
    grid on;
    str_val = num2str(val);
    legend(str_val);
    title('objective function')
    
    figure(12)
    semilogy([1:iterations], TReg_min(1:iterations),'-s');
    hold on
    grid on;
    str_val = num2str(val);
    legend(str_val);
    title('reg_param')
    
    %pause
end
