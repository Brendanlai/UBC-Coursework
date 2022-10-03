function jacobian = jac(x)
    jacobian = [2*x(1), 4*x(2)^3, 6*x(3)^5;
        -sin(x(1)*x(2)*x(3)^2) - 1, -sin(x(1)*x(2)*x(3)^2) - 1, -2*x(3)*sin(x(1)*x(2)*x(3)^2) - 1;
        -2*(x(1) + x(2) - x(3)), 2*x(2)- 2*(x(1) + x(2) - x(3)), 3*x(3)^2 + 2*(x(1) + x(2) - x(3))];
end
