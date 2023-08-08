%% Create mesh and draw polygon

step = 0.5;

[x, y] = meshgrid(-6:step:4, -0-step:step:7);

figure;
scatter(x, y);
ax = gca;
h = drawpolygon(ax);

%% Return list of coordinates

x_coord = h.Position(:,1);
y_coord = h.Position(:,2);