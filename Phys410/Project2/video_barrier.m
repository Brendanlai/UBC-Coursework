format long
tic
tmax = 0.035;
level = 7;
 
lambda = 0.05; 
idtype = 1;
vtype = 1;
x0 = 0.2;
y0 = 0.2;
dx = 0.5;
dy = 0.05;
px = 10;
py = 50;

idpar = [x0,y0,dx,dy,px,py];

xmin = 0.2;
xmax = 0.7;
ymin = 0.5;
ymax = 0.6;
vpar = [xmin, xmax, ymin, ymax, 10^5];

[x, y, t, psi, psire, psiim, psimod, v] = ...
         sch_2d_adi(tmax, level, lambda, idtype, idpar, vtype, vpar);

% figure(1)
% hold on
% contourf(x, y, v);
% title("Contour of the double slit implementation")
% hold off


h = figure;
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'rectangularBarrierVideo.gif';

for i = 1:length(t)
    contourf(x, y, squeeze(psimod(i,:,:)));
    xlabel("y")
    ylabel("x")
    title("Rectangular Barrier Video")
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