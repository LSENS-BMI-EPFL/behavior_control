 function defining_sessions
 % DEFINING_SESSIONS Define sessions for data acquisition.

    % Define all global variables

    global  Reward_S Stim_S Log_S association_flag lick_time  trial_number   ...
        trial_start_time  trial_end_time  timeout_time ...
        Trigger_S  Stim_S_SR Main_S Log_S_SR...
        lh1 lh2 Reward_S_SR local_counter lick_channel_times camera_start_time ...
        folder_name handles2give early_lick_counter session_start_time...
        Main_S_SR Reward_Ch light_counter whisker_trial_counter...
        fid_continuous trial_start_ttl lick_data cam1_ttl cam2_ttl scan_pos...
        continuous_lick_data Camera_S Context_S context_ttl WF_S Opto_S passive_trial_counter 
        


    % Initialize variables and result file
    % ------------------------------------

    set(handles2give.OnlineTextTag, 'String', 'Session Started','FontWeight','bold');

    handles2give.ReportPause = 1;
  
    % Sampling rates
    Main_S_SR = 1000;
    Main_S_frq = 100;
    Stim_S_SR = 100000;
    Reward_S_SR = 1000;
    Trigger_S_SR = 1000;
    Log_S_SR = 5000;

    % Initialized variables for continuous plotting with zeros.
    trial_start_ttl = zeros(1,10*Log_S_SR);
    continuous_lick_data = zeros(1,10*Log_S_SR);
    cam1_ttl = zeros(1,10*Log_S_SR);
    cam2_ttl = zeros(1,10*Log_S_SR);
    scan_pos = zeros(1,10*Log_S_SR);
    context_ttl =  zeros(1,10*Log_S_SR);
    
    % Folder to behaviour data output
    folder_name=[char(handles2give.behaviour_directory) '\' char(handles2give.mouse_name) ...
        '\' [char(handles2give.mouse_name) '_' char(handles2give.date) '_' char(handles2give.session_time)]];
    
    % Create sessions
    % ---------------

    % This must be edited based on setup connections.
    

    % Create main control session

    Main_S = daq.createSession('ni');
    aich1=addAnalogInputChannel(Main_S, 'Dev1', 0, 'Voltage');
    aich1(1).TerminalConfig='SingleEnded';
    Main_S.Rate = Main_S_SR;
    Main_S.IsContinuous = true;
    lh1 = addlistener(Main_S,'DataAvailable', @main_control);
    % Number of available scans needed to trigger main_control
    % callback. Determines at which frequency licks are detected.
    Main_S.NotifyWhenDataAvailableExceeds = Main_S_SR/Main_S_frq;


    % Create logging session

    Log_S = daq.createSession('ni');

    % ai0: lick
    % ai1: galvo scanner position
    % ai2: trial start ttl
    % ai3: camera 1
    % ai4: camera 2
    % ai5: context transition
    
    ai_log = addAnalogInputChannel(Log_S, 'Dev2', [0,1,2,3,4, 5], 'Voltage');
    ai_log(1).TerminalConfig='SingleEnded';
    ai_log(2).TerminalConfig='SingleEnded';
    ai_log(3).TerminalConfig='SingleEnded';
    ai_log(4).TerminalConfig='SingleEnded';
    ai_log(5).TerminalConfig='SingleEnded';
    ai_log(6).TerminalConfig='SingleEnded';
    Log_S.Rate = Log_S_SR;
    Log_S.IsContinuous = true;
    lh2 = addlistener(Log_S,'DataAvailable', @(src, event) log_continuously(src, event));
    fid_continuous = fopen([folder_name '\log_continuous.bin'], 'a');
    
    % Create trigger session

    Trigger_S = daq.createSession('ni');
   
    addDigitalChannel(Trigger_S,'Dev1', 'Port0/Line0', 'OutputOnly'); % Trigger_S signal for stimulus
    addDigitalChannel(Trigger_S,'Dev1', 'Port0/Line1', 'OutputOnly'); % Trigger_S signal for valve-1
    addDigitalChannel(Trigger_S,'Dev1', 'Port0/Line2', 'OutputOnly'); % Trigger_S signal for camera arming 
    Trigger_S.Rate = Trigger_S_SR;

    
    % Create a session Reward

    Reward_S = daq.createSession('ni');
    Reward_Ch = addAnalogOutputChannel(Reward_S,'Dev1','ao0','Voltage');  % Valve channel
    Reward_Ch.TerminalConfig='SingleEnded';
    
    addTriggerConnection(Reward_S,'External','Dev1/PFI1','StartTrigger');  % Trigger from reward_delivery

    Reward_S.Rate = Reward_S_SR;
    Reward_S.IsContinuous=true;
    Reward_S.TriggersPerRun = 1;
    Reward_S.ExternalTriggerTimeout = 2000; %sec

    
    % Create a session for Stimulus/Stimuli

    Stim_S = daq.createSession('ni');

    aoch_coil=addAnalogOutputChannel(Stim_S,'Dev2','ao0', 'Voltage'); % Whisker stim (coil/piezo) channel
    aoch_coil.TerminalConfig='SingleEnded';

    aoch_aud=addAnalogOutputChannel(Stim_S,'Dev2','ao1', 'Voltage'); % Auditory  stim (tone) channel
    aoch_aud.TerminalConfig='SingleEnded';

    addDigitalChannel(Stim_S,'Dev2', 'Port0/Line0', 'OutputOnly'); %  Camera Channel
    addDigitalChannel(Stim_S,'Dev2', 'Port0/Line1', 'OutputOnly'); %  ScanImage Trigger Channel (2P-imaging)

    addTriggerConnection(Stim_S,'External','Dev2/PFI0','StartTrigger');

    Stim_S.Rate = Stim_S_SR;
    Stim_S.IsContinuous = true;
    Stim_S.TriggersPerRun = 1;
    Stim_S.ExternalTriggerTimeout = 2000;


    % Create a Camera Continuous recording session

    Camera_S = daq('ni');
    Camera_S.Rate = 5000;
    cam_ch = addoutput(Camera_S, 'Dev1', 'ctr0', 'PulseGeneration'); % Camera frames
    cam_ch.Frequency = handles2give.camera_freq; %Hz
    cam_ch.DutyCycle = (handles2give.camera_exposure_time / 1000 ) / (1 / cam_ch.Frequency);
    cam_ch.InitialDelay = handles2give.camera_start_delay;
    
    % Session for context block switch output
    Context_S = daq.createSession('ni');
    addDigitalChannel(Context_S,'Dev2', 'Port0/Line2', 'OutputOnly'); %  Context channel

    % Setup Opto_S with trigger, if applicable
    if handles2give.opto_session && ~handles2give.wf_session
        global Opto_info Opto_S
        opto_setup(1);
    
    % Setup WF_S and start continuous WF imaging, if applicable
    elseif handles2give.wf_session && ~handles2give.opto_session
        global WF_FileInfo % Generated in WF_GUI
        addpath([fileparts(cd) '\WF_imaging\'])
        if WF_FileInfo.RecordingContinuous
            wf_setup  
        else
            wf_setup(1)
        end
    
    % Setup WF_S + Opto_S in Grid_S for combined imaging and opto
    elseif handles2give.wf_session && handles2give.opto_session
        global WF_FileInfo Opto_info
        opto_wf_setup();

    end

    
    % Run Main Control
    % ----------------

    % Set counters
    handles2give.PauseRequested=0;
    trial_number = 0;
    light_counter = 0;
    early_lick_counter = 0;
    local_counter = 0; % for plot_lick_trace
    whisker_trial_counter = 0; %for partial rewards
    passive_trial_counter = 0;
 
    % Update parameters in GUI
    update_parameters;

    % Set time variables
    camera_start_time = tic;
    session_start_time = tic;
    trial_end_time = tic;
    trial_start_time = tic;
    lick_time = tic;
    timeout_time = tic;

    % Start acquisition
    Main_S.startBackground();
    Log_S.startBackground();
    start(Camera_S, "Continuous")

    if handles2give.wf_session
        if WF_FileInfo.RecordingContinuous
            wf_imaging_continuous
        end
    end
    
end
