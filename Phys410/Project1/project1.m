format long
tic
nc = 54;
tmax = 10000;
level = 15;
gamma = 1;
epsec = 10^-5;

r0 = 2 * rand(nc,3) - 1;

for i = 1: nc
    vec = r0(i, :);
    r0(i, :) = vec / norm(vec);
end

[t, r, v, v_ec] = charges(r0, tmax, level, gamma, epsec);

% v7_wiki = 14.452977414;
% v11_wiki = 40.596450510;
% v19_wiki = 135.089467557;
% v21_wiki = 167.641622399;
% v25_wiki = 243.812760299;
% v36_wiki = 529.122408375
% abs(v(end) - v36_wiki)
% v44_wiki = 807.174263085;
v54_wiki = 1239.361474729;
% checks = [];
v(end)
abs(v(end) - v54_wiki)

% for i = 1:1
%     [t, r, v, v_ec] = charges(r0, tmax, level, gamma, epsec);
%     checks(i) = 10^-9 > abs(v44_wiki - v(end));
% end
% checks
% v(end)
% abs(v(end) - v44_wiki)
% abs(v(end) -  v19_wiki)

% fprintf("equivalenc class vector")
% disp(v_ec)
% charges_plot(t,r, 0)
toc
