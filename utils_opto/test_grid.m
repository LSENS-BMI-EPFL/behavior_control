grid_type = 1;

switch grid_type
    case 1
        step = 0.5;
        [x, y] = meshgrid(0:step:8, 0:step:10);
        shift_x = -5;
        shift_y = 0.5;

        x_range = [9,9,8.5,8,7.5,7,6.5,6,0.5,0.5,0.5,0,0,0.5,0.5,9];
        y_range = [0,3,3.5,4,4.5,5,5.5,6,6,5,4.5,4.5,1.5,1.5,0,0];

        brain_mask = poly2mask(2*x_range, 2*y_range, length(0:step:10), length(0:step:8));
        figure; scatter(x(brain_mask)+shift_x, y(brain_mask)+shift_y)

    case 2
        step = 0.75;
        [x, y] = meshgrid(-1:step:7, -6:step:4);
        shift_x = -3.75;
        shift_y = 0.75;        
        
        x_range = [  0, 0, 1,   1, 6.75, 9.75, 9.75,    1,    1];
        y_range = [1.5, 4, 4, 5.5,  5.5, 3.25,    0,    0,  1.5];
        
        brain_mask = poly2mask(1.4*x_range, 1.4*y_range, length(0:step:10), length(0:step:8));
%         figure; imshow(brain_mask); hold on; plot(1.4*x_range, 1.4*y_range)
        figure; scatter(x(brain_mask)+shift_x, y(brain_mask)+shift_y)
end