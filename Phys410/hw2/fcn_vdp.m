function dxdt = fcn_vdp(t, x)
% fcn_vdp: Derivatives function for the Van Der pol Oscilator 
    global a b omega;

    dxdt = zeros(2,1);
    dxdt(1) = x(2);
    dxdt(2) = -x(1) - a * (x(1)^2 - 1) * x(2) + b * sin(omega * t);
end