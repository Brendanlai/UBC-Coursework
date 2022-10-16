nc = 2;
tmax = 100;
level = 8;
gamma = 1;
epsec = 10^-5;

r0 = 2 * rand(nc,3) - 1;

% disp(r0(1,:))
% l = r0(1,:);
% disp(l)
% Normalize r0

for i = 1: nc
    vec = r0(i, :);
    r0(i, :) = vec / sqrt(vec(1)^2 + vec(2)^2 + vec(3)^2);
end

[t, r, v, v_ec] = charges(r0, tmax, level, gamma, epsec);

fprintf("Potential Vector:")
disp(v)

charges_plot(t,r, 0)
