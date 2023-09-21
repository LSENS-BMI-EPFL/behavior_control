function [ML, AP] = get_next_grid
    global opto_gui trial_number is_stim is_auditory is_whisker block_id...
        opto_stim_count opto_stim_x opto_stim_y opto_aud_count opto_aud_x opto_aud_y...
        opto_wh_count opto_wh_x opto_wh_y stim_grid aud_grid wh_grid grid_size

    grid_type = opto_gui.grid;
    
    if trial_number == 1
        [stim_x, stim_y] = get_stim_grid(grid_type, opto_gui.AP_coord, opto_gui.ML_coord);
        grid_size = length(stim_x);
        
        stim_grid = [1, 1];
        opto_stim_count = [1, 1];
        C1 = randperm(grid_size);
        C2 = randperm(grid_size);
        opto_stim_x = [stim_x(C1); stim_x(C2)];
        opto_stim_y = [stim_y(C1); stim_y(C2)];

        aud_grid = [1, 1];
        opto_aud_count = [1, 1];
        C1 = randperm(grid_size);
        C2 = randperm(grid_size);
        opto_aud_x = [stim_x(C1); stim_x(C2)];
        opto_aud_y = [stim_y(C1); stim_y(C2)];

        wh_grid = [1, 1];
        opto_wh_count = [1, 1];
        C1 = randperm(grid_size);
        C2 = randperm(grid_size);
        opto_wh_x = [stim_x(C1); stim_x(C2)];
        opto_wh_y = [stim_y(C1); stim_y(C2)];
    end

    opto_gui.plot_grid

    if strcmp(grid_type, 'No Grid')
        AP = stim_x; 
        ML = stim_y;    
    else
        switch 1
            case ~is_stim
                AP = opto_stim_x(block_id, opto_stim_count(block_id));
                ML = opto_stim_y(block_id, opto_stim_count(block_id));

                if opto_stim_count(block_id) > grid_size
                    opto_stim_count(block_id) = 1;
                    perm = randperm(grid_size);
                    opto_stim_x(block_id, :) = stim_x(perm);
                    opto_stim_y(block_id, :) = stim_y(perm);
                    stim_grid(block_id) = stim_grid(block_id) + 1;
                end
                
                scatter(opto_gui.UIAxes, opto_stim_x(block_id, 1:opto_stim_count(block_id)), opto_stim_y(block_id, 1:opto_stim_count(block_id)), 'filled', 'MarkerEdgeColor', '#32CD32', 'MarkerFaceColor', '#32CD32');
                text(opto_gui.UIAxes, 1, 6.5, {['No Stim grid ' num2str(stim_grid(block_id))], ['trial ' num2str(opto_stim_count(block_id)) '/' num2str(grid_size)]})
                opto_stim_count(block_id) = opto_stim_count(block_id)+1;

            case is_auditory
                AP = opto_aud_x(block_id, opto_aud_count(block_id));
                ML = opto_aud_y(block_id, opto_aud_count(block_id));

                if opto_aud_count(block_id) > grid_size
                    opto_aud_count(block_id) = 1;
                    perm = randperm(grid_size);
                    opto_aud_x(block_id, :) = stim_x(perm);
                    opto_aud_y(block_id, :) = stim_y(perm);
                    aud_grid(block_id) = aud_grid(block_id) + 1;
                end
                
                scatter(opto_gui.UIAxes, opto_aud_x(block_id, 1:opto_aud_count(block_id)), opto_aud_y(block_id, 1:opto_aud_count(block_id)), 'filled', 'MarkerEdgeColor', '#32CD32', 'MarkerFaceColor', '#32CD32');
                text(opto_gui.UIAxes, 1, 6.5, {['Aud grid ' num2str(aud_grid(block_id))], ['trial ' num2str(opto_aud_count(block_id)) '/' num2str(grid_size)]})
                opto_aud_count(block_id) = opto_aud_count(block_id)+1;

            case is_whisker
                AP = opto_wh_x(block_id, opto_wh_count(block_id));
                ML = opto_wh_y(block_id, opto_wh_count(block_id));

                if opto_wh_count(block_id) > grid_size
                    opto_wh_count(block_id) = 1;
                    perm = randperm(grid_size);
                    opto_wh_x(block_id, :) = stim_x(perm);
                    opto_wh_y(block_id, :) = stim_y(perm);
                    wh_grid(block_id) = wh_grid(block_id) + 1;
                end
                scatter(opto_gui.UIAxes, opto_wh_x(block_id, 1:opto_wh_count(block_id)), opto_wh_y(block_id, 1:opto_wh_count(block_id)), 'filled', 'MarkerEdgeColor', '#32CD32', 'MarkerFaceColor', '#32CD32');
                text(opto_gui.UIAxes, 1, 6.5, {['Whisker grid ' num2str(wh_grid(block_id))], ['trial ' num2str(opto_wh_count(block_id)) '/' num2str(grid_size)]})
                opto_wh_count(block_id) = opto_wh_count(block_id)+1;
            
            otherwise
                AP = -5;
                ML = 5;
                
        end
        
        scatter(opto_gui.UIAxes, AP, ML, 'filled', 'MarkerEdgeColor', '#DC143C', 'MarkerFaceColor', '#DC143C');
                
    end


