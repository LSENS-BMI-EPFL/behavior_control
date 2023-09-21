function [opto_vec, galv_x, galv_y] = load_opto_vec(ML, AP)
%LOAD_OPTO_VEC Summary of this function goes here
%   Detailed explanation goes here
    arguments
        ML = 0;
        AP = 0;
    end

    global handles2give
    root_path = 'M:\analysis\Pol_Bech\Parameters\';
    [t, opto_vec] = get_opto_vec(handles2give.trial_duration/1000);
    
    [bregma_x, bregma_y] = get_bregma(root_path, handles2give.mouse_name);
    [x_step, y_step] = get_step(getenv('COMPUTERNAME')); % if not WF setups, step is 0 so no voltage sent to ao5 and ao6

    galv_x = (bregma_x + ML*x_step)*ones(1, length(t));
    galv_y = (bregma_y + AP*y_step)*ones(1, length(t));


end

