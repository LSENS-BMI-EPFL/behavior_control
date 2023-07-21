function main_control(~,event)
% Defines main control commands for the behaviour (lick, detection, stimuli delivery, ...)


    global Main_S_SR association_flag trial_duration quiet_window lick_threshold...
        artifact_window iti camera_flag is_stim is_auditory is_whisker is_light ...
        aud_reward wh_reward wh_vec aud_vec early_lick...
        stim_flag perf session_start_time lick_flag lick_time trial_start_time trial_end_time trial_time...
        false_alarm_punish_flag false_alarm_timeout early_lick_counter early_lick_punish_flag early_lick_timeout ...
        Stim_S wh_stim_duration wh_scaling_factor aud_stim_duration  aud_stim_amp  aud_stim_freq  Stim_S_SR ...
        Reward_S  Trigger_S fid_lick_trace mouse_licked_flag reaction_time ...
        trial_started_flag  trial_number folder_name handles2give...
        baseline_window camera_vec...
        deliver_reward_flag ...
        wh_stim_amp response_window response_window_start response_window_end...
        fid_results perf_and_save_results_flag reward_delivered_flag update_parameters_flag...
        is_reward...
        light_prestim_delay light_duration light_freq light_amp SITrigger_vec...
        context_flag extra_time...
        pink_noise_player brown_noise_player context_block  
        

    %% Timing last lick detection for quiet window.
    % --------------------------------------------

    % A lick is defined as a single scan crossing the lick threshold.
    % if sum(abs(event.Data(1:end-1,1)) < lick_threshold & abs(event.Data(2:end,1)) > lick_threshold)
    % To make the detection more robust to noise, a lick is defined as 8 samples (out
    % of the 10 samples from data available notifications) above the threshold.
    if sum(abs(event.Data(1:end,1)) > lick_threshold) >= 8
        lick_time=tic;
    end

    
    %% Stimulus delivery at trial start.
    % ------------------

    % Trial start: 1. if stim flag ON, 2. no lick in quiet window 3. iti
    % has elapsed since trial_end_time
    
    if stim_flag && toc(lick_time) > quiet_window/1000 && toc(trial_end_time) > iti/1000+extra_time

        stim_flag=0; %reset
        set(handles2give.OnlineTextTag,'String','Trial Started','FontWeight','bold');
        trial_start_time=tic;
        outputSingleScan(Trigger_S,[1 0 0])


        % Free reward
        if association_flag && is_stim
            deliver_reward_flag=1;
        end

        trial_started_flag = 1;
        perf_and_save_results_flag = 0;
        mouse_licked_flag = 0;
        trial_time = toc(session_start_time); % time since session start
    end


    %% Detecting rewarded licks and trigger reward. 
    % --------------------------------------------

    % sum(abs(event.Data(1:end-1,1))<lick_threshold & abs(event.Data(2:end,1))>lick_threshold) &&... %check if lick
    if trial_started_flag && ~association_flag  &&... %check if currently within a trial
        toc(trial_start_time)>response_window_start && toc(trial_start_time)<response_window_end &&... %check if in response window
        sum(abs(event.Data(1:end,1)) > lick_threshold) >= 8 &&...
        ~sum(abs(event.Data(1:end-1,1))<10000*lick_threshold & abs(event.Data(2:end,1))>10000*lick_threshold) % <- WHY THIS?

        trial_started_flag=0;
        
        % Check conditions for reward delivery
        if aud_reward && ~wh_reward
            if is_auditory
                hit_time=toc(trial_start_time);
                reward_delivery; %deliver reward
%                 first_threshold_cross=find(abs(event.Data(1:end-1,1))<lick_threshold & abs(event.Data(2:end,1))>lick_threshold',1,'first');
                first_threshold_cross=find(abs(event.Data(2:end,1))>lick_threshold',1,'first');
                hit_time_adjusted=hit_time-first_threshold_cross/Main_S_SR;
                reaction_time=hit_time_adjusted-(baseline_window)/1000;
                mouse_licked_flag=1;
                perf_and_save_results_flag=1;

            elseif is_whisker
                hit_time=toc(trial_start_time);
                % first_threshold_cross=find(abs(event.Data(1:end-1,1))<lick_threshold & abs(event.Data(2:end,1))>lick_threshold',1,'first');
                first_threshold_cross=find(abs(event.Data(2:end,1))>lick_threshold',1,'first');
                hit_time_adjusted=hit_time-first_threshold_cross/Main_S_SR;
                reaction_time=hit_time_adjusted-(baseline_window)/1000;
                mouse_licked_flag=1;
                perf_and_save_results_flag=1;

            else %no stim -> false alarm
                hit_time=toc(trial_start_time);
                % first_threshold_cross=find(abs(event.Data(1:end-1,1))<lick_threshold & abs(event.Data(2:end,1))>lick_threshold',1,'first');
                first_threshold_cross=find(abs(event.Data(2:end,1))>lick_threshold',1,'first');
                hit_time_adjusted=hit_time-first_threshold_cross/Main_S_SR;
                reaction_time=hit_time_adjusted-(baseline_window)/1000;
                mouse_licked_flag=1;
                perf_and_save_results_flag=1;
            end

        elseif aud_reward && wh_reward
            hit_time=toc(trial_start_time);
            reward_delivery;
            % first_threshold_cross=find(abs(event.Data(1:end-1,1))<lick_threshold & abs(event.Data(2:end,1))>lick_threshold',1,'first');
            first_threshold_cross=find(abs(event.Data(2:end,1))>lick_threshold',1,'first'); 
            hit_time_adjusted=hit_time-first_threshold_cross/Main_S_SR;
            reaction_time=hit_time_adjusted-(baseline_window)/1000;
            mouse_licked_flag=1;
            perf_and_save_results_flag=1;

        elseif ~aud_reward && wh_reward
            if is_auditory
                hit_time=toc(trial_start_time);
                % first_threshold_cross=find(abs(event.Data(1:end-1,1))<lick_threshold & abs(event.Data(2:end,1))>lick_threshold',1,'first');
                first_threshold_cross=find(abs(event.Data(2:end,1))>lick_threshold',1,'first'); 
                hit_time_adjusted=hit_time-first_threshold_cross/Main_S_SR;
                reaction_time=hit_time_adjusted-(baseline_window)/1000;
                mouse_licked_flag=1;
                perf_and_save_results_flag=1;
            elseif is_whisker
                hit_time=toc(trial_start_time);
                reward_delivery;
                % first_threshold_cross=find(abs(event.Data(1:end-1,1))<lick_threshold & abs(event.Data(2:end,1))>lick_threshold',1,'first');
                first_threshold_cross=find(abs(event.Data(2:end,1))>lick_threshold',1,'first'); 
                hit_time_adjusted=hit_time-first_threshold_cross/Main_S_SR;
                reaction_time=hit_time_adjusted-(baseline_window)/1000;
                mouse_licked_flag=1;
                perf_and_save_results_flag=1;
            end
        end
    end

    %% Reset flags if no lick detected within the response window (correct rejection, miss trials)
    % --------------------------------------------------------------------------------------------
    if  trial_started_flag && toc(trial_start_time)>response_window_end && ~association_flag
        % Release reward_vec (useful for proba. whisker reward)
        Reward_S.stop()
        Reward_S.release()
        trial_started_flag=0;
        perf_and_save_results_flag=1;
    end


    %% Defining performance and update results file
    % ---------------------------------------------

    % Check if results update needed
    if perf_and_save_results_flag
        perf_and_save_results_flag=0;
        early_lick=0;
        
        %Association trials
        if association_flag
            set(handles2give.OnlineTextTag,'String','Trial Finished','FontWeight','bold');
            lick_flag=0;
            perf=6; 

        % All other trials
        else
            % Stimulus trials
            if is_stim && ~mouse_licked_flag && is_whisker
                set(handles2give.OnlineTextTag,'String','Whisker Miss','FontWeight','bold');
                lick_flag=0;
                perf=0;

            elseif is_stim && ~mouse_licked_flag && is_auditory
                set(handles2give.OnlineTextTag,'String','Auditory Miss','FontWeight','bold');
                lick_flag=0;
                perf=1;

            elseif is_stim && mouse_licked_flag && is_whisker
                set(handles2give.OnlineTextTag,'String','Whisker Hit','FontWeight','bold');
                lick_flag=1;
                perf=2;

            elseif is_stim && mouse_licked_flag && is_auditory
                set(handles2give.OnlineTextTag,'String','Auditory Hit','FontWeight','bold');
                lick_flag=1;
                perf=3;

            % Non-stimulus trials
            elseif ~is_stim && ~mouse_licked_flag
                set(handles2give.OnlineTextTag,'String','Correct Rejection','FontWeight','bold');
                lick_flag=0;
                perf=4;

            elseif ~is_stim && mouse_licked_flag
                set(handles2give.OnlineTextTag,'String','False Alarm','FontWeight','bold');
                lick_flag=1;
                perf=5; 
                
                if false_alarm_punish_flag
                    pause(false_alarm_timeout / 1000);
                end
                
            end
        end
        
        % Set variables to save and namings. Be careful updating here / order & names
        variables_to_save = {trial_number perf trial_time association_flag ...
            quiet_window iti response_window artifact_window baseline_window ...
            trial_duration is_stim is_whisker is_auditory lick_flag reaction_time ...
            wh_stim_duration wh_stim_amp wh_scaling_factor wh_reward is_reward ...
            aud_stim_duration aud_stim_amp aud_stim_freq aud_reward early_lick ...
            is_light light_amp light_duration light_freq light_prestim_delay ...
            context_block};
        disp(variables_to_save)

        variable_saving_names = {'trial_number', 'perf', 'trial_time', 'association_flag', 'quiet_window','iti', ...
            'response_window', 'artifact_window','baseline_window','trial_duration', ...
            'is_stim', 'is_whisker', 'is_auditory', 'lick_flag', 'reaction_time', ...
            'wh_stim_duration', 'wh_stim_amp', 'wh_scaling_factor', 'wh_reward', ...
            'is_reward', ...
            'aud_stim_duration','aud_stim_amp','aud_stim_freq','aud_reward', ...
            'early_lick', ...
            'is_light', 'light_amp','light_duration','light_freq','light_prestim', 'context_block'};
        disp(variable_saving_names)

        % Update csv result file
        update_and_save_results_csv(variables_to_save, variable_saving_names)

        % Reset time and flag
        trial_end_time=tic; %trial end time after reward delivery and results are saved
        update_parameters_flag=1; %update params for next trials

    end

    %% Update parameters for next trial
    % ---------------------------------
    if update_parameters_flag && Stim_S.IsDone &&...
            (~reward_delivered_flag || Reward_S.ScansQueued==0) && ~handles2give.PauseRequested %<- why check reward flag?

        update_parameters_flag=0;
        update_parameters;

    elseif update_parameters_flag && Stim_S.IsDone &&...
            (~reward_delivered_flag || Reward_S.ScansQueued==0) && handles2give.PauseRequested && handles2give.ReportPause

        handles2give.ReportPause=0; %reset
        set(handles2give.OnlineTextTag,'String','Session Paused','FontWeight','bold');

    end

    %% UNCLEAR PART - Detecting early licks (licks between baseline start and stimulus or between light start and stim) <- CHECK THIS
    % Early licks results in aborted trials, before starting a new trial

    %        && sum(abs(event.Data(1:end-1,1))<lick_threshold & abs(event.Data(2:end,1))>lick_threshold)
    if trial_started_flag && toc(trial_start_time)<response_window_start-(artifact_window)/1000 ...
        && sum(abs(event.Data(1:end,1)) > lick_threshold) >= 8

        trial_started_flag=0;
        early_lick = 1;
        early_lick_counter=early_lick_counter+1;
        deliver_reward_flag=0;
        Stim_S.stop();

        outputSingleScan(Trigger_S,[0 0 0]);

        set(handles2give.OnlineTextTag,'String','Early Lick','FontWeight','bold');

        while Stim_S.IsRunning % shouldn't this be before stopping?
            continue
        end
        Stim_S.release();
        
        if early_lick_punish_flag
            pause(early_lick_timeout / 1000);
        end

        queueOutputData(Stim_S,[zeros(1,Stim_S_SR/2);zeros(1,Stim_S_SR/2); zeros(1,Stim_S_SR/2); zeros(1,Stim_S_SR/2)]')
        Stim_S.prepare();
        Stim_S.startBackground();

        lick_flag = 1;
        perf = 6;


        % Set variables to save and namings. Be careful updating here / order & names
        variables_to_save = {trial_number perf trial_time association_flag ...
            quiet_window iti response_window artifact_window baseline_window ...
            trial_duration is_stim is_whisker is_auditory lick_flag reaction_time ...
            wh_stim_duration wh_stim_amp wh_scaling_factor wh_reward is_reward ...
            aud_stim_duration aud_stim_amp aud_stim_freq aud_reward early_lick ...
            is_light light_amp light_duration light_freq light_prestim_delay ...
            context_block};
        
        variable_saving_names = {'trial_number', 'perf', 'trial_time', 'association_flag', 'quiet_window','iti', ...
            'response_window', 'artifact_window','baseline_window','trial_duration', ...
            'is_stim', 'is_whisker', 'is_auditory', 'lick_flag', 'reaction_time', ...
            'wh_stim_duration', 'wh_stim_amp', 'wh_scaling_factor', 'wh_reward', ...
            'is_reward', ...
            'aud_stim_duration','aud_stim_amp','aud_stim_freq','aud_reward', ...
            'early_lick', ...
            'is_light', 'light_amp','light_duration','light_freq','light_prestim', 'context_block'};

        % Update csv result file
        update_and_save_results_csv(variables_to_save, variable_saving_names)

        while ~Stim_S.IsRunning
            continue
        end

        outputSingleScan(Trigger_S,[1 0 0]);

        while Stim_S.ScansQueued==0
            continue
        end

        Stim_S.stop();
        Stim_S.release();
        outputSingleScan(Trigger_S,[0 0 0]);

        while Stim_S.IsRunning
            continue
        end

        trial_number = trial_number + 1;

        % queueOutputData(Stim_S,[Wh_vec; Aud_vec;Light_vec;Camera_vec;SITrigger_vec]')
        queueOutputData(Stim_S,[wh_vec; aud_vec; camera_vec;SITrigger_vec]')

        Stim_S.startBackground();

        while ~Stim_S.IsRunning
            continue
        end

        % Reset after early lick
        reaction_time = 0;
        early_lick = 0;
        stim_flag=1;
    end


    %% Rewarding the stimulus trials in association mode
    % --------------------------------------------------
    if  association_flag && trial_started_flag && deliver_reward_flag &&...
            toc(trial_start_time)>(light_prestim_delay +baseline_window)/1000

        deliver_reward_flag=0;
        outputSingleScan(Trigger_S,[0 1 0])
        reward_delivered_flag=1;
        outputSingleScan(Trigger_S,[0 0 0]);

        %Reset
        trial_started_flag=0;
        perf_and_save_results_flag=1;

    elseif trial_started_flag && association_flag && ~deliver_reward_flag &&...
            toc(trial_start_time)>(light_prestim_delay + baseline_window)/1000

        trial_started_flag=0;
        perf_and_save_results_flag=1;
    end

end 
