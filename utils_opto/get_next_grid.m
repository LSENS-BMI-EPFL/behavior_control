function [ML, AP, grid_no, count] = get_next_grid
    global opto_gui trial_number is_stim is_auditory is_whisker is_opto block_id...
        opto_count opto_stim_count opto_stim_x opto_stim_y opto_aud_count opto_aud_x opto_aud_y...
        opto_wh_count opto_wh_x opto_wh_y stim_grid aud_grid wh_grid grid_size

    grid_type = opto_gui.grid;
    
    if trial_number == 1
        save_opto_config

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

        opto_count = 1;
%         Opto_S.start('continuous');
    end

    opto_gui.plot_grid

    if strcmp(grid_type, 'No Grid')
        AP = stim_x; 
        ML = stim_y;    
        grid_no = nan;
        grid_size = 0;
        
        switch 1
            case ~is_stim
                plot_text = 'No Stim ';
                count = opto_stim_count(block_id);
                opto_stim_count(block_id) = opto_stim_count(block_id)+1;
            case is_auditory
                plot_text = 'Auditory ';
                count = opto_aud_count(block_id);
                opto_aud_count(block_id) = opto_aud_count(block_id)+1;    
            case is_whisker
                plot_text = 'Whisker ';
                count = opto_wh_count(block_id);
                opto_wh_count(block_id) = opto_wh_count(block_id)+1;                 
        end

    else
        switch 1
            case ~is_stim

                if opto_stim_count(block_id) > grid_size
                    opto_stim_count(block_id) = 1;
                    perm = randperm(grid_size);
                    opto_stim_x(block_id, :) = opto_stim_x(block_id, perm);
                    opto_stim_y(block_id, :) = opto_stim_y(block_id, perm);
                    stim_grid(block_id) = stim_grid(block_id) + 1;
                end

                AP = opto_stim_x(block_id, opto_stim_count(block_id));
                ML = opto_stim_y(block_id, opto_stim_count(block_id));
                grid_no = stim_grid(block_id);
                count = opto_stim_count(block_id);
                
                scatter(opto_gui.UIAxes, opto_stim_x(block_id, 1:opto_stim_count(block_id)), opto_stim_y(block_id, 1:opto_stim_count(block_id)), 'filled', 'MarkerEdgeColor', '#32CD32', 'MarkerFaceColor', '#32CD32');
%                 text(opto_gui.UIAxes, 1, 6.5, {['No Stim grid ' num2str(stim_grid(block_id))], ['trial ' num2str(opto_stim_count(block_id)) '/' num2str(grid_size)]})
                plot_txt = 'No Stim grid ';
                opto_stim_count(block_id) = opto_stim_count(block_id)+1;

            case is_auditory

                if opto_aud_count(block_id) > grid_size
                    opto_aud_count(block_id) = 1;
                    perm = randperm(grid_size);
                    opto_aud_x(block_id, :) = opto_aud_x(block_id, perm);
                    opto_aud_y(block_id, :) = opto_aud_y(block_id, perm);
                    aud_grid(block_id) = aud_grid(block_id) + 1;
                end

                AP = opto_aud_x(block_id, opto_aud_count(block_id));
                ML = opto_aud_y(block_id, opto_aud_count(block_id));
                grid_no = aud_grid(block_id);
                count = opto_aud_count(block_id);
                
                scatter(opto_gui.UIAxes, opto_aud_x(block_id, 1:opto_aud_count(block_id)), opto_aud_y(block_id, 1:opto_aud_count(block_id)), 'filled', 'MarkerEdgeColor', '#32CD32', 'MarkerFaceColor', '#32CD32');
%                 text(opto_gui.UIAxes, 1, 6.5, {['Aud grid ' num2str(aud_grid(block_id))], ['trial ' num2str(opto_aud_count(block_id)) '/' num2str(grid_size)]})
                plot_txt = 'Aud grid ';
                opto_aud_count(block_id) = opto_aud_count(block_id)+1;

            case is_whisker              

                if opto_wh_count(block_id) > grid_size
                    opto_wh_count(block_id) = 1;
                    perm = randperm(grid_size);
                    opto_wh_x(block_id, :) = opto_wh_x(block_id, perm);
                    opto_wh_y(block_id, :) = opto_wh_y(block_id, perm);
                    wh_grid(block_id) = wh_grid(block_id) + 1;
                end

                AP = opto_wh_x(block_id, opto_wh_count(block_id));
                ML = opto_wh_y(block_id, opto_wh_count(block_id));
                grid_no = wh_grid(block_id);
                count = opto_wh_count(block_id);

                scatter(opto_gui.UIAxes, opto_wh_x(block_id, 1:opto_wh_count(block_id)), opto_wh_y(block_id, 1:opto_wh_count(block_id)), 'filled', 'MarkerEdgeColor', '#32CD32', 'MarkerFaceColor', '#32CD32');
%                 text(opto_gui.UIAxes, 1, 6.5, {['Whisker grid ' num2str(wh_grid(block_id))], ['trial ' num2str(opto_wh_count(block_id)) '/' num2str(grid_size)]})
                plot_txt = 'Whisker grid ';
                opto_wh_count(block_id) = opto_wh_count(block_id)+1;
            
        end
        
        scatter(opto_gui.UIAxes, AP, ML, 'filled', 'MarkerEdgeColor', '#DC143C', 'MarkerFaceColor', '#DC143C');
        text(opto_gui.UIAxes, 1, 6.5, {[plot_txt num2str(grid_no)], ['trial ' num2str(count) '/' num2str(grid_size)]})
        
    end


