format long

x0 = [-1.00, 0.75, 1.50];
tol = 10^-12;
p2_result = newtond(@fx2, @jacobian, x0, tol);
fprintf("The result for problem 2 is:\n");
disp(p2_result);