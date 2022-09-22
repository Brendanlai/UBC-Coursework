% creating a 3D surface plot
[X,Y] = meshgrid(-20:0.5:20)

Z = sin(X) + cos(Y);

surf(X, Y, Z)