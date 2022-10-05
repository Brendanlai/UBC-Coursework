format long

tol1 = 10^-5;
tol2 = 10^-12;
xint = [0.001, 0.09, 0.15, 0.35, 0.8, 0.95, 1.2, 1.5, 1.86, 1.901, 1.999];

f = @(x) 512*x^10 - 5120*x^9 + 21760*x^8 - 51200*x^7 + 72800*x^6 - 64064*x^5 + 34320*x^4 - 10560*x^3 + 1650*x^2 - 100*x + 1;
dfdx = @(x) 5120*x^9 - 46080*x^8 + 174080*x^7 - 358400*x^6 + 436800*x^5 - 320320*x^4 + 137280*x^3 - 31680*x^2 + 3300*x - 100;

computedRoots = [];

for i = 1: 10
    computedRoots(i)= hybrid(f, dfdx, xint(i), xint(i+1), tol1, tol2);
end
fprintf("The roots from problem1 are:\n");
disp(computedRoots);