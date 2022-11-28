 function defining_sessions
 % DEFINING_SESSIONS Define sessions for data acquisition.

    %% Define all global variables

    global  Reward_S Stim_S association_flag lick_time  trial_number   ...
        trial_start_time  trial_end_time  timeout_time ...
        Trigger_S  Stim_S_SR Main_S...
        lh1 lh2  fid1  Reward_S_SR local_counter lick_channel_times lick_data camera_start_time ...
        folder_name handles2give early_lick_counter session_start_time...
        Main_S_SR Reward_Ch trial_duration light_counter

    %% Initialize variables

    set(handles2give.OnlineTextTag, 'String', 'Session Started','FontWeight','bold');

    handles2give.ReportPause=1;
    local_counter=0; %for plot_lick_trace
    lick_channel_times=[];
    lick_data=[];
    trial_number=0;

    % Sampling rates
    Main_S_SR=1000;
    Main_S_Ratio=100;
    Stim_S_SR=100000;
    Reward_S_SR=2000;
    Trigger_S_SR=1000;
    
    trial_duration=handles2give.TrialDuration; % ms
    

    %% Create and open session results file

    folder_name=[char(handles2give.behavior_directory) '\' char(handles2give.mouse_name) ...
        '\' [char(handles2give.mouse_name) '_' char(handles2give.date) '_' char(handles2give.session_time)]]; % Folder to behaviour data output

    fid1=fopen([folder_name '\results.txt'], 'w'); 
    
    % Define saved columns 
    fprintf(fid1,'%5s %5s %5s %5s %5s %5s %5s %5s %5s %5s %5s %5s %5s %5s %5s %5s %5s %5s %5s %5s %5s %5s %5s %5s %5s \n', ...
    'trial_number', 'perf', 'trial_time', 'association_flag', 'quiet_window','iti', ...
         'is_stim', 'is_whisker', 'is_auditory', 'lick_flag', 'reaction_time', ...
        'wh_stim_duration', 'wh_stim_amp', 'wh_reward', ...
        'is_reward', ...
        'aud_stim_duration','aud_stim_amp','aud_stim_freq','aud_reward', ...
        'early_lick', ...
        'is_light_stim', 'light_amp','light_duration','light_freq','light_prestim');
    
    
%     % Make session results table
%     fid_results = fopen([folder_name '\results.csv'], 'w'); % results file for session
%     results_table = table(trial_number, trial_start_time, association_flag, quiet_window, iti, perf, ...
%                 is_stim, is_whisker, is_auditory, lick_flag, reaction_time, ...
%                 wh_stim_duration, wh_stim_amp, wh_reward, ...
%                 is_reward, ...
%                 aud_stim_duration,aud_stim_amp,aud_stim_freq,aud_reward, ...
%                 early_lick', ...
%                 is_light_stim', light_amp,light_duration,light_freq,light_prestim);
%     writetable(results_table, fid_results, 'Delimiter', ',', 'QuoteStrings', false);

    % --- CREATE SESSIONS --- 
    % This must be edited based on setup connections.
    
    %% Create main control session

    Main_S = daq.createSession('ni');
    aich1=addAnalogInputChannel(Main_S, 'Dev1', [0 1 2 3], 'Voltage'); % Reading the Lick signal (Ch0) and copies of trial onset and other stimuli
    aich1(1).TerminalConfig='SingleEnded';
    Main_S.Rate = Main_S_SR;
    Main_S.IsContinuous = true;
    lh1 = addlistener(Main_S,'DataAvailable', @main_control);
    lh2 = addlistener(Main_S,'DataAvailable', @(src, event) plot_lick_trace(src, event, trial_duration));

  
    % lh3 = addlistener(Main_S,'DataAvailable',@(src, event) log_lick_data); 
    
    % Define count to initiate callback functions
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
    Reward_S.TriggersPerRun = 1;
    Reward_S.ExternalTriggerTimeout = 2000;

    %% Create a session for Stimulus/Stimuli

    Stim_S = daq.createSession('ni');
    
    aich2=addAnalogInputChannel(Stim_S,'Dev2','ai0', 'Voltage'); % Reading the Lick signal for logging
    aich2.TerminalConfig='SingleEnded';

    aoch_coil=addAnalogOutputChannel(Stim_S,'Dev2','ao0', 'Voltage'); % Whisker stim (coil/piezo) channel
    aoch_coil.TerminalConfig='SingleEnded';

    aoch_aud=addAnalogOutputChannel(Stim_S,'Dev2','ao1', 'Voltage'); % Auditory  stim (tone) channel
    aoch_aud.TerminalConfig='SingleEnded';

    addDigitalChannel(Stim_S,'Dev2', 'Port0/Line0', 'OutputOnly'); %  Camera Channel
    addDigitalChannel(Stim_S,'Dev2', 'Port0/Line1', 'OutputOnly'); %  ScanImage Trigger Channel (2P-imaging)

    addTriggerConnection(Stim_S,'External','Dev2/PFI0','StartTrigger'); 

    Stim_S.Rate = Stim_S_SR;
    Stim_S.IsContinuous=true;
    Stim_S.TriggersPerRun =1;
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
    trial_end_time=tic;
    trial_start_time=tic;
    lick_time=tic;
    timeout_time=tic;

    % Start acquisition
    Main_S.startBackground(); 

end