function [nodes,weights,bpoly] = quadr_stroud5_1(rdim,degree)
% data for Stroud-5 quadrature in [0,1]^rdim

% nodes and weights
[o,nodestr,weights] = cn_leg_05_1(rdim,1);
nodes = 0.5*nodestr + 0.5;
weights = weights/(2^rdim);
[dummy,nnodes] = size(nodes);

% evaluation of Legendre polynomials
bpoly = zeros(degree+1,rdim,nnodes);
for l = 1:rdim
   for j = 1:nnodes
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
