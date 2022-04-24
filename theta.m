function out = theta(ys,ym)
  
  c1 = length(ys);
  c2 = length(ym);
  
  if (c1==c2)
    y = (ys-ym)'*(ys-ym)/c1; % zakladam ze wierszowe wektory 
  else
    y = 0; 
    error("STOP: c1!=c2!!!" );
  end
  out = y;
end
