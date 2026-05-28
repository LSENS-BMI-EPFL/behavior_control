function stop_sessions
%STOP_SESSIONS Terminate DAQ sessions and close files (clean/safe version).

global Reward_S Stim_S Main_S Trigger_S Log_S TTL_S ...
       lh1 lh2 handles2give Stim_S_SR Reward_S_SR Camera_S ...
       pink_noise_player brown_noise_player context_flag WF_S Opto_S ...
       ttl1_edge_idx ttl2_edge_idx ttl1_current_state ttl2_current_state ...
       session_stopping_flag

session_stopping_flag = true;

% Helper: tiny pause to avoid CPU pegging in while-loops
spinPause = @() pause(0.001);

%% Delete listeners early to prevent callbacks during shutdown
try
    if ~isempty(lh1) && isvalid(lh1)
        delete(lh1);
    end
catch
end
lh1 = [];

try
    if ~isempty(lh2) && isvalid(lh2)
        delete(lh2);
    end
catch
end
lh2 = [];


%% Reset TTL edge playback state
try
    ttl1_edge_idx = 1;
    ttl2_edge_idx = 1;
    ttl1_current_state = false;
    ttl2_current_state = false;
catch
end

%% Stop widefield session
try
    if ~isempty(handles2give) && isfield(handles2give,'wf_session') ...
            && handles2give.wf_session && ...
            (~isfield(handles2give,'opto_session') || ~handles2give.opto_session)
        wf_stop
    end
catch
end

%% Stop Main_S
try
    if ~isempty(Main_S)
        Main_S.stop();
        while isprop(Main_S,'IsRunning') && Main_S.IsRunning
            spinPause();
        end
        Main_S.release();
        Main_S = [];
    end
catch
end

%% Stop Log_S
try
    if ~isempty(Log_S)
        Log_S.stop();
        while isprop(Log_S,'IsRunning') && Log_S.IsRunning
            spinPause();
        end
        Log_S.release();
        Log_S = [];
    end
catch
end

%% Stop Camera_S
try
    if ~isempty(Camera_S)
        try
            stop(Camera_S);
        catch
        end
        try
            while isprop(Camera_S,'Running') && Camera_S.Running
                spinPause();
            end
        catch
        end
        Camera_S = [];
    end
catch
end

%% Stop Stim_S
try
    if ~isempty(Stim_S)
        try
            Stim_S.stop();
        catch
        end
        while isprop(Stim_S,'IsRunning') && Stim_S.IsRunning
            spinPause();
        end

        % Force AO/DO outputs low (best-effort) BEFORE release.
        % Stim_S channels:
        % [whisker_AO, auditory_AO, camera_DO, SITrigger_DO]
        try
            nS = max(round(Stim_S_SR/2), 10);
            z = zeros(nS, 4);
            queueOutputData(Stim_S, z);
            Stim_S.startForeground();
        catch
        end

        try
            Stim_S.stop();
        catch
        end
        while isprop(Stim_S,'IsRunning') && Stim_S.IsRunning
            spinPause();
        end
        Stim_S.release();
        Stim_S = [];
    end
catch
end

%% Stop TTL_S (static digital session for TTL1 + TTL2)
try
    if ~isempty(TTL_S)
        try
            outputSingleScan(TTL_S, [0 0]);
        catch
        end
        try
            TTL_S.stop();
        catch
        end
        while isprop(TTL_S,'IsRunning') && TTL_S.IsRunning
            spinPause();
        end
        try
            TTL_S.release();
        catch
        end
        TTL_S = [];
    end
catch
end

%% Stop Reward_S
try
    if ~isempty(Reward_S)
        try
            Reward_S.stop();
        catch
        end
        while isprop(Reward_S,'IsRunning') && Reward_S.IsRunning
            spinPause();
        end

        % Force AO low (best-effort) BEFORE release.
        try
            nS = max(round(Reward_S_SR/2), 10);
            z = zeros(nS,1);
            queueOutputData(Reward_S, z);
            Reward_S.startForeground();
        catch
        end

        try
            Reward_S.stop();
        catch
        end
        while isprop(Reward_S,'IsRunning') && Reward_S.IsRunning
            spinPause();
        end
        Reward_S.release();
        Reward_S = [];
    end
catch
end

%% Set Trigger_S lines low, then release
try
    if ~isempty(Trigger_S)
        try
            outputSingleScan(Trigger_S,[0 0 0]);
        catch
        end
        try
            Trigger_S.stop();
        catch
        end
        while isprop(Trigger_S,'IsRunning') && Trigger_S.IsRunning
            spinPause();
        end
        Trigger_S.release();
        Trigger_S = [];
    end
catch
end

%% Stop Opto_S
try
    if ~isempty(handles2give) && isfield(handles2give,'opto_session') && handles2give.opto_session
        global opto_stim_count opto_wh_count opto_aud_count opto_count stim_grid wh_grid aud_grid
        try
            save_opto_config
        catch
        end
        try
            if ~isempty(Opto_S)
                Opto_S.stop();
                Opto_S.release();
                Opto_S = [];
                stim_grid = [1, 1];
                opto_stim_count = [1, 1];
                wh_grid = [1, 1];
                opto_wh_count = [1, 1];
                aud_grid = [1, 1];
                opto_aud_count = [1, 1];
                opto_count = 1;
            end
        catch
        end
    end
catch
end
% %% Delete listeners
% try
%     if ~isempty(lh1) && isvalid(lh1), delete(lh1);
%     end
% catch
% end
% try
%     if ~isempty(lh2) && isvalid(lh2), delete(lh2);
%     end
% catch
% end

%% Stop context background audio

    if context_flag
        try
            if ~isempty(brown_noise_player) && brown_noise_player.isplaying
                stop(brown_noise_player);
            end
        catch
        end
        try
            if ~isempty(pink_noise_player) && pink_noise_player.isplaying
                stop(pink_noise_player);
            end
        catch
        end
    end



%% Close files
try
    fclose('all');
catch
end

%% GUI status
try
    set(handles2give.OnlineTextTag,'String','Session Stopped','FontWeight','Bold');
catch
end

disp('Session Stopped.')
end