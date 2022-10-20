format long

nc = 4;
tmax = 10;
gamma = 1;
epsec = 1.0e-5;
r0 = [ [1, 0, 0]; [0, 1, 0]; [0, 0, 1]; (sqrt(3)/3) * [1, 1, 1] ];
level = [10, 11, 12, 13];

[t10, r10, v, v_ec] = charges(r0, tmax, level(1), gamma, epsec);
[~, r11, ~, ~] = charges(r0, tmax, level(2), gamma, epsec);
[~, r12, ~, ~] = charges(r0, tmax, level(3), gamma, epsec);
[~, r13, ~, ~] = charges(r0, tmax, level(4), gamma, epsec);

r10 = squeeze(r10(1,1,:));
r11 = squeeze(r11(1,1,:));
r12 = squeeze(r12(1,1,:));
r13 = squeeze(r13(1,1,:));

x11_2 = r11(1:2:end);
x12_4 = r12(1:4:end);
x13_8 = r13(1:8:end);

dx10 = (x11_2 - r10);
dx11 = (x12_4 - x11_2);
dx12 = (x13_8 - x12_4);

rho = 2;

hold on 
plot(t10, (dx10)', '-r')
plot(t10, (dx11 * rho)', '-g')
plot(t10, (dx12 * rho^2)', '-b')

legend("dx10", "dx11", "dx12");
hold off