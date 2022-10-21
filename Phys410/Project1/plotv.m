format long

% Initialize parameters
nc = 12;
tmax = 10;
level = 12;
gamma = 1;
epsec = 1.0e-5;
r0 = 2 * rand(nc,3) - 1;

% Normalize r0
for i = 1: nc
    r0(i, :) = r0(i, :) / norm(r0(i, :));
end

[t, r, v, v_ec] = charges(r0, tmax, level, gamma, epsec);


% Create plot
plot(t,v,'-r')     
title('Time evolution of potential for 12-charge calculation')
xlabel('Time (t)') 
ylabel('Potential (V)')