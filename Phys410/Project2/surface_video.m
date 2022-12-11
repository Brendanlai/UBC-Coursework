format long

tmax = 0.035;
level = 7;
 
lambda = 0.05; 
idtype = 0;
vtype = 0;
idpar = [2, 3];
vpar = [0];

[x, y, t, psi, psire, psiim, psimod, v] = ...
         sch_2d_adi(tmax, level, lambda, idtype, idpar, vtype, vpar);

% create the video writer with 1 fps
writerObj_exact = VideoWriter('2dsch.avi');
writerObj_exact.FrameRate = 10;

% open the video writer
open(writerObj_exact);

% write the frames to the video
for i=1:length(t)
    % convert the image to a frame
    surf(x, y, real(squeeze(psi(i,:,:))))
    zlim([-1,1])
    writeVideo(writerObj_exact, getframe(gcf));
end