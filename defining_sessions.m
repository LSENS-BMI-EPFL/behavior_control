 function defining_sessions
 % DEFINING_SESSIONS Define sessions for data acquisition.

    %% Define all global variables

    global  Reward_S Stim_S  lick_time  trial_number   ...
        trial_start_time  trial_finished_time    timeout_time ...
        Stimcounter NoStimcounter Trigger_S  Stim_S_SR Main_S...
        lh1 lh2  fid1  Reward_S_SR local_counter lick_channel_times lick_data camera_start_time ...
        folder_name handles2give early_lick_counter session_start_time...
        Main_S_SR Reward_Ch LastTrialFA trial_duration light_counter

    %% Initialize variables

    set(handles2give.OnlineTextTag, 'String', 'Session Started','FontWeight','bold');

    handles2give.ReportPause=1;
    local_counter=0; %for plot_lick_trace
    lick_channel_times=[];
    lick_data=[];
    trial_number=0;
    Stimcounter=0;
    NoStimcounter =0;
    LastTrialFA=0;

    Main_S_SR=1000;
    %Main_S_Ratio=100;
    Main_S_Ratio=10;
    Stim_S_SR=100000;
    Reward_S_SR=2000;
    Trigger_S_SR=1000;
    
    trial_duration=handles2give.TrialDuration; % ms


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

    Main_S = daq.createSession('ni');
    %Main_S = daq('ni');
    %aich1 = addinput(Main_S, 'Dev1',  [0 1 2 3], 'Voltage')
    aich1=addAnalogInputChannel(Main_S, 'Dev1', [0 1 2 3], 'Voltage'); % Reading the Lick signal (Ch0) and copies of trial onset and other stimuli
    aich1(1).TerminalConfig='SingleEnded';
    Main_S.Rate = Main_S_SR;
    Main_S.IsContinuous = true;
    lh1 = addlistener(Main_S,'DataAvailable', @main_control);
    lh2 = addlistener(Main_S,'DataAvailable', @(src, event) plot_lick_trace(src, event, trial_duration));

    % Callback functions to be exectuted
    %Main_S.ScansAvailableFcn = @main_control_daq;
    %Main_S.ScansAvailableFcn = @(src, event) plot_lick_trace(src, event, Trial_Duration);

    % lh3 = addlistener(Main_S,'DataAvailable',@(src, event) log_lick_data); 
    
    % Define count to initiate callback functions
    Main_S.NotifyWhenDataAvailableExceeds=Main_S_SR/Main_S_Ratio; % maximum is 20 hz, so sr should be divided by 20 to not get the reward!
    %Main_S.ScansAvailableFcnCount = Main_S_SR/Main_S_Ratio;

    %% Create trigger session

    Trigger_S = daq.createSession('ni');
    %Trigger_S = daq('ni');
    %addoutput(Trigger_S,'Dev1','port0/line0','Digital'); % Trigger_S signal for stimulus
    %addoutput(Trigger_S,'Dev1','port0/line1','Digital'); % Trigger_S signal for valve-1
    %addoutput(Trigger_S,'Dev1','port0/line2','Digital'); % Trigger_S signal for camera arming 

    addDigitalChannel(Trigger_S,'Dev1', 'Port0/Line0', 'OutputOnly'); % Trigger_S signal for stimulus
    addDigitalChannel(Trigger_S,'Dev1', 'Port0/Line1', 'OutputOnly'); % Trigger_S signal for valve-1
    addDigitalChannel(Trigger_S,'Dev1', 'Port0/Line2', 'OutputOnly'); % Trigger_S signal for camera arming 
    Trigger_S.Rate = Trigger_S_SR;

    %% Create a session Reward

    Reward_S = daq.createSession('ni');
    %Reward_S = daq('ni');

    %addoutput(Reward_S, 'Dev1', 'ao0', 'Voltage');
    Reward_Ch = addAnalogOutputChannel(Reward_S,'Dev1','ao0','Voltage'); % Valve channel
    Reward_Ch.TerminalConfig='SingleEnded';
    
    addTriggerConnection(Reward_S,'External','Dev1/PFI1','StartTrigger'); %Trial start (to check)
    %addtrigger(Reward_S,'Digital','StartTrigger','External','Dev1/PFI1'); % Trial start

    Reward_S.Rate = Reward_S_SR;
    Reward_S.IsContinuous=true;
    Reward_S.NumDigitalTriggersPerRun = 1;
    Reward_S.ExternalTriggerTimeout = 2000;

    %% Create a session for Stimulus/Stimuli

    Stim_S = daq.createSession('ni');
    %Stim_S = daq('ni');

    %aich2 = addinput(Stim_S,'Dev2','ai0','Voltage'); % lick signal for logging
    %aich2.TerminalConfig='SingleEnded';

    %aoch_coil = addoutput(Stim_S,'Dev2','ao0','Voltage'); % whisker stim channel (coil or piezo)
    %aoch_coil.TerminalConfig='SingleEnded';


    %aoch_aud = addoutput(Stim_S,'Dev2','ao1','Voltage'); % auditory stim (tone) channel
    %aoch_aud.TerminalConfig='SingleEnded';
    

    aich2=addAnalogInputChannel(Stim_S,'Dev2','ai0', 'Voltage'); % Reading the Lick signal for logging
    aich2.TerminalConfig='SingleEnded';

    aoch_coil=addAnalogOutputChannel(Stim_S,'Dev2','ao0', 'Voltage'); % Whisker stim (coil/piezo) channel
    aoch_coil.TerminalConfig='SingleEnded';

    aoch_aud=addAnalogOutputChannel(Stim_S,'Dev2','ao1', 'Voltage'); % Auditory  stim (tone) channel
    aoch_aud.TerminalConfig='SingleEnded';

    %addoutput(Stim_S,'Dev2','port0/line0','Digital');
    %addoutput(Stim_S,'Dev2','port0/line1','Digital');

    addDigitalChannel(Stim_S,'Dev2', 'Port0/Line0', 'OutputOnly'); %  Camera Channel
    addDigitalChannel(Stim_S,'Dev2', 'Port0/Line1', 'OutputOnly'); %  ScanImage Trigger Channel (2P-imaging)

    %addtrigger(Stim_S,'Digital','StartTrigger','External','Dev2/PFI0'); 
    addTriggerConnection(Stim_S,'External','Dev2/PFI0','StartTrigger'); 

    Stim_S.Rate = Stim_S_SR;
    Stim_S.IsContinuous=true;
    Stim_S.NumDigitalTriggersPerRun =1;
    Stim_S.ExternalTriggerTimeout = 2000;

    % Setup with Camera session - KEEP
    % %% Create a CameraClK session
    % Camera_S = daq.createSession('ni');
    % cam_ch = addAnalogOutputChannel(Camera_S, 'Dev1', 'ctr0', 'PulseGeneration'); % Camera frames
    % cam_ch.Frequency = handles2give.CameraFrameRate; %Hz
    % cam_ch.DutyCycle = 0.5;

    %% Run the Main Control

    % Set counters
    handles2give.PauseRequested=0;
    light_counter = 0;
    early_lick_counter=0;

    % Update parameters in GUI
    update_parameters; 

    % Set time variables
    camera_start_time=tic;
    session_start_time=tic;
    trial_finished_time=tic;
    trial_start_time=tic;
    lick_time=tic;
    timeout_time=tic;

    % Start acquisition
    Main_S.startBackground(); 
    %start(Main_S, 'Continuous');

end