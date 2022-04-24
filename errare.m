function err = errare(p_true, p_rec, flag_err)

[r1,c1]=size(p_true);
[r2,c2]=size(p_rec);

if (and((r1==r2),(c1==c2)))
    
    if(flag_err==1)
        % ten blad zastosowalbym do oceny awgn w [%]
        err = 100*(norm(p_true-p_rec,2))^2/(norm(p_true,2))^2;
        res_mean_ptrue = mean(p_true)-p_true;
        %Wspó³czynnik determinacji <0,1> gdy m. n kwadratow [%]
        err = 100*(norm(p_true-p_rec,2))^2/(norm(res_mean_ptrue,2))^2;
    elseif(flag_err==2)
        %res_mean_ptrue = mean(p_true)-p_true;
        %Wspó³czynnik determinacji <0,1> gdy m. n kwadratow [%]
        % tak naprawde err^2
        %err = 100*(norm(p_true-p_rec,2))^2/(norm(res_mean_ptrue,2))^2;
        %err = 100*(norm(p_true-p_rec,2))^2/(norm(p_true,2))^2;
        err = mean(100*abs(p_true-p_rec)./p_true);
    else
        disp('1 lub 2')
    end
    
else
    error('(r1!=r2) or (c1!=c2)')
end