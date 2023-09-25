function [opto_vec, galv_x, galv_y] = load_opto_vec(ML, AP)
%LOAD_OPTO_VEC Given a location from bregma, generate optogenetic pulse
%trains and set the movement of the galvanic mirrors.

    arguments
        ML = 0;
        AP = 0;
    end

    global handles2give voltage_x voltage_y bregma_x bregma_y
    root_path = 'M:\analysis\Pol_Bech\Parameters\';
    [t, opto_vec] = get_opto_vec(handles2give.trial_duration/1000);
    
    [bregma_x, bregma_y] = get_bregma(root_path, handles2give.mouse_name);
    [x_step, y_step] = get_step(getenv('COMPUTERNAME')); % if not WF setups, step is 0 so no voltage sent to ao5 and ao6
    
    voltage_x = bregma_x + ML*x_step;
    voltage_y = bregma_y + AP*y_step;
    
    galv_x = (voltage_x)*ones(1, length(t));
    galv_y = (voltage_y)*ones(1, length(t));


end

