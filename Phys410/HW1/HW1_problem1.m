format long

tol1 = 10^-5;
tol2 = 10^-12;
xint = [0.001, 0.09, 0.15, 0.35, 0.8, 0.95, 1.2, 1.5, 1.86, 1.901, 1.999];

computedRoots = [];

for i = 1: 10
    computedRoots(i)= hybrid(@fx, @dfdx, xint(i), xint(i+1), tol1, tol2);
end
fprintf("The roots from problem1 are:\n");
disp(computedRoots);