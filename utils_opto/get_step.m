function [x_step, y_step] = get_step(computer)
%GET_STEP Calibrated step voltage to move laser beam 1mm. Perform
%regularly.
%   Last calibrated....

    switch computer
        case 'SV-07-051'
            x_step = 0.5196; % V per mm
            y_step = -0.3453; % V per mm
        case 'SV-07-068'
            x_step = 0.2616; % V per mm
            y_step = -0.2856; % V per mm
        otherwise
            x_step = 0;
            y_step = 0;
    end

end

