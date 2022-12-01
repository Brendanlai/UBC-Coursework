format long

tic
tmax = 0.1;
level = 9.0;
lambda = 0.01;
idtype = 1;
idpar = [0.4, 0.075, 20.0];
vtype = 1; % Rectangular Barrier
x1 = 0.8;
x2 = 1.0;

% [x, t, psi, psire, psiim, psimod, prob, v] = sch_1d_cn(tmax, level, lambda, idtype, idpar, vtype, vpar);
lnV0 = linspace(-2, 5, 251);
Fe = zeros(1, 251);
V0 = exp(lnV0);

for i = 1: length(V0)
    vpar = [0.6, 0.8, V0(i)];

    [x, ~, ~, ~, ~, ~, prob, ~] = sch_1d_cn(tmax, level, lambda, idtype, idpar, vtype, vpar);
    % computing temporal average and normalize
    temporal_avg = prob / mean(prob(:,end));
    min_index = round(length(x) * x1);

    p2 = mean(temporal_avg(:,end));
    p1 = mean(temporal_avg(:,min_index));
    
    % Compute excess fractional probability
    Fe(i) = (p2 - p1) / (x2 - x(min_index));
end

plot(lnV0,log(Fe))
xlabel("ln(V_0)")
ylabel("ln(Fe(x_1, x_2))")
title("Barrier Survey")

toc
