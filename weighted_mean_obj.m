function [expe, stdDev] = weighted_mean_obj(tab_ver, weights)

[Rows_sims_no, Cols]=size(tab_ver);
[No_weights, dummy] = size(weights); % z funckji quadr_stroud wekt columnowy

if(Rows_sims_no==No_weights)
    expe = zeros(Cols, 1);
    outvar = zeros(Cols, 1);
    for i=1:Cols
        expe(i,1)= tab_ver(:,i)'*weights;
        outvar(i,1)= ((tab_ver(:,i).*tab_ver(:,i))')*weights;
    end
    stdDev = sqrt(outvar - expe.*expe);
else
    expe=0; stdDev=0;
    error('Cols_sims_no!=No_weights');
end

