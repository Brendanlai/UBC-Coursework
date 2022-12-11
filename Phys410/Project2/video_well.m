format long
tic
tmax = 0.035;
level = 7;
 
lambda = 0.05; 
idtype = 1;
vtype = 1;
x0 = 0.5;
y0 = 0.5;
dx = 0.1;
dy = 0.1;
px = 0;
py = 0;

idpar = [x0,y0,dx,dy,px,py];

xmin = 0.2;
xmax = 0.7;
ymin = 0.2;
ymax = 0.7;
vpar = [xmin, xmax, ymin, ymax, -10^3];

[x, y, t, psi, psire, psiim, psimod, v] = ...
         sch_2d_adi(tmax, level, lambda, idtype, idpar, vtype, vpar);

h = figure;
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'wellVideo.gif';

for i = 1:length(t)
    contourf(x, y, squeeze(psimod(i,:,:)));
    xlabel("y")
    ylabel("x")
    title("Well - Inside Well, V_c = -10^3")
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