function [expe, stdDev] = weighted_mean(tab_ver, weights)

[Rows_params, Cols_sims_no]=size(tab_ver);
[No_weights, dummy] = size(weights); % z funckji quadr_stroud wekt columnowy

if(Cols_sims_no==No_weights)
    expe = zeros(Rows_params, 1);
    outvar = zeros(Rows_params, 1);
    for i=1:Rows_params
        expe(i,1)= tab_ver(i,:)*weights;
        outvar(i,1)= (tab_ver(i,:).*tab_ver(i,:))*weights;
    end
    stdDev = sqrt(outvar - expe.*expe);
else
    expe=0; stdDev=0;
    error('Cols_sims_no!=No_weights');
end

