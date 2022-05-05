function [data,jacobian] = ringdown_func(p,t)
    %calculate data in function
    e = exp(1);
    y0 = p(1);
    A = p(2);
    tc = p(3);
    fr = p(4);
    fi = p(5);
    data = y0 + A *e.^(-tc.*t).* sin(2*pi*fr.*t+fi);

    %calculate jacobian
    length_input = length(t);
    for i = 1:length_input
        e=exp(1);
        jacobian(i,1) = 1;
        jacobian(i,2) = sin(fi + 2*pi*fr*t(i))/e^(t(i)*tc);
        jacobian(i,3) = -(A*t(i)*sin(fi + 2*pi*fr*t(i))*log(e))/e^(t(i)*tc);
        jacobian(i,4) = (2*A*t(i)*pi*cos(fi + 2*pi*fr*t(i)))/e^(t(i)*tc);
        jacobian(i,5) = (A*cos(fi + 2*pi*fr*t(i)))/e^(t(i)*tc);
    end
end

% LM_FUNC ------------------------------------ 13 Apr 2011, 27 Jun 2011
