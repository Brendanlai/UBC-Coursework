format long

% Set up parameters for convergence test 1
idtype = 0;
vtype = 0;
vpar = 0;
idpar = [2,3];
tmax = 0.05;
lambda = 0.05;

mx = idpar(1);
my = idpar(2);
levels = [6,7,8,9];

% Compute the four levels
[x6, y6, t6, psi6, ~, ~, ~, ~] = sch_2d_adi(tmax, levels(1), lambda, idtype, idpar, vtype, vpar);
[~, ~, ~, psi7, ~, ~, ~, ~] = sch_2d_adi(tmax, levels(2), lambda, idtype, idpar, vtype, vpar);
[~, ~, ~, psi8, ~, ~, ~, ~] = sch_2d_adi(tmax, levels(3), lambda, idtype, idpar, vtype, vpar);
[~, ~, ~, psi9, ~, ~, ~, ~] = sch_2d_adi(tmax, levels(4), lambda, idtype, idpar, vtype, vpar);

% Extract the corresponding values to the lowest level
psi7_l6 = psi7(1:2:end, 1:2:end, 1:2:end);
psi8_l6 = psi8(1:4:end, 1:4:end, 1:4:end);
psi9_l6 = psi9(1:8:end, 1:8:end, 1:8:end);

% Calculate dpsi for each level difference

dpsi_1 = psi7_l6 - psi6;
dpsi_2 = psi8_l6 - psi7_l6;
dpsi_3 = psi9_l6 - psi8_l6;

% Compute l2 norm
dpsi1_vec = reshape(dpsi_1, [length(t6), length(x6)*length(y6)])';
dpsi2_vec = reshape(dpsi_2, [length(t6), length(x6)*length(y6)])';
dpsi3_vec = reshape(dpsi_3, [length(t6), length(x6)*length(y6)])';

l2norm_psi_1 = vecnorm(dpsi1_vec, 2, 1) / sqrt(length(x6)^2);
l2norm_psi_2 = vecnorm(dpsi2_vec, 2, 1) / sqrt(length(x6)^2);
l2norm_psi_3 = vecnorm(dpsi3_vec, 2, 1) / sqrt(length(x6)^2);

% dPsi plots
figure(1)
hold on
xlabel("Time")
ylabel("Scaled Error")
title("4-Level Convergence Test, Level to Level Analysis - 2D ADI Soln")

plot(t6, l2norm_psi_1)
plot(t6, l2norm_psi_2 * 4)
plot(t6, l2norm_psi_3 * 4^2)

% %Exact solutions convergence test
exact_psi = zeros(length(t6),length(x6),length(y6));

for n = 1:length(t6)
    exact_psi(n, :, :) = exp(-1i*(mx^2+my^2)*pi^2*t6(n))*sin(mx*pi*x6)'*sin(my*pi*y6);
end

dpsi_1_exact = exact_psi - psi7_l6;
dpsi_2_exact = exact_psi - psi8_l6;
dpsi_3_exact = exact_psi - psi9_l6;

% Compute norms for exact soln
dpsi1_vec_exact = reshape(dpsi_1_exact, [length(t6), length(x6)*length(y6)])';
dpsi2_vec_exact = reshape(dpsi_2_exact, [length(t6), length(x6)*length(y6)])';
dpsi3_vec_exact = reshape(dpsi_3_exact, [length(t6), length(x6)*length(y6)])';

l2norm_psi_1_exact = vecnorm(dpsi1_vec_exact, 2, 1) / sqrt(length(x6)^2);
l2norm_psi_2_exact = vecnorm(dpsi2_vec_exact, 2, 1) / sqrt(length(x6)^2);
l2norm_psi_3_exact = vecnorm(dpsi3_vec_exact, 2, 1) / sqrt(length(x6)^2);

% Plot convergence test for exact solution analysis
figure(2)
hold on
xlabel("Time")
ylabel("Scaled Error")
title("4-Level Convergence Test, Exact Solution Analysis - 2D  ADI Soln")
plot(t6, l2norm_psi_1_exact)
plot(t6, l2norm_psi_2_exact * 4)
plot(t6, l2norm_psi_3_exact * 4^2)
