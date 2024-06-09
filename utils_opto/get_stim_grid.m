function [x_coord,y_coord] = get_stim_grid(grid_type, AP, ML)
%GET_STIM_GRID Return list of coordinates (from bregma) to stimulate.
%   List constructed from draw_new_grid function and accounting for the
%   desired density by the step parameter in draw_new_grid.

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

        case 'Grid 1' % Potentially change grid names to more interpretable
            x_range = [4.5,4.5,4.25,4,3.75,3.5,3.25,3,0.25,0.25,0.25,0,0,0.25,0.25,4.5];
            y_range = [0,1.5,1.75,2,2.25,2.5,2.75,3,3,2.5,2.25,2.25,0.75,0.75,0,0];
            step = 0.5; % Space between points in mm
            scale = step/.25;
            [x, y] = meshgrid(-6:step:4, -1:step:7);

            brain_mask = poly2mask(scale/step*x_range+2,scale/step*y_range+3, length(-1:step:7), length(-6:step:4));
            x(~brain_mask) = nan;
            y(~brain_mask) = nan;
%             figure; scatter(x,y); hold on; plot(scale*x_range-5, scale*y_range+0.5)
            x_coord = reshape(x(~isnan(x)), 1,[]);
            y_coord = reshape(y(~isnan(y)), 1,[]);

        case 'Grid 2'
            x_range = [0, 1.2, 1.2, 1.9, 1.9, 2.7, 2.7, 3.4, 3.4, 4, 4, -5, -5, -5.75, -5.75, -5, -5]+6;
            y_range = [6.75, 6.75, 5.75, 5.75, 4.9, 4.9, 4.2, 4.2, 3.3, 3.3, 0.4, 0.4, 1.8, 1.8, 4.9, 4.9, 6.75]+1;
            step = 0.75; % Space between points in mm
            scale = step/.25;
            [x, y] = meshgrid(-6:step:4, 0-step:step:7);

            brain_mask = poly2mask(1.2*x_range,1.2*y_range,length(-1:step:7), length(-6:step:4));
            x(~brain_mask) = nan;
            y(~brain_mask) = nan;
%             figure; scatter(x+1.5,y+0.75); hold on; plot(x_range-6, y_range-1)
            x_coord = reshape(x(~isnan(x))+1.5, 1,[]);
            y_coord = reshape(y(~isnan(y))+0.75, 1,[]);

        case 'Grid 3'
            x_range = [0, -2.75, -2.75, 2, 2, 2.5, 2.5, 3.25, 3.25, 4, 4]+6;
            y_range = [0.5, 0.5, 5.75, 5.75, 5, 5, 4, 4, 3.25, 3.25, 0.5]+1;
            step = 0.75; % Space between points in mm
            scale = step/.25;
            [x, y] = meshgrid(-6:step:4, 0-step:step:7);

            brain_mask = poly2mask(1.2*x_range, 1.2*y_range, length(-1:step:7), length(-6:step:4));
            x(~brain_mask) = nan;
            y(~brain_mask) = nan;
%             figure; scatter(x+1.5,y+0.75); hold on; plot(x_range-6, y_range-1)
            x_coord = reshape(x(~isnan(x))+1.5, 1,[]);
            y_coord = reshape(y(~isnan(y))+0.75, 1,[]);

        case 'Grid 4'
            x_range = [-4.5; 3.5; 3.5; 2.5; 2.5; 1.5; 1.5; -4.5; -4.5]+6;
            y_range = [0.5; 0.5; 4.5; 4.5; 5.5; 5.5; 6.5; 6.5; 0.5];
            step = 1;
            scale = step/.25;
            [x, y] = meshgrid(-6.5:step:5.5, 0.5-step:step:6);
            brain_mask = poly2mask(x_range, y_range, length(-1:step:5), length(-6:step:6));
            x(~brain_mask) = nan;
            y(~brain_mask) = nan;
            figure; scatter(x+2,y+1); hold on; plot(x_range-6, y_range)
            x_coord = reshape(x(~isnan(x))+2, 1,[]);
            y_coord = reshape(y(~isnan(y))+1, 1,[]);
        
        case '1mm optogrid perm 1'
            x_range = [-4.5; 3.5; 3.5; 2.5; 2.5; 1.5; 1.5; -4.5; -4.5]+6;
            y_range = [0.5; 0.5; 4.5; 4.5; 5.5; 5.5; 6.5; 6.5; 0.5];
            step = 1;
            scale = step/.25;
            [x, y] = meshgrid(-6.5:step:5.5, 0.5-step:step:6);
            brain_mask = poly2mask(x_range, y_range, length(-1:step:5), length(-6:step:6));
            x(~brain_mask) = nan;
            y(~brain_mask) = nan;
%             figure; scatter(x+2,y+1); hold on; plot(x_range-6, y_range)
            x_coord = reshape(x(~isnan(x))+2, 1,[]);
            y_coord = reshape(y(~isnan(y))+1, 1,[]);
            indices = [32,24,42,35,6,34,16,37,30,25,8,44,1,39,17,15,10,9,38,45,13,4,22,18,3,12,14,23,28,21,26,43,33,11,20,31,7,41,40,36,29,19,5,27,2];
            y_coord = y_coord(indices(1:15));
            x_coord = x_coord(indices(1:15));

        case '1mm optogrid perm 2'
            x_range = [-4.5; 3.5; 3.5; 2.5; 2.5; 1.5; 1.5; -4.5; -4.5]+6;
            y_range = [0.5; 0.5; 4.5; 4.5; 5.5; 5.5; 6.5; 6.5; 0.5];
            step = 1;
            scale = step/.25;
            [x, y] = meshgrid(-6.5:step:5.5, 0.5-step:step:6);
            brain_mask = poly2mask(x_range, y_range, length(-1:step:5), length(-6:step:6));
            x(~brain_mask) = nan;
            y(~brain_mask) = nan;
%             figure; scatter(x+2,y+1); hold on; plot(x_range-6, y_range)
            x_coord = reshape(x(~isnan(x))+2, 1,[]);
            y_coord = reshape(y(~isnan(y))+1, 1,[]);
            indices = [32,24,42,35,6,34,16,37,30,25,8,44,1,39,17,15,10,9,38,45,13,4,22,18,3,12,14,23,28,21,26,43,33,11,20,31,7,41,40,36,29,19,5,27,2];
            y_coord = y_coord(indices(15:30));
            x_coord = x_coord(indices(15:30));

        case '1mm optogrid perm 3'
            x_range = [-4.5; 3.5; 3.5; 2.5; 2.5; 1.5; 1.5; -4.5; -4.5]+6;
            y_range = [0.5; 0.5; 4.5; 4.5; 5.5; 5.5; 6.5; 6.5; 0.5];
            step = 1;
            scale = step/.25;
            [x, y] = meshgrid(-6.5:step:5.5, 0.5-step:step:6);
            brain_mask = poly2mask(x_range, y_range, length(-1:step:5), length(-6:step:6));
            x(~brain_mask) = nan;
            y(~brain_mask) = nan;
%             figure; scatter(x+2,y+1); hold on; plot(x_range-6, y_range)
            x_coord = reshape(x(~isnan(x))+2, 1,[]);
            y_coord = reshape(y(~isnan(y))+1, 1,[]);
            indices = [32,24,42,35,6,34,16,37,30,25,8,44,1,39,17,15,10,9,38,45,13,4,22,18,3,12,14,23,28,21,26,43,33,11,20,31,7,41,40,36,29,19,5,27,2];
            y_coord = y_coord(indices(30:end));
            x_coord = x_coord(indices(30:end));
    end

end

