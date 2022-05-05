clear all
close all
clc


global val
global val2
val = [];
val2 = [];

Npnt = 0.005;	
t = (0.0000:0.0000005:Npnt)';
p_true  = [  0.1   1.84   800   28985  pi/5 ]';
p_init  = [  0   2.1   750   28900  2*pi/5 ]';

% % p_init  = [  1   5   1250   2900  0 ]';

%%zapis_globalny

%%[V_expe_fobj, V_stdDev_fobj]
Tab_mean_expe_fobj = []; % Tab_mean_expe_fobj = [Tab_mean_expe_fobj';V_expe_fobj];
Tab_mean_stdDev_fobj = []; % Tab_mean_stdDev_fobj = [Tab_mean_stdDev_fobj';V_stdDev_fobj]

%%[S_expe_minObj, S_stdDev_minObj]
Vec_expe_minObj = []; %Vec_expe_minObj = [Vec_expe_minObj,S_expe_minObj];
Vec_stdDev_minObj = []; %Vec_stdDev_minObj = [Vec_stdDev_minObj,S_stdDev_minObj];

%%[S_expe_reg_min, S_stdDev_reg_min]
Vec_expe_reg_min = []; %Vec_expe_reg_min = [Vec_expe_reg_min,S_expe_reg_min];
Vec_stdDev_reg_min = []; %Vec_stdDev_reg_min = [Vec_stdDev_reg_min,S_stdDev_reg_min];

%%[S_expe_time, S_stdDev_time]
Vec_expe_time = []; %Vec_expe_time = [Vec_expe_time,S_expe_time];
Vec_stdDev_time = []; % Vec_stdDev_time = [Vec_stdDev_time,S_stdDev_time]
            
%%[S_expe_iter, S_stdDev_iter]
Vec_expe_iter = []; %Vec_expe_iter = [Vec_expe_iter,S_expe_iter];
Vec_stdDev_iter = []; %Vec_stdDev_iter = [Vec_stdDev_iter,S_stdDev_iter];

%%[S_expe_rec_err, S_stdDev_rec_err]
Vec_expe_rec_err = []; %Vec_expe_rec_err = [Vec_expe_rec_err,S_expe_rec_err];
Vec_stdDev_rec_err = []; %Vec_stdDev_rec_err = [Vec_stdDev_rec_err,S_stdDev_rec_err]

%%[V_expe_parms, V_stdDev_parms]
Tab_expe_parms = []; % Tab_expe_parms = [Tab_expe_parms;V_expe_parms'];
Tab_stdDev_parms = []; % Tab_stdDev_parms = [Tab_stdDev_parms;V_stdDev_parms'];

%%[V_expe_err_awgn, V_stdDev_err_awgn]
Tab_expe_err_awgn = []; %Tab_expe_err_awgn = [Tab_expe_err_awgn;V_expe_err_awgn'];
Tab_stdDev_err_awgn = []; %Tab_stdDev_err_awgn = [Tab_stdDev_err_awgn;V_stdDev_err_awgn']

%stroud approximation
rdim = 5;
degree = 1;

flag_stroud = 1; % strou3 10 symulacji na kazdy awgn
% flag_stroud = 2; % strou3 51 symulacji na kazdy awgn (dokladniejsza)

if(flag_stroud==1)
    disp('Stroud3')
    [nodes,weights,bpoly] = quadr_stroud3(rdim,degree);
    nodes = 2.*nodes - 1.;
elseif(flag_stroud==2)
    disp('Stroud5')
    [nodes,weights,bpoly] = quadr_stroud5_1(rdim,degree);
    nodes = 2.*nodes - 1.;
else
    error('flag_stroud==1 or flag_stroud==2')
end

[NoParm,NoSims]=size(nodes);


i=0;


noise_array_db = [6:2:30];
delta = 0.40;

for noise_db = noise_array_db
    
    Tinfo = [];
    Ttab_val_f = [];
    Tf_val_min = [];
    Treg_min = [];
    Ttime = [];
    Titerations =[]; 
    Tmagnitude_difference =[];
    Tcalculated_parameters_ret = [];
    
    %generate data

    [data, jacobian] = ringdown_func(p_true, t); 
    
    
    
%     disp('GN 0')
    regul=2; % najlepiej chyba 2'
    for i =1:NoSims

        %generate noisy data
        noise_data = awgn(data, noise_db, 'measured');
        val = [val; errare(noise_data,data,1)]; %norm(noise_data-data)/norm(data)
        val2 = [val2; errare(noise_data,data,1)];

        p_init(1,1) = p_true(1,1)*(1+delta*nodes(1,i));
        p_init(2,1) = p_true(2,1)*(1+delta*nodes(2,i));
        p_init(3,1) = p_true(3,1)*(1+delta*nodes(3,i));
        p_init(4,1) = p_true(4,1)*(1+delta*nodes(4,i));
        p_init(5,1) = p_true(5,1)*(1+delta*nodes(5,i));

         [info, tab_val_f, f_val_min, reg_min, time, iterations ,magnitude_difference, calculated_parameters_ret]= lm_RunWithNoiseData(noise_data, p_init,t, p_true);

        %[info, tab_val_f, f_val_min, reg_min, time, iterations ,magnitude_difference, calculated_parameters_ret]= gs_RunWithNoiseDataWithRegul(noise_data, data, p_init,t, p_true, regul);

        Tinfo = [Tinfo,info];
        Ttab_val_f = [Ttab_val_f;tab_val_f];
        Tf_val_min = [Tf_val_min,f_val_min];
        Treg_min = [Treg_min,reg_min];
        Ttime = [Ttime,time];
        Titerations =[Titerations,iterations]; 
        Tmagnitude_difference =[Tmagnitude_difference,magnitude_difference];
        Tcalculated_parameters_ret = [Tcalculated_parameters_ret,calculated_parameters_ret];

        
        if i == NoSims
            [V_expe_fobj, V_stdDev_fobj] = weighted_mean_obj(Ttab_val_f, weights);
            [S_expe_minObj, S_stdDev_minObj] = weighted_mean(Tf_val_min, weights);
            [S_expe_reg_min, S_stdDev_reg_min] = weighted_mean(Treg_min, weights);
            [S_expe_time, S_stdDev_time] = weighted_mean(Ttime, weights);
            [S_expe_iter, S_stdDev_iter] = weighted_mean(Titerations, weights);
            [S_expe_rec_err, S_stdDev_rec_err] = weighted_mean(Tmagnitude_difference, weights);
            [V_expe_parms, V_stdDev_parms] = weighted_mean(Tcalculated_parameters_ret, weights);
            [V_expe_err_awgn, V_stdDev_err_awgn] = weighted_mean(val2', weights);
            val2 = [];
            val = [];
            %zapis
            
            Tab_mean_expe_fobj = [Tab_mean_expe_fobj;V_expe_fobj'];
            Tab_mean_stdDev_fobj = [Tab_mean_stdDev_fobj;V_stdDev_fobj'];

            
            Vec_expe_minObj = [Vec_expe_minObj,S_expe_minObj];
            Vec_stdDev_minObj = [Vec_stdDev_minObj,S_stdDev_minObj];

            
            Vec_expe_reg_min = [Vec_expe_reg_min,S_expe_reg_min];
            Vec_stdDev_reg_min = [Vec_stdDev_reg_min,S_stdDev_reg_min];

            
            Vec_expe_time = [Vec_expe_time,S_expe_time];
            Vec_stdDev_time = [Vec_stdDev_time,S_stdDev_time];

            
            Vec_expe_iter = [Vec_expe_iter,S_expe_iter];
            Vec_stdDev_iter = [Vec_stdDev_iter,S_stdDev_iter];

            
            Vec_expe_rec_err = [Vec_expe_rec_err,S_expe_rec_err];
            Vec_stdDev_rec_err = [Vec_stdDev_rec_err,S_stdDev_rec_err];

            
            Tab_expe_parms = [Tab_expe_parms;V_expe_parms'];
            Tab_stdDev_parms = [Tab_stdDev_parms;V_stdDev_parms'];

            
            Tab_expe_err_awgn = [Tab_expe_err_awgn;V_expe_err_awgn'];
            Tab_stdDev_err_awgn = [Tab_stdDev_err_awgn;V_stdDev_err_awgn'];
            
            close all;
        end 
    end
end

% AddPlot(2)

figure(6)
title("mean time of calcualtion in relation to noise")
plot(Tab_expe_err_awgn, Vec_expe_time);
grid on;
xlabel("mean Noise in [%]");
ylabel("mean time [s]");

figure(7)
title("mean współczynnik true and calulated parameters in relation to noise")
plot(Tab_expe_err_awgn, Vec_expe_rec_err);
grid on;
xlabel("mean Noise in [%]");
ylabel("mean Magnitude Difference");

figure(8)
title("mean Number of needed iterations in relation to noise")
plot(Tab_expe_err_awgn, Vec_expe_iter, '-o');
grid on;
xlabel("mean Noise [%]");
ylabel("mean No. of iterations");

figure(9)
semilogy((Tab_mean_expe_fobj)','-s');
grid on;
str_val = num2str(Tab_expe_err_awgn);
legend(str_val);
title('mean objective function')
ylabel("log(f)");
xlabel("mean No. of iterations");

figure(66)
title("mean +/-stdDev time of calcualtion in relation to noise")
errorbar(Tab_expe_err_awgn, Vec_expe_time, Vec_stdDev_time);
grid on;
xlabel("mean Noise in [%]");
ylabel("mean +/-stdDev time [s]");

figure(77)
title("mean +/- stdDEv Magnitude of difference between true and calulated parameters in relation to noise")
errorbar(Tab_expe_err_awgn, Vec_expe_rec_err, Vec_stdDev_rec_err);
grid on;
xlabel("mean Noise in [%]");
ylabel("mean +/- stdDev Magnitude Difference");

figure(88)
title("mean +/- stdDev Number of needed iterations in relation to noise")
errorbar(Tab_expe_err_awgn, Vec_expe_iter, Vec_stdDev_iter );
grid on;
xlabel("mean Noise [%]");
ylabel("mean +/- stdDev No. of iterations");

figure(99)
errorbar((Tab_mean_expe_fobj)',(Tab_mean_stdDev_fobj)')
grid on;
str_val = num2str(Tab_expe_err_awgn);
legend(str_val);
title('mean +/- std.dev objective function')
ylabel("log(f)");
xlabel("mean +/-stdDev No. of iterations");

