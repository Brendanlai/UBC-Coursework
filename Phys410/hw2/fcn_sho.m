function dydt = fcn_sho(t, y)
% fcn_sho: Derivatives function for simple harmonic motion with unit
% frequency
    dydt = zeros(2,1);
    dydt(1) = y(2);
    dydt(2) = -y(1);
end