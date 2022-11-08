function stop_sessions
%% Stopping all sessions and deleting all listeners and close the open log files
global  Reward_S Stim_S Main_S Trigger_S...
    lh1 lh2 lh3 handles2give Stim_S_SR Reward_S_SR cameraClk


outputSingleScan(Trigger_S,[0 0 1])
pause(.5)
outputSingleScan(Trigger_S,[0 0 0]);
    
Main_S.stop();
while Main_S.IsRunning
    continue
end
Main_S.release();


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

queueOutputData(Reward_S,zeros(1,Reward_S_SR/2)')

while Reward_S.IsRunning
    continue
end
Reward_S.startBackground();

queueOutputData(Stim_S,[zeros(1,Stim_S_SR/2); zeros(1,Stim_S_SR/2); zeros(1,Stim_S_SR/2); zeros(1,Stim_S_SR/2)]')
Stim_S.prepare();
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


Trigger_S.stop();
while Trigger_S.IsRunning
    continue
end
Trigger_S.release();


delete(lh1);
delete(lh2);
delete(lh3);
fclose('all');

% Axel's setup
% cameraClk.stop();


set(handles2give.OnlineTextTag,'String','Session Stopped');

