function stop_sessions
%STOP_SESSIONS Terminate DAQ sessions and close files.

global  Reward_S Stim_S Main_S Trigger_S Log_S...
    lh1 lh2 handles2give Stim_S_SR Reward_S_SR folder_name Camera_S...
    pink_noise_player brown_noise_player context_flag WF_S Opto_S

outputSingleScan(Trigger_S,[0 0 1]);
pause(.5)                       %---> why?
outputSingleScan(Trigger_S,[0 0 0]);

%% Stop widefield session
    
Main_S.stop();
while Main_S.IsRunning
    continue
end
Main_S.release();

if handles2give.wf_session  && ~handles2give.opto_session
    wf_stop
end

stop(Camera_S);
while Camera_S.Running
    continue
end

Reward_S.stop();
while Reward_S.IsRunning
    continue
end
Reward_S.release();

Stim_S.stop();
while Stim_S.IsRunning
    continue
end
Stim_S.release();

queueOutputData(Reward_S, zeros(1,Reward_S_SR/2)')

while Reward_S.IsRunning
    continue
end
Reward_S.startBackground();

queueOutputData(Stim_S,[zeros(1,Stim_S_SR/2); zeros(1,Stim_S_SR/2); zeros(1,Stim_S_SR/2); zeros(1,Stim_S_SR/2)]')
Stim_S.prepare(); %optional as per documentation, not sure what is
Stim_S.startBackground();

while ~Stim_S.IsRunning
    continue
end

outputSingleScan(Trigger_S,[1 1 0]);

while Stim_S.ScansQueued==0
    continue
end

Stim_S.stop();
Stim_S.release();

while Reward_S.ScansQueued==0
    continue
end

Reward_S.stop();
Reward_S.release();

outputSingleScan(Trigger_S,[0 0 0]);

if handles2give.opto_session
    save_opto_config
    Opto_S.stop();
    Opto_S.release();
end

Trigger_S.stop();
while Trigger_S.IsRunning
    continue
end
Trigger_S.release();

Log_S.stop();
while Log_S.IsRunning
    continue
end
Log_S.release();

% Delete listeners
delete(lh1);
delete(lh2)

% Stop context background
if context_flag
    if brown_noise_player.isplaying
         stop(brown_noise_player)
    end
    if pink_noise_player.isplaying
         stop(pink_noise_player)
    end
end

% Close all open files
fclose('all');

% Setup with separate session for camera
% cameraClk.stop();

% Save session config post session
set(handles2give.OnlineTextTag,'String', 'Session Stopped', 'FontWeight', 'Bold');

disp('Session Stopped.')

