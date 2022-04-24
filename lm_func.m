function y_hat = lm_func(t,p,c)
      e = exp(1);
      y0 = p(1);
      A = p(2);
      tc = p(3);
      fr = p(4);
      fi = p(5);
    y_hat = y0 + A *e.^(-tc.*t) .* sin(2*pi*fr.*t+fi);
end

% LM_FUNC ------------------------------------ 13 Apr 2011, 27 Jun 2011
