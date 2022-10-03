format long

tol1 = 10^-4
tol2 = 10^-12
xint = [0.001, 0.09, 0.15, 0.35, 0.82, 095, 1.2, 1.5, 1.86, 1.901, 1.999];

f = @(x) 512*x^10 - 5120*x^9 + 21760*x^8 - 51200*x^7 + 72800*x^6 - 64064*x^5 + 34320*x^4 - 10560*x^3 + 1650*x^2 - 100*x + 1;
dfdx = @(x) 5120*x^9 - 46080*x^8 + 174080*x^7 - 358400*x^6 + 436800*x^5 - 320320*x^4 + 137280*x^3 - 31680*x^2 + 3300*x - 100;

% root1 = hybrid(f, dfdx, xint1(1), xint1(2), tol1, tol2)
% root2 = hybrid(f, dfdx, xint2(1), xint2(2), tol1, tol2)
% root3 = hybrid(f, dfdx, xint3(1), xint3(2), tol1, tol2)
% root4 = hybrid(f, dfdx, xint4(1), xint4(2), tol1, tol2)
% root5 = hybrid(f, dfdx, xint5(1), xint5(2), tol1, tol2)
% root6 = hybrid(f, dfdx, xint6(1), xint6(2), tol1, tol2)
% root7 = hybrid(f, dfdx, xint7(1), xint7(2), tol1, tol2)
% root8 = hybrid(f, dfdx, xint8(1), xint8(2), tol1, tol2)
% root9 = hybrid(f, dfdx, xint9(1), xint9(2), tol1, tol2)
% root10 = hybrid(f, dfdx, xint10(1), xint10(2), tol1, tol2)

coefs = [512, -5120, 21760, -51200, 72800, -64064, 34320, -10560, 1650, -100, 1];
actualroots = sort(roots(coefs))

computedRoots = []
iters = []
errs = []
for i = 1: 10
    [computedRoots(i), iters(i), errs(i)] = hybrid(f, dfdx, xint(i), xint(i+1), tol1, tol2, actualroots(i))
end

disp(iters)
abs(computedRoots' - actualroots) < 10^-12
abs(computedRoots' - actualroots)

% for i = 1:10
%     f(computedRoots(i))
% end
