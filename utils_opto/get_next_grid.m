function [ML, AP, grid_no, count] = get_next_grid
%GET_NEXT_GRID return the bregma-centered ML and AP coordinates of the next
%point in the grid to stimulate, as well as the current number of grids and
%the trial/total grid trials.

    global opto_gui trial_number is_stim is_auditory is_whisker is_opto block_id...
        opto_count opto_stim_count opto_stim_x opto_stim_y opto_aud_count opto_aud_x opto_aud_y...
        opto_wh_count opto_wh_x opto_wh_y stim_grid aud_grid wh_grid grid_size

    grid_type = opto_gui.grid; % get which grid info from gui
    
    if trial_number == 1
        save_opto_config

        [stim_x, stim_y] = get_stim_grid(grid_type, opto_gui.AP_coord, opto_gui.ML_coord); % Retrieve the stim locations for desired grid
        grid_size = length(stim_x);
        
        % Set starting parameters
        stim_grid = [1, 1];
        opto_stim_count = [1, 1];
        C1 = randperm(grid_size);
        C2 = randperm(grid_size);
        opto_stim_x = [stim_x(C1); stim_x(C2)]; % shuffle xy coordinates together
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
    end

    opto_gui.plot_grid % Refresh plot in Opto_GUI

    if strcmp(grid_type, 'No Grid')
        AP = stim_x; 
        ML = stim_y;    
        grid_no = nan;
        grid_size = 0;
        
        % Update trial counts for each condition
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

                % Once gone through all locations in a grid, shuffle again the order and increase grid number
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
                
                % Display all trials already stimulated in GUI
                scatter(opto_gui.UIAxes, opto_stim_x(block_id, 1:opto_stim_count(block_id)), opto_stim_y(block_id, 1:opto_stim_count(block_id)), 'filled', 'MarkerEdgeColor', '#32CD32', 'MarkerFaceColor', '#32CD32');
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
                plot_txt = 'Whisker grid ';
                opto_wh_count(block_id) = opto_wh_count(block_id)+1;
            
        end
        
        % Display current trial in GUI
        scatter(opto_gui.UIAxes, AP, ML, 'filled', 'MarkerEdgeColor', '#DC143C', 'MarkerFaceColor', '#DC143C');
        text(opto_gui.UIAxes, 1, 6.5, {[plot_txt num2str(grid_no)], ['trial ' num2str(count) '/' num2str(grid_size)]})
        
    end


