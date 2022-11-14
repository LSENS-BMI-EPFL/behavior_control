function stop_sessions
%STOP_SESSIONS Terminate DAQ sessions and close files.

global  Reward_S Stim_S Main_S Trigger_S ...
    lh1 lh2 lh3 handles2give Stim_S_SR Reward_S_SR


%outputSingleScan(Trigger_S,[0 0 1])
write(Trigger_S, [0 0 1]);
pause(.5)                       %---> why?
%outputSingleScan(Trigger_S,[0 0 0]);
write(Trigger_S, [0 0 0]);
    
%Main_S.stop();
stop(Main_S);
while Main_S.Running
    continue
end
%Main_S.release();
flush(Main_S);

%Reward_S.stop();
stop(Reward_S);
while Reward_S.Running
    continue
end
flush(Reward_S);
%Reward_S.release();

%Stim_S.stop();
stop(Stim_S);
while Stim_S.Running
    continue
end
flush(Stim_S);
%Stim_S.release();

%queueOutputData(Reward_S, zeros(1,Reward_S_SR/2)')
preload(Reward_S, zeros(1,Reward_S_SR/2))

while Reward_S.Running
    continue
end
start(Reward_S, 'Continuous');
%Reward_S.startBackground();

preload(Stim_S, [zeros(1,Stim_S_SR/2); zeros(1,Stim_S_SR/2); zeros(1,Stim_S_SR/2); zeros(1,Stim_S_SR/2)]')
%queueOutputData(Stim_S,[zeros(1,Stim_S_SR/2); zeros(1,Stim_S_SR/2); zeros(1,Stim_S_SR/2); zeros(1,Stim_S_SR/2)]')
%Stim_S.prepare(); %optional as per documentation, not sure what is
%replacement
%Stim_S.startBackground();
start(Stim_S, 'Continuous');

while ~Stim_S.Running
    continue
end

%outputSingleScan(Trigger_S,[1 1 0]);
write(Trigger_S, [1 1 0]);

while Stim_S.ScansQueued==0
    continue
end

%Stim_S.stop();
stop(Stim_S);
%Stim_S.release();
flush(Stim_S);

while Reward_S.ScansQueued==0
    continue
end

%Reward_S.stop();
stop(Reward_S);
%Reward_S.release();
flush(Reward_S);
%outputSingleScan(Trigger_S,[0 0 0]);
write(Trigger_S, [0 0 0]);

%Trigger_S.stop();
stop(Trigger_S);
while Trigger_S.Running
    continue
end
%Trigger_S.release();
flush(Trigger_S);


% Delete listeners (maybe useless with new DAQ- to REMOVE?)
%delete(lh1);
%delete(lh2);
%delete(lh3);

% Close all open files
fclose('all');

% Axel's setup
% cameraClk.stop();
% stop(Camera_S);


set(handles2give.OnlineTextTag,'String','Session Stopped');

