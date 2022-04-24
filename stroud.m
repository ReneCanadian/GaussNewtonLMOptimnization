function nodes = stroud(p)
% Stroud-3 method
% 
% Input parameters:
%   p   number of dimensions
%
% Output parameters:
%   nodes   nodes of quadrature rule in [0,1]^p (column-wise)
%

nodes = zeros(p,2*p);

coeff = pi/p;

fac = sqrt(2/3);

for i = 1:(2*p)

   for r = 1:floor(0.5*p)

      k = 2*r - 1;

      nodes(k,i) = fac*cos(k*i*coeff);

      nodes(k+1,i) = fac*sin(k*i*coeff);

   end

   if ((0.5*p)~=floor(0.5*p))
      nodes(end,i) = ((-1)^i)/sqrt(3);
   end

end

% transform nodes from [-1,+1]^p to [0,1]^p 
nodes = 0.5*nodes + 0.5;

return
end
