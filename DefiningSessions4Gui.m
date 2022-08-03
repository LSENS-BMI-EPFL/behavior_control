 function DefiningSessions4Gui

%% Define all global variables

global  Reward_S Stim_S  LickTime  trial_number   ...
    TrialTime  TrialFinished    TimeOut ...
    Stimcounter NoStimcounter Trigger_S  Stim_S_SR Main_S...
    lh1 lh2  fid1  Reward_S_SR LocalCounter Times Data cameraStartTime ...
    folder_name handles2give EarlylickCounter SessionStart cameraClk...
    Main_S_SR Reward_Ch LastTrialFA lh3 Trial_Duration LightCounter

%% Initialize variables

set(handles2give.OnlineTextTag, 'String', 'Session Started','FontWeight','bold');

handles2give.ReportPause=1;
LocalCounter=0;
Times=[];
Data=[];
trial_number=0;
Stimcounter=0;
NoStimcounter =0;
LastTrialFA=0;

Main_S_SR=1000;
Main_S_Ratio=100;
Stim_S_SR=100000;
Reward_S_SR=2000;
Trigger_S_SR=1000;
Trial_Duration=handles2give.TrialDuration; % ms


%% Create and open log files
folder_name=[char(handles2give.BehaviorDirectory) '\' char(handles2give.MouseName) ...
    '\' [char(handles2give.MouseName) '_' char(handles2give.Date) '_' char(handles2give.FolderName)]]; % Folder to behaviour data output


fid1=fopen([folder_name '\Results.txt'], 'w'); % Results file for session
fprintf(fid1,'%5s %15s %15s %7s %15s %14s %16s %16s %7s %8s %15s %12s %12s %13s %13s %13s %13s %15s %15s %15s %15s %15s %15s %15s %15s \n',...
    'trial_number','WhStimDuration','Quietwindow','ITI', 'Association',...
    'Stim/NoStim', 'Whisker/NoWhisker', 'Auditory/NoAuditory','Lick',...
    'perf','Light/NoLight','ReactionTime' ,'WhStimAmp','TrialTime',...
    'Rew/NoRew','AudRew','WhRew','AudDur','AudDAmp','AudFreq', ...
    'EarlyLick','LightAmp','LightDur','LightFreq','LightPreStim');

% --- CREATE SESSIONS --- % This could be updated with new MATLAB command
% as of 2020
% This must be changed based on setup connections.
%
%% Create main control session

Main_S = daq.createSession('ni');
aich1=addAnalogInputChannel(Main_S,'Dev1',[0 1 2 3], 'Voltage'); % Reading the Lick signal (Ch0) and copies of trial onset and other stimuli
aich1(1).TerminalConfig='SingleEnded';
Main_S.Rate = Main_S_SR;
Main_S.IsContinuous = true;
lh1 = addlistener(Main_S,'DataAvailable', @MainControl4Gui);
lh2 = addlistener(Main_S,'DataAvailable', @(src, event) PlotLickTraceNew(src, event, Trial_Duration));
% lh3 = addlistener(Main_S,'DataAvailable',@(src, event)logLickData ); 
Main_S.NotifyWhenDataAvailableExceeds=Main_S_SR/Main_S_Ratio; % maximum is 20 hz, so sr should be divided by 20 to not get the reward!

%% Create trigger session

Trigger_S = daq.createSession('ni');
addDigitalChannel(Trigger_S,'Dev1', 'Port0/Line0', 'OutputOnly'); % Trigger_S signal for stimulus
addDigitalChannel(Trigger_S,'Dev1', 'Port0/Line1', 'OutputOnly'); % Trigger_S signal for valve-1
addDigitalChannel(Trigger_S,'Dev1', 'Port0/Line2', 'OutputOnly'); % Trigger_S signal for camera arming 
Trigger_S.Rate = Trigger_S_SR;

%% Create a session Reward

Reward_S = daq.createSession('ni');
Reward_Ch = addAnalogOutputChannel(Reward_S,'Dev1','ao0','Voltage'); % Valve channel
Reward_Ch.TerminalConfig='SingleEnded';
addTriggerConnection(Reward_S,'External','Dev1/PFI1','StartTrigger'); %Trial start (to check)

Reward_S.Rate = Reward_S_SR;
Reward_S.IsContinuous=true;
Reward_S.TriggersPerRun=1;
Reward_S.ExternalTriggerTimeout = 2000;

%% Create a session for Stimulus/Stimuli

Stim_S = daq.createSession('ni');
aich2=addAnalogInputChannel(Stim_S,'PXI1Slot2','ai0', 'Voltage'); % Reading the Lick signal for logging
aich2.TerminalConfig='SingleEnded';

aoch_coil=addAnalogOutputChannel(Stim_S,'PXI1Slot2','ao0', 'Voltage'); % Whisker stim (coil/piezo) channel
aoch_coil.TerminalConfig='SingleEnded';

aoch_aud=addAnalogOutputChannel(Stim_S,'PXI1Slot2','ao1', 'Voltage'); % Auditory  stim (tone) channel
aoch_aud.TerminalConfig='SingleEnded';

% Not the right output channel. Just two on that device. Use Dev 3.
% aoch_light=addAnalogOutputChannel(Stim_S,'PXI1Slot2','ao2', 'Voltage'); % Light (laser) channel for optogenetics
% aoch_light.TerminalConfig='SingleEnded';

% --- What is this for? ---
% aoch_cue=addAnalogOutputChannel(Stim_S,'PXI1Slot2','ao2', 'Voltage'); % Cue Channel %
% aoch_cue.TerminalConfig='SingleEnded';
% aoch_cam=addAnalogOutputChannel(Stim_S,'PXI1Slot2','ao3', 'Voltage'); % Camera Channel
% aoch_cam.TerminalConfig='SingleEnded';

addDigitalChannel(Stim_S,'PXI1Slot2', 'Port0/Line0', 'OutputOnly'); %  Camera Channel
addDigitalChannel(Stim_S,'PXI1Slot2', 'Port0/Line1', 'OutputOnly'); %  ScanImage Trigger Channel (2P-imaging)

addTriggerConnection(Stim_S,'External','PXI1Slot2/PFI0','StartTrigger'); 

Stim_S.Rate = Stim_S_SR;
Stim_S.IsContinuous=true;
Stim_S.TriggersPerRun=1;
Stim_S.ExternalTriggerTimeout = 2000;

% Axel's setup.
% %% Create a CameraClK session
% cameraClk = daq.createSession('ni');
% 
% ch = addCounterOutputChannel(cameraClk, 'Dev1', 'ctr0', 'PulseGeneration'); % Behaviour camera
% ch.Frequency = handles2give.CameraFrameRate; % Hz
% ch.DutyCycle = 0.5;
% cameraClk.IsContinuous = true;

%% Run the Main Control

% Set counters
handles2give.PauseRequested=0;
LightCounter = 0;
EarlylickCounter=0;

% Update parameters in GUI
UpdateParameters4Gui; 

% Set time variables
cameraStartTime=tic;
SessionStart=tic;
TrialFinished=tic;
TrialTime=tic;
LickTime=tic;
TimeOut=tic;

% Start acquisition
Main_S.startBackground(); 

end