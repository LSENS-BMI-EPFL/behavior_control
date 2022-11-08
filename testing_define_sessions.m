clear all
clc
% global fid3

%% Create the main control session
Main_Control = daq.createSession('ni');
addAnalogInputChannel(Main_Control,'Dev2','ai0', 'Voltage'); % Reading the Lick signal
Main_Control.Rate = 1000;
Main_Control.IsContinuous = true;
% lh1 = addlistener(Main_Control,'DataAvailable',@main_control);
lh2 = addlistener(Main_Control,'DataAvailable',@PlotLickTrace );
Main_Control.NotifyWhenDataAvailableExceeds=200; % minimum is 50 samples (if sr is 1000) otherwise you get a warning!

%% Create a Trigger session
Trigger = daq.createSession('ni');
addDigitalChannel(Trigger,'Dev2', 'Port0/Line0', 'OutputOnly'); % Trigger signal for trial start
addDigitalChannel(Trigger,'Dev2', 'Port0/Line1', 'OutputOnly'); % Trigger signal for valve-1
Trigger.Rate = 1000;
%% Create a session for triggering valve 1
Valve_1 = daq.createSession('ni');
addAnalogOutputChannel(Valve_1,'Dev2','ao0', 'Voltage'); % Stimulus (coil) channel
addTriggerConnection(Valve_1,'External','Dev2/PFI1','StartTrigger');
Valve_1.Rate = 1000;
Valve_1.TriggersPerRun=1;
Valve_1.ExternalTriggerTimeout =2000;
%% Create a session for the stimulus
Stim_Light = daq.createSession('ni');
addAnalogInputChannel(Stim_Light,'Dev5','ai0', 'Voltage'); % Reading the Lick signal for logging
addAnalogOutputChannel(Stim_Light,'Dev5','ao0', 'Voltage'); % Stimulus (coil) channel
addAnalogOutputChannel(Stim_Light,'Dev5','ao1', 'Voltage'); % Light (laser) channel
addAnalogOutputChannel(Stim_Light,'Dev5','ao2', 'Voltage'); % Cue Channel
addDigitalChannel(Stim_Light,'Dev5', 'Port0/Line0', 'OutputOnly'); %  Camera Channel
addTriggerConnection(Stim_Light,'External','Dev5/PFI10','StartTrigger');
Stim_Light.Rate = 100000;
Stim_Light.ExternalTriggerTimeout =2000;
Stim_Light.TriggersPerRun=1;
%%
Main_Control.startBackground();
trial_number=0;
%%
trial_number=trial_number+1;
fid3=fopen(['D:\Behaviour\VE0\20160212\182157\' num2str(trial_number) '.bin'],'w');
lh3 = addlistener(Stim_Light,'DataAvailable',@(src, event)logData(src, event, fid3) );

Stim_vec=[5*ones(1,40000) zeros(1,60000)];
Reward_vec=[5*ones(1,50) zeros(1,950)];
queueOutputData(Stim_Light,[Stim_vec;Stim_vec;Stim_vec;[ones(1,40000) zeros(1,60000)]]')
queueOutputData(Valve_1,Reward_vec')
%%
Stim_Light.startBackground();
Valve_1.startBackground();
outputSingleScan(Trigger,[0 0])
%%
outputSingleScan(Trigger,[1 1]);
%%
stop(Stim_Light)
% release(Stim_Light)

stop(Valve_1)
% release(Valve_1)

stop(Main_Control)
% release(Main_Control)
%%
fid3=fopen(['D:\Behaviour\Test\20160519\211433\LickTrace3.bin'],'r');
data = fread(fid3,[2,Inf],'double');
fclose(fid3);
t = data(1,:);
ch = data(2,:);
plot(t,ch,'b');
ylim([-.12 .12])