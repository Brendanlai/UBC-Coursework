format long

convTest1 = true; % set to true or false depending on which test case

% Set up parameters for convergence test 1
idtype = 0;
vtype = 0;
vpar = 0;
idpar = 3;
tmax = 0.25;
lambda = 0.1;
m = idpar;

% If it's case 2 then adjust parameters to match accordingly
if not(convTest1)
    idtype = 1;
    vtype = 0;
    idpar = [0.5, 0.075, 0.0];
    tmax = 0.01;
    lambda = 0.01;
end

% Compute the four levels
[x6, t6, psi6, ~, ~, ~, ~, ~] = sch_1d_cn(tmax, 6, lambda, idtype, idpar, vtype, vpar);
[~, ~, psi7, ~, ~, ~, ~, ~] = sch_1d_cn(tmax, 7, lambda, idtype, idpar, vtype, vpar);
[~, ~, psi8, ~, ~, ~, ~, ~] = sch_1d_cn(tmax, 8, lambda, idtype, idpar, vtype, vpar);
[~, ~, psi9, ~, ~, ~, ~, ~] = sch_1d_cn(tmax, 9, lambda, idtype, idpar, vtype, vpar);

% Extract the corresponding values to the lowest level
psi7_l6 = psi7(1:2:end, 1:2:end);
psi8_l6 = psi8(1:4:end, 1:4:end);
psi9_l6 = psi9(1:8:end, 1:8:end);

% Calculate dpsi for each level difference
dpsi_1 = psi7_l6 - psi6;
dpsi_2 = psi8_l6 - psi7_l6;
dpsi_3 = psi9_l6 - psi8_l6;

% Compute l2 norm
l2norm_psi_1 = vecnorm(dpsi_1,2,2)/sqrt(length(x6));
l2norm_psi_2 = vecnorm(dpsi_2,2,2)/sqrt(length(x6));
l2norm_psi_3 = vecnorm(dpsi_3,2,2)/sqrt(length(x6));

% dPsi plots
figure(1)
hold on
xlabel("Time")
ylabel("Scaled Error")
title("4-Level Convergence Test, Level to Level Error Analysis")

plot(t6, l2norm_psi_1)
plot(t6, l2norm_psi_2 * 4)
plot(t6, l2norm_psi_3 * 4^2)

% if convTest1 plot exact solutions
if convTest1
    exact_psi = dim1_exact_soln(m, x6, t6);
    
    dpsi_1_exact = exact_psi - psi7_l6;
    dpsi_2_exact = exact_psi - psi8_l6;
    dpsi_3_exact = exact_psi - psi9_l6;
    
    l2norm_psi_1_exact = vecnorm(dpsi_1_exact,2,2)/sqrt(length(x6));
    l2norm_psi_2_exact = vecnorm(dpsi_2_exact,2,2)/sqrt(length(x6));
    l2norm_psi_3_exact = vecnorm(dpsi_3_exact,2,2)/sqrt(length(x6));
    
    figure(2)
    hold on
    xlabel("Time")
    ylabel("Scaled Error")
    title("4-Level Convergence Test, Exact Solution Analysis")
    plot(t6, real(l2norm_psi_1_exact))
    plot(t6, real(l2norm_psi_2_exact) * 4)
    plot(t6, real(l2norm_psi_3_exact) * 4^2)
end
% for l = l_min : l_max