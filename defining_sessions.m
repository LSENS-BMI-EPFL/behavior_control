 function defining_sessions

    %% Define all global variables

    global  Reward_S Stim_S  LickTime  trial_number   ...
        TrialTime  TrialFinished    TimeOut ...
        Stimcounter NoStimcounter Trigger_S  Stim_S_SR Main_S...
        lh1 lh2  fid1  Reward_S_SR LocalCounter Times Data cameraStartTime ...
        folder_name handles2give EarlylickCounter SessionStart...
        Main_S_SR Reward_Ch LastTrialFA Trial_Duration LightCounter

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


    fid1=fopen([folder_name '\Results.txt'], 'wt'); % Results file for session
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

    %Main_S = daq.createSession('ni');
    Main_S = daq('ni');
    aich1 = addinput(Main_S, 'Dev1',  [0 1 2 3], 'Voltage')
    %aich1=addAnalogInputChannel(Main_S,'Dev1', [0 1 2 3], 'Voltage'); % Reading the Lick signal (Ch0) and copies of trial onset and other stimuli
    aich1(1).TerminalConfig='SingleEnded';
    Main_S.Rate = Main_S_SR;
    %Main_S.IsContinuous = true;

    % Callback functions to be exectuted
    Main_S.ScansAvailableFcn = @main_control;
    Main_S.ScansAvailableFcn = @(src, event) plot_lick_trace(src, event, Trial_Duration));

    %lh1 = addlistener(Main_S,'DataAvailable', @main_control);
    %lh2 = addlistener(Main_S,'DataAvailable', @(src, event) PlotLickTraceNew(src, event, Trial_Duration));
    % lh3 = addlistener(Main_S,'DataAvailable',@(src, event)log_lick_data ); 
    %Main_S.NotifyWhenDataAvailableExceeds=Main_S_SR/Main_S_Ratio; % maximum is 20 hz, so sr should be divided by 20 to not get the reward!
    % Define count to initiate callback functions
    Main_S.ScansAvailableFcnCount = Main_S_SR/Main_S_Ratio;

    %% Create trigger session

    %Trigger_S = daq.createSession('ni');
    Trigger_S = daq('ni');
    addoutput(Trigger_S,'Dev1','port0/line1','Digital'); % Trigger_S signal for stimulus
    addoutput(Trigger_S,'Dev1','port0/line1','Digital'); % Trigger_S signal for valve-1
    addoutput(Trigger_S,'Dev1','port0/line1','Digital'); % Trigger_S signal for camera arming 

    %addDigitalChannel(Trigger_S,'Dev1', 'Port0/Line0', 'OutputOnly'); % Trigger_S signal for stimulus
    %addDigitalChannel(Trigger_S,'Dev1', 'Port0/Line1', 'OutputOnly'); % Trigger_S signal for valve-1
    %addDigitalChannel(Trigger_S,'Dev1', 'Port0/Line2', 'OutputOnly'); % Trigger_S signal for camera arming 
    Trigger_S.Rate = Trigger_S_SR;

    %% Create a session Reward

    Reward_S = daq.createSession('ni');
    Reward_S = daq('ni');

    addoutput(Reward_S, 'Dev1', 'ao0', 'Voltage');
    %Reward_Ch = addAnalogOutputChannel(Reward_S,'Dev1','ao0','Voltage'); % Valve channel
    Reward_Ch.TerminalConfig='SingleEnded';
    
    %addTriggerConnection(Reward_S,'External','Dev1/PFI1','StartTrigger'); %Trial start (to check)
    addtrigger(Reward_S,'Digital','StartTrigger','External','Dev1/PFI1'); % Trial start

    Reward_S.Rate = Reward_S_SR;
    %Reward_S.IsContinuous=true;
    Reward_S.NumDigitalTriggersPerRun = 1;
    %Reward_S.ExternalTriggerTimeout = 2000;

    %% Create a session for Stimulus/Stimuli

    %Stim_S = daq.createSession('ni');
    Stim_S = daq('ni');

    aich2 = addinput(Stim_S,'Dev2','ai0','Voltage'); % lick signal for logging
    aich2.TerminalConfig='SingleEnded';

    aoch_coil = addouput(Stim_S,'Dev2','ao0','Voltage'); % whisker stim channel (coil or piezo)
    aoch_coil.TerminalConfig='SingleEnded';


    aoch_aud = addouput(Stim_S,'Dev2','ao1','Voltage'); % auditory stim (tone) channel
    aoch_aud.TerminalConfig='SingleEnded';
    

    %aich2=addAnalogInputChannel(Stim_S,'Dev2','ai0', 'Voltage'); % Reading the Lick signal for logging
    %aich2.TerminalConfig='SingleEnded';

    %aoch_coil=addAnalogOutputChannel(Stim_S,'Dev2','ao0', 'Voltage'); % Whisker stim (coil/piezo) channel
    %aoch_coil.TerminalConfig='SingleEnded';

    %aoch_aud=addAnalogOutputChannel(Stim_S,'Dev2','ao1', 'Voltage'); % Auditory  stim (tone) channel
    %aoch_aud.TerminalConfig='SingleEnded';

    addoutput(Stim_S,'Dev2','port0/line0','Digital');
    addoutput(Stim_S,'Dev2','port0/line1','Digital');

    %addDigitalChannel(Stim_S,'Dev2', 'Port0/Line0', 'OutputOnly'); %  Camera Channel
    %addDigitalChannel(Stim_S,'Dev2', 'Port0/Line1', 'OutputOnly'); %  ScanImage Trigger Channel (2P-imaging)

    addtrigger(Stim_S,'Digital','StartTrigger','External','Dev2/PFI0'); 
    %addTriggerConnection(Stim_S,'External','Dev2/PFI0','StartTrigger'); 

    Stim_S.Rate = Stim_S_SR;
    %Stim_S.IsContinuous=true;
    Stim_S.NumDigitalTriggersPerRun =1;
    %Stim_S.ExternalTriggerTimeout = 2000;

    % Axel's setup.
    % %% Create a CameraClK session
    % Camera_S = daq('ni');
    % cam_ch = addoutput(Camera_S, 'Dev1', 'ctr0', 'PulseGeneration'); % Camera frames
    % cam_ch.Frequency = handles2give.CameraFrameRate; %Hz
    % cam_ch.DutyCycle = 0.5;

    %% Run the Main Control

    % Set counters
    handles2give.PauseRequested=0;
    LightCounter = 0;
    EarlylickCounter=0;

    % Update parameters in GUI
    update_parameters; 

    % Set time variables
    cameraStartTime=tic;
    SessionStart=tic;
    TrialFinished=tic;
    TrialTime=tic;
    LickTime=tic;
    TimeOut=tic;

    % Start acquisition
    %Main_S.startBackground(); 
    start(Main_S, 'Continuous');

end