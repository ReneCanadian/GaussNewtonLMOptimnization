function [nodes,weights,bpoly] = quadr_stroud3(rdim,degree)
% data for Stroud-3 quadrature in [0,1]^k

% nodes and weights
nodes = stroud(rdim);
nodestr = 2.*nodes - 1.;
weights = (1/(2*rdim))*ones(2*rdim,1);

% evaluation of Legendre polynomials
bpoly = zeros(degree+1,rdim,2*rdim);
for l = 1:rdim
   for j = 1:(2*rdim)
      bpoly(1,l,j) = 1.;
      bpoly(2,l,j) = nodestr(l,j);
      for i = 2:degree
         bpoly(i+1,l,j) = ...
            ((2*i-1)*nodestr(l,j)*bpoly(i,l,j)-(i-1)*bpoly(i-1,l,j))/i;
      end
   end
end

% standardisation of Legendre polynomials
for i = 2:(degree+1)
   bpoly(i,:,:) = bpoly(i,:,:)*sqrt(2*i-1);
end

return
end
