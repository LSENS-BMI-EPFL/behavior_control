function main_control(~,event)
% Defines main control commands for the behaviour (lick, detection, stimuli delivery, ...)


    global Stim_S Reward_S lick_time quiet_window trial_duration iti  ...
         artifact_window wh_stim_amp...
        reaction_time  aud_vec aud_reward wh_reward wh_vec is_whisker is_auditory aud_stim_duration aud_stim_amp aud_stim_freq ...
        trial_end_time stim_flag perf lick_flag association_flag...
        timeout Trigger_S early_lick trial_started_flag ...
        folder_name is_stim light_prestim...
        lick_threshold handles2give response_window_start fid3 lh3 response_window_end wh_stim_duration...
        baseline_window deliver_reward_flag early_lick_counter trial_number...
        fid1 is_light_stim hit_time mouse_licked_flag  SITrigger_vec...
        perf_and_save_results_flag session_start_time trial_time trial_start_time Main_S_SR reward_delivered_flag...
        update_parameters_flag Stim_S_SR camera_vec is_reward light_duration light_freq light_amp trial_lick_data...


    %% Timing last lick detection for quiet window.
    % --------------------------------------------

    % A lick is defined as a single scan crossing the lick threshold.
    if sum(abs(event.Data(1:end-1,1)) < lick_threshold & abs(event.Data(2:end,1)) > lick_threshold)
        lick_time=tic;
    end

    
    %% Stimulus delivery.
    % ------------------

    % Trial start: 1. if stim flag ON, 2. no lick in quiet window 3. iti
    % has elapsed since trial_end_time
    if stim_flag && toc(lick_time) > quiet_window/1000 && toc(trial_end_time) > iti/1000        

        stim_flag=0; %reset
        set(handles2give.OnlineTextTag,'String','Trial Started','FontWeight','bold');
        trial_start_time=tic;
        outputSingleScan(Trigger_S,[1 0 0])

        % Free reward
        if association_flag && is_stim
            deliver_reward_flag=1;
        end

        trial_started_flag=1;
        perf_and_save_results_flag=0;
        mouse_licked_flag=0;
        trial_time=toc(session_start_time); % time since session start
    end


    %% Detecting rewarded licks and trigger reward.
    % --------------------------------------------

    if trial_started_flag && ~association_flag  && ... %check if currently within a trial
        toc(trial_start_time)>response_window_start && toc(trial_start_time)<response_window_end &&... %check if in response window
        sum(abs(event.Data(1:end-1,1))<lick_threshold & abs(event.Data(2:end,1))>lick_threshold) &&... %check if lick
        ~sum(abs(event.Data(1:end-1,1))<10000*lick_threshold & abs(event.Data(2:end,1))>10000*lick_threshold) %???

        trial_started_flag=0;
        
        %Check conditions for reward delivery
        if aud_reward && ~wh_reward
            if is_auditory
                hit_time=toc(trial_start_time);
                reward_delivery(is_stim, is_auditory, is_whisker, aud_reward, wh_reward); %deliver reward
                first_threshold_cross=find(abs(event.Data(1:end-1,1))<lick_threshold & abs(event.Data(2:end,1))>lick_threshold',1,'first');
                hit_time_adjusted=hit_time-first_threshold_cross/Main_S_SR;
                reaction_time=hit_time_adjusted-(baseline_window)/1000;
                mouse_licked_flag=1;
                perf_and_save_results_flag=1;

            elseif is_whisker
                hit_time=toc(trial_start_time);
                first_threshold_cross=find(abs(event.Data(1:end-1,1))<lick_threshold & abs(event.Data(2:end,1))>lick_threshold',1,'first');
                hit_time_adjusted=hit_time-first_threshold_cross/Main_S_SR;
                reaction_time=hit_time_adjusted-(baseline_window)/1000;
                mouse_licked_flag=1;
                perf_and_save_results_flag=1;

            else %no stim -> false alarm
                hit_time=toc(trial_start_time);
                first_threshold_cross=find(abs(event.Data(1:end-1,1))<lick_threshold & abs(event.Data(2:end,1))>lick_threshold',1,'first');
                hit_time_adjusted=hit_time-first_threshold_cross/Main_S_SR;
                reaction_time=hit_time_adjusted-(baseline_window)/1000;
                mouse_licked_flag=1;
                perf_and_save_results_flag=1;
            end

        elseif aud_reward && wh_reward
            hit_time=toc(trial_start_time);
            reward_delivery(is_stim, is_auditory, is_whisker, aud_reward, wh_reward);
            first_threshold_cross=find(abs(event.Data(1:end-1,1))<lick_threshold & abs(event.Data(2:end,1))>lick_threshold',1,'first');
            hit_time_adjusted=hit_time-first_threshold_cross/Main_S_SR;

            reaction_time=hit_time_adjusted-(baseline_window)/1000;

            mouse_licked_flag=1;
            perf_and_save_results_flag=1;
        end
    end

    %% Reset flags if no lick detected within the response window (correct rejection, miss trials)
    % --------------------------------------------------------------------------------------------
    if  trial_started_flag && toc(trial_start_time)>response_window_end && ~association_flag
        trial_started_flag=0;
        perf_and_save_results_flag=1;
    end


    %% Defining performance and update results file
    % ---------------------------------------------
    
    % Check if results update needed
    if perf_and_save_results_flag
        perf_and_save_results_flag=0;

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
                early_lick = 0;

            elseif is_stim && ~mouse_licked_flag && is_auditory
                set(handles2give.OnlineTextTag,'String','Auditory Miss','FontWeight','bold');
                lick_flag=0;
                perf=1;
                early_lick = 0;

            elseif is_stim && mouse_licked_flag && is_whisker
                set(handles2give.OnlineTextTag,'String','Whisker Hit','FontWeight','bold');
                lick_flag=1;
                perf=2;
                early_lick = 0;

            elseif is_stim && mouse_licked_flag && is_auditory
                set(handles2give.OnlineTextTag,'String','Auditory Hit','FontWeight','bold');
                lick_flag=1;
                perf=3;
                early_lick = 0;

            % Non-stimulus trials
            elseif ~is_stim && ~mouse_licked_flag
                set(handles2give.OnlineTextTag,'String','Correct Rejection','FontWeight','bold');
                lick_flag=0;
                perf=4;
                early_lick = 0;

            elseif ~is_stim && mouse_licked_flag
                set(handles2give.OnlineTextTag,'String','False Alarm','FontWeight','bold');
                lick_flag=1;
                perf=5; 
                early_lick = 0;
            end
        end

        % Save as results .txt file (no comma between variables!)
        results = [trial_number perf trial_time association_flag quiet_window iti ...
                is_stim is_whisker is_auditory lick_flag reaction_time ...
                wh_stim_duration wh_stim_amp wh_reward ...
                is_reward ...
                aud_stim_duration aud_stim_amp aud_stim_freq aud_reward ...
                early_lick ...
                is_light_stim light_amp light_duration light_freq light_prestim];
        fprintf(fid1,...
           '%6.0f %6.0f %10.4f %10.0f %10.4f %10.4f %6.0f %6.0f %6.0f %10.1f %10.1f %10.1f %6.0f %6.0f %10.4f %10.4f %10.1f %10.1f %6.0f %6.0f %6.0f %10.1f %10.1f %10.1f %10.1f \n',...
           results);
        
%         % Make session results table
%         results_table = table(trial_number, trial_time, association_flag, quiet_window, iti, perf, ...
%          is_stim, is_whisker, is_auditory, lick_flag, reaction_time, ...
%         wh_stim_duration, wh_stim_amp, wh_reward, ...
%         is_reward, ...
%         aud_stim_duration,aud_stim_amp,aud_stim_freq,aud_reward, ...
%         early_lick', ...
%         is_light_stim', light_amp,light_duration,light_freq,light_prestim);
%     
%         writetable(results_table, fid1);
        

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

    %% Detecting early licks (licks between cue and stim or between light start and stim) <- CHECK THIS

    if trial_started_flag && toc(trial_start_time)<response_window_start-(artifact_window)/1000 ...
       && sum(abs(event.Data(1:end-1,1))<lick_threshold & abs(event.Data(2:end,1))>lick_threshold)

        timeout=tic;
        trial_started_flag=0;
        early_lick = 1;
        early_lick_counter=early_lick_counter+1;
        deliver_reward_flag=0;
        Stim_S.stop();

        outputSingleScan(Trigger_S,[0 0 0]);

        set(handles2give.OnlineTextTag,'String','Early Lick','FontWeight','bold');

        while Stim_S.IsRunning
            continue
        end
        Stim_S.release();


        queueOutputData(Stim_S,[zeros(1,Stim_S_SR/2);zeros(1,Stim_S_SR/2); zeros(1,Stim_S_SR/2); zeros(1,Stim_S_SR/2)]')
%     queueOutputData(Stim_S,[zeros(1,Stim_S_SR/2); zeros(1,Stim_S_SR/2); zeros(1,Stim_S_SR/2)]')
        Stim_S.prepare();
        Stim_S.startBackground();

        lick_flag = 1;
        perf = 6;

        % Save as results .txt file
        results = [trial_number perf trial_time association_flag quiet_window iti ...
                is_stim is_whisker is_auditory lick_flag reaction_time ...
                wh_stim_duration wh_stim_amp wh_reward ...
                is_reward ...
                aud_stim_duration aud_stim_amp aud_stim_freq aud_reward ...
                early_lick ...
                is_light_stim light_amp light_duration light_freq light_prestim];
        fprintf(fid1,...
           '%6.0f %6.0f %10.4f %10.0f %10.4f %10.4f %6.0f %6.0f %6.0f %10.1f %10.1f %10.1f %6.0f %6.0f %10.4f %10.4f %10.1f %10.1f %6.0f %6.0f %6.0f %10.1f %10.1f %10.1f %10.1f \n',...
           results);
        
%         % Make session results table
%         results_table = table(trial_number, trial_start_time, association_flag, quiet_window, iti, perf, ...
%          is_stim, is_whisker, is_auditory, lick_flag, reaction_time, ...
%         wh_stim_duration, wh_stim_amp, wh_reward, ...
%         is_reward, ...
%         aud_stim_duration,aud_stim_amp,aud_stim_freq,aud_reward, ...
%         early_lick', ...
%         is_light_stim', light_amp,light_duration,light_freq,light_prestim);
%         writetable(results_table, fid_results, 'Delimiter',',', 'QuoteStrings',false);

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


        fclose(fid3);
        delete(lh3);

        trial_number = trial_number + 1;

        camera_flag = handles2give.camera_flag;

    %     if camera_flag
    %         Camera_freq=handles2give.CameraFrameRate; % Hz
    %
    %         VideoFileInfo.trial_number=trial_number;
    %
    %         VideoFileInfo.directory=['F:\Axel\' char(handles2give.mouse_name)...
    %             '\' [char(handles2give.mouse_name) '_' char(handles2give.date) '_' char(handles2give.session_time) '\']];
    %
    %         Block_Duration=300;
    %         VideoFileInfo.nOfFramesToGrab=(Block_Duration+120)*Camera_freq;
    %
    %         save('Z:\TemplateConfigFile\VideoFileInfo','VideoFileInfo');
    %
    %         %ArmCameraNew()
    %     end

        fid3=fopen([folder_name '\LickTrace' num2str(trial_number) '.bin'],'w');
        lh3 = addlistener(Stim_S,'DataAvailable',@(src, event)log_lick_data(src, event,trial_duration) );

        trial_lick_data=[];

        % queueOutputData(Stim_S,[Wh_vec; Aud_vec;Light_vec;Camera_vec;SITrigger_vec]')
        queueOutputData(Stim_S,[wh_vec; aud_vec; camera_vec;SITrigger_vec]')

        Stim_S.stno_artBackground();

        while ~Stim_S.IsRunning
            continue
        end

        reaction_time = 0;
        early_lick = 0;
        stim_flag=1;
    end


    %% Rewarding the stimulus trials in association mode
    % --------------------------------------------------
    if  trial_started_flag && association_flag && deliver_reward_flag &&...
            toc(trial_start_time)>(light_prestim +baseline_window)/1000

        deliver_reward_flag=0;
        outputSingleScan(Trigger_S,[0 1 0])
        reward_delivered_flag=1;
        outputSingleScan(Trigger_S,[0 0 0]);

        %Reset
        trial_started_flag=0;
        perf_and_save_results_flag=1;

    elseif trial_started_flag && association_flag && ~deliver_reward_flag &&...
            toc(trial_start_time)>(light_prestim + baseline_window)/1000

        trial_started_flag=0;
        perf_and_save_results_flag=1;
    end

end 
