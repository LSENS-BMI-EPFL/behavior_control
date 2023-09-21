function [x_coord,y_coord] = get_stim_grid(grid_type, AP, ML)
%GET_STIM_GRID Summary of this function goes here
%   Detailed explanation goes here
    arguments
        grid_type = 'No Grid';
        AP = 0;
        ML = 0;
    end
    warning('off', 'all');

    switch grid_type
        case 'No Grid'
            x_coord = AP;
            y_coord = ML;

        case 'Grid 1'
            x_range = [4.5,4.5,4.25,4,3.75,3.5,3.25,3,0.25,0.25,0.25,0,0,0.25,0.25,4.5];
            y_range = [0,1.5,1.75,2,2.25,2.5,2.75,3,3,2.5,2.25,2.25,0.75,0.75,0,0];
            step = 0.5;
            scale = step/.25;
            [x, y] = meshgrid(-6:step:4, -1:step:7);
            brain_mask = poly2mask(scale/step*x_range+2,scale/step*y_range+3, length(-1:step:7), length(-6:step:4));
            x(~brain_mask) = nan;
            y(~brain_mask) = nan;
%             figure; scatter(x,y); hold on; plot(scale*x_range-5, scale*y_range+0.5)
            x_coord = reshape(x(~isnan(x)), 1,[]);
            y_coord = reshape(y(~isnan(y)), 1,[]);

        case 'Grid 2'
            step = 0.75;
            scale = step/.25;
            [x, y] = meshgrid(-6:step:4, 0-step:step:7);
            x_range = [0, 1.2, 1.2, 1.9, 1.9, 2.7, 2.7, 3.4, 3.4, 4, 4, -5, -5, -5.75, -5.75, -5, -5]+6;
            y_range = [6.75, 6.75, 5.75, 5.75, 4.9, 4.9, 4.2, 4.2, 3.3, 3.3, 0.4, 0.4, 1.8, 1.8, 4.9, 4.9, 6.75]+1;
            brain_mask = poly2mask(1.2*x_range,1.2*y_range,length(-1:step:7), length(-6:step:4));
            x(~brain_mask) = nan;
            y(~brain_mask) = nan;

%             figure; scatter(x+1.5,y+0.75); hold on; plot(x_range-6, y_range-1)
            x_coord = reshape(x(~isnan(x))+1.5, 1,[]);
            y_coord = reshape(y(~isnan(y))+0.75, 1,[]);

    end

end

