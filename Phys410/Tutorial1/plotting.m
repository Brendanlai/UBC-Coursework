% 2D plotting 

x = -5/2*pi : 0.1 : 5/2*pi
hold off
hold on
plot(x, sin(x), ":", 'color','r')
plot(x, cos(x), "--", 'color', 'b')
plot(x, sin(2*x).*cos(3*x), 'g')
xlabel('x')
ylabel('function value')
legend('sin(x)', 'cos(x)', 'sin(2x)cos(3x)')
title("Trigonometric functions")
