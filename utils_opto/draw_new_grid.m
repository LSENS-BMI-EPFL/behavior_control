%% Create mesh and draw polygon
function [x_coord, y_coord] = draw_new_grid(step)

%%% Function to extract coordinates to generate new grids with a user
%%% interface.

arguments
    step = 0.5; % Space between points in mm
end

[x, y] = meshgrid(-6:step:4, -0-step:step:7); % minimum and maximum ranges to access all left hemisphere

figure;
scatter(x, y);
ax = gca;
h = drawpolygon(ax);

%% Return list of coordinates

x_coord = h.Position(:,1);
y_coord = h.Position(:,2);

end