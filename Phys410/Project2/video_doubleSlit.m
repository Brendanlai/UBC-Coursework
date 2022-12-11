format long
tic
tmax = 0.025;
level = 7;
 
lambda = 0.05; 
idtype = 1;
vtype = 2; 
x0 = 0.5;
y0 = 0.65;
dx = 0.7;
dy = 0.1;
px = 0;
py = -75;

idpar = [x0,y0,dx,dy,px,py];

slitWidth = 0.075;
slitSep = 0.2;

x0 = 0.3;
x1 = x0 + slitWidth;  
x2 = x1 + slitSep;
x3 = x2 + slitWidth;

vpar = [x0, x1, x2, x3, 10^6];

[x, y, t, psi, psire, psiim, psimod, v] = ...
         sch_2d_adi(tmax, level, lambda, idtype, idpar, vtype, vpar);

h = figure;
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'doubleSlit_vid.gif';

for i = 1:length(t)
    contourf(x, y, squeeze(psimod(i,:,:)));
    xlabel("y")
    ylabel("x")
    title("Double Slit Video")
    colorbar

    clim([min(psimod,[],'all'), max(psimod,[],'all')])
    drawnow
    % Capture the plot as an image
    frame = getframe(h);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);

    % Write to the GIF File
    if i == 1
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append');
    end
end
toc 