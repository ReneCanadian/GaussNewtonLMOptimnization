function  AddPlot(option)

if option == 2
    start = 1;
    stop = 10;
end

figure(6)
title("mean time of calcualtion in relation to noise")
plot(Tab_expe_err_awgn (start:stop), Vec_expe_time (start:stop));
grid on;
xlabel("mean Noise in [%]");
ylabel("mean time [s]");

figure(7)
title("mean Magnitude of difference between true and calulated parameters in relation to noise")
plot(Tab_expe_err_awgn (start:stop), Vec_expe_rec_err (start:stop));
grid on;
xlabel("mean Noise in [%]");
ylabel("mean Magnitude Difference");

figure(8)
title("mean Number of needed iterations in relation to noise")
plot(Tab_expe_err_awgn (start:stop), Vec_expe_iter (start:stop), '-o');
grid on;
xlabel("mean Noise [%]");
ylabel("mean No. of iterations");

figure(9)
semilogy((Tab_mean_expe_fobj (start:stop))','-s');
grid on;
str_val = num2str(Tab_expe_err_awgn (start:stop));
legend(str_val);
title('mean objective function')
ylabel("log(f)");
xlabel("mean No. of iterations");

figure(66)
title("mean +/-stdDev time of calcualtion in relation to noise")
errorbar(Tab_expe_err_awgn (start:stop), Vec_expe_time (start:stop), Vec_stdDev_time (start:stop));
grid on;
xlabel("mean Noise in [%]");
ylabel("mean +/-stdDev time [s]");

figure(77)
title("mean +/- stdDEv Magnitude of difference between true and calulated parameters in relation to noise")
errorbar(Tab_expe_err_awgn (start:stop), Vec_expe_rec_err (start:stop), Vec_stdDev_rec_err (start:stop));
grid on;
xlabel("mean Noise in [%]");
ylabel("mean +/- stdDev Magnitude Difference");

figure(88)
title("mean +/- stdDev Number of needed iterations in relation to noise")
errorbar(Tab_expe_err_awgn (start:stop), Vec_expe_iter (start:stop), Vec_stdDev_iter (start:stop) );
grid on;
xlabel("mean Noise [%]");
ylabel("mean +/- stdDev No. of iterations");

figure(99)
errorbar((Tab_mean_expe_fobj (start:stop))',(Tab_mean_stdDev_fobj (start:stop))')
grid on;
str_val = num2str(Tab_expe_err_awgn (start:stop));
legend(str_val);
title('mean +/- std.dev objective function')
ylabel("log(f)");
xlabel("mean +/-stdDev No. of iterations");
end