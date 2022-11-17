function update_parameters
% UPDATE_PARAMETERS Update parameters at each trial.

    global    association_flag response_window trial_duration quiet_window lick_treshold...
        artifact_window iti camera_flag is_stim is_auditory is_whisker is_light_stim ...
        reward_valve_duration  aud_reward wh_reward wh_vec aud_vec light_vec ...
        light_prestim stim_flag ...
        timeout_early_lick stim_counter ...
        no_stim_counter Stim_S wh_stim_duration  aud_stim_duration  aud_stim_amp  aud_stim_freq  Stim_S_SR ScansTobeAcquired ...
        Reward_S Reward_S_SR  Trigger_S fid3 mouse_licked_flag reaction_time ...
        trial_started_flag  trial_number light_proba_old folder_name handles2give stim_pool...
        stim_proba_old aud_stim_proba_old wh_stim_proba_old aud_light_proba_old wh_light_proba_old light_flag baseline_window camera_vec...
        deliver_reward_flag early_lick_counter...
        wh_stim_amp response_window_start response_window_end...
        perf_and_save_results_flag lh3 reward_delivered_flag update_parameters_flag...
        is_reward reward_pool partial_reward_flag reward_proba_old fa_timeout last_trial_fa...
        stim_index_pool pool_size light_duration light_freq light_amp camera_freq SITrigger_vec main_trial_pool trial_lick_data...
       

    %outputSingleScan(Trigger_S,[0 0 0])
    write(Trigger_S, [0 0 0]);
    pause(.5)
    %outputSingleScan(Trigger_S,[0 0 0])
    write(Trigger_S, [0 0 0]);
    
    % Light parameters DELETE?
    ramp_down_duration=100; % in miliseconds
    light_amp = handles2give.LightAmp;
    light_prestim = handles2give.LightPrestimDelay;

    LightDurations=[light_amp]+ramp_down_duration;
    LightPreStims=[light_prestim];
    light_duration = handles2give.LightDuration;

    % Trial pool
    n_pool=10; % Making the Stim/NoStim and Durations pool
    camera_block_duration = 300; % in seconds (added for continuous filming)

    trial_number = trial_number+1;

    fa_timeout=10000; %in ms 

    %% Update Video Parameters and Arm the Camera

    camera_flag = handles2give.CameraFlag;

    % SAVING CAMERA FRAMES
    % if CameraFlag && (trial_number==1 || toc(cameraStartTime)>Block_Duration)
    if camera_flag
        camera_freq=handles2give.CameraFrameRate; % Hz

        VideoFileInfo.trial_number=trial_number;

        % TODO: remove hard coded basename - > ADD in GUI like for Results
        VideoFileInfo.directory=['D:\AR\' char(handles2give.MouseName)...
            '\' [char(handles2give.MouseName) '_' char(handles2give.Date) '_' char(handles2give.FolderName) '\']];

        % Define number of frames to save in block
        VideoFileInfo.nOfFramesToGrab = trial_duration*camera_freq/1000;
        %VideoFileInfo.nOfFramesToGrab =
        %camera_block_duration*camera_freq/1000; %KEEP

        save('D:\Behavior\TemplateConfigFile\VideoFileInfo','VideoFileInfo');
        arm_camera()

    % TO KEEP - Block design of camera acquisition
    %     if trial_number~=1
    %         cameraClk.stop()
    %         pause(0.05)
    %         cameraClk.release()
    %     end
    %
    %     outputSingleScan(Trigger_S,[0 0 1])
    %     pause(5)
    %     outputSingleScan(Trigger_S,[0 0 0])
    %
    %     cameraClk.startBackground()
    %     pause(3)
    %     cameraStartTime=tic;


    % NOT SAVING CAMERA FRAMES
    % else
    %     outputSingleScan(Trigger_S,[0 0 0])
    end

    %% GENERAL SETTINGS FROM BEHAVIOUR GUI

    association_flag=handles2give.AssociationFlag; % 0 detection 1 assosiation
    light_flag=handles2give.LightFlag;

    % Camera settings
    camera_freq=handles2give.CameraFrameRate; % Hz
    camera_duty_cycle=0.5;
    
    trial_duration=handles2give.TrialDuration; % ms

    % Lick sensor threshold
    lick_treshold=handles2give.LickThreshold; %in volts

    % Trial timeline settings
    min_quiet_window = handles2give.MinQuietWindow; % in miliseconds
    max_quiet_window = handles2give.MaxQuietWindow; % in miliseconds
    quiet_window=randsample(min_quiet_window:.1:max_quiet_window,1);

    % Quietwindow = handles2give.QuietWindow; % in miliseconds
    response_window=handles2give.ResponseWindow; % in miliseconds
    artifact_window=handles2give.ArtifactWindow; % in miliseconds
    baseline_window=handles2give.BaselineWindow; % in miliseconds

    min_iti=handles2give.MinISI; % InterStimInterval in miliseconds (min)
    max_iti=handles2give.MaxISI; % InterStimInterval in miliseconds (max)

    % Limiting number of similar trials (stim/nostim) in raw
    max_stim_trials_flag=handles2give.MaxTrialsInRowFlag; % 0 totaly random, 1 the limit will apply
    max_stim_trials_number=handles2give.MaxTrialsInRow;

    timeout_early_lick=handles2give.EarlyLickTimeOut; % in milliseconds in case of early lick

    % Whisker and Auditory Stim parameters
    wh_stim_amp_list= handles2give.StimAmp(1:handles2give.NumStim); % in volts
    Stim_Weights= handles2give.StimWeight(1:handles2give.NumStim);
    Astim_Amp =  handles2give.ToneAmp;
    Astim_Dur = handles2give.ToneDuration;
    Astim_Freq = handles2give.ToneFreq;
    aud_stim_weight = handles2give.AStimWeight;
    wh_stim_weight = handles2give.StimWeight(1);
    aud_stim_duration = Astim_Dur;
    aud_stim_amp = Astim_Amp;
    aud_stim_freq = Astim_Freq;
    no_stim_weight=handles2give.NostimWeight;
    wh_stim_duration_list= handles2give.StimDuration(1:handles2give.NumStim);  % in miliseconds
    

    %% Compute stimulus probability
    stim_proba = (aud_stim_weight + wh_stim_weight)/(aud_stim_weight + wh_stim_weight + no_stim_weight);
    if trial_number == 1
        stim_proba_old = stim_proba;
    end

    aud_stim_proba = (aud_stim_weight)/(aud_stim_weight + wh_stim_weight + no_stim_weight);
    if trial_number == 1
        aud_stim_proba_old = aud_stim_proba;
    end

    wh_stim_proba = (wh_stim_weight)/(aud_stim_weight + wh_stim_weight + no_stim_weight);
    if trial_number == 1
        wh_stim_proba_old = wh_stim_proba;
    end


    %% Light probability and light parameters
    light_proba=handles2give.LightProb; % proportion of light trials
    if isempty(light_proba_old)
        light_proba_old = light_proba;
    end

    light_aud_proba=handles2give.LightProbAud; % proportion of light trials
    if isempty(aud_light_proba_old)
        aud_light_proba_old = light_aud_proba;
    end
    light_wh_proba=handles2give.LightProbWh; % proportion of light trials
    if isempty(wh_light_proba_old)
        wh_light_proba_old = light_wh_proba;
    end

    light_stim_shape='rect'; % "rect" or "sin" %%% for now only use 'rect'
    light_amp=handles2give.LightAmp;
    light_freq=handles2give.LightFreq; % frequency of the pulse train
    light_duty=handles2give.LightDuty; % duty cycle (0-1)


    if trial_number > 1
        Results=importdata([folder_name '\Results.txt']);
        n_completed_trials=sum(Results.data(:,10)~=6);
    else
        n_completed_trials=1;
    end

    % Size of pool (i.e. trial block) to get trials from
    main_pool_size = 20;

    stim_light_list=[900,901,902,903,904,905]; % code for each stimuli

    aud_light_proba_old =light_aud_proba;
    light_proba_old =light_proba;
    wh_light_proba_old = light_wh_proba;

    aud_stim_proba_old = aud_stim_proba;
    wh_stim_proba_old = wh_stim_proba;

    % CREATE NEW TRIAL POOL WHEN CURRENT POOL FINISHED

    if mod(n_completed_trials, main_pool_size)==1 || light_proba_old ~= light_proba || aud_light_proba_old ~= light_aud_proba ||  wh_light_proba_old ~= light_wh_proba ||stim_proba_old ~= stim_proba || aud_stim_proba_old ~= aud_stim_proba|| wh_stim_proba_old ~= wh_stim_proba
        
        % Stim. probability and trial pool when light stimulus
        if light_flag

            NoStimLightProb =(1-stim_proba)*light_proba;
            NoStimNoLightProb = (1-stim_proba)*(1-light_proba);
            StimNoLight = stim_proba*(1-light_proba);
            AudStimLight = aud_stim_proba*light_aud_proba;
            AudStimNoLight = aud_stim_proba*(1-light_aud_proba);
            WhStimLight = wh_stim_proba*light_wh_proba;
            WhStimNoLight = wh_stim_proba*(1-light_wh_proba);

            main_trial_pool=[stim_light_list(1)*ones(1,round(round(NoStimNoLightProb*main_pool_size*100))/100) ,...
                stim_light_list(2)*ones(1,round(round(AudStimNoLight*main_pool_size*100)/100)) ,...
                stim_light_list(3)*ones(1,round(round(WhStimNoLight*main_pool_size*100)/100)) ,...
                stim_light_list(4)*ones(1,round(round(NoStimLightProb*main_pool_size*100)/100)) ,...
                stim_light_list(5)*ones(1,round(round(AudStimLight*main_pool_size*100)/100)) ,...
                stim_light_list(6)*ones(1,round(round(WhStimLight*main_pool_size*100)/100)) ,...
                ];

        % Stim. probability and trial pool when no light stimulus
        else
            main_trial_pool=[stim_light_list(1)*ones(1,round(round(((1-stim_proba)*main_pool_size)*100)/100)) ,...
                stim_light_list(2)*ones(1,round(round(aud_stim_proba*main_pool_size*100)/100)),...
                stim_light_list(3)*ones(1,round(round(wh_stim_proba*main_pool_size*100)/100)),...
                ];
        end

        %Randomize occurence of trials in pool
        main_trial_pool=main_trial_pool(randperm(numel(main_trial_pool)));

    end

    % Create auditory detection block before any whisker stim - NOT IN USE
    %aud_block_size = 30;
    %aud_stim_proba_block=0.5;
    %aud_block_pool = [stim_light_list(1)*ones(1,round(round(((1-aud_stim_proba_block)*aud_block_size)*100)/100)) ,...
    %        stim_light_list(2)*ones(1,round(round(aud_stim_proba_block*aud_block_size*100)/100))];
    %aud_block_pool = aud_block_pool(randperm(numel(aud_block_pool)));

    % % Select next trial from pool
    % if trial_number < aud_block_size
    %     Trial_Type = aud_block_pool(mod(n_completed_trials,main_pool_size)+1); % select from auditory detection block first
    % else
    %     Trial_Type = main_trial_pool(mod(n_completed_trials,main_pool_size)+1); %0 noLight 1 Light
    % end

    trial_type = main_trial_pool(mod(n_completed_trials,main_pool_size)+1); %0 noLight 1 Light

    switch trial_type
        case stim_light_list(1) % NO STIM TRIAL
            is_stim=0;
            is_light_stim=0;
            is_auditory = 0;
            is_whisker =0;
        case stim_light_list(2) % AUDITORY TRIAL
            is_stim=1;
            is_light_stim=0;
            is_auditory = 1;
            is_whisker =0;
        case stim_light_list(3) % WHISKER TRIAL
            is_stim=1;
            is_light_stim=0;
            is_auditory = 0;
            is_whisker =1;
        case stim_light_list(4) % LIGHT NO STIM TRIAL
            is_stim=0;
            is_light_stim=1;
            is_auditory = 0;
            is_whisker =0;
        case stim_light_list(5) % LIGHT AUDITORY TRIAL
            is_stim=1;
            is_light_stim=1;
            is_auditory = 1;
            is_whisker =0;
        case stim_light_list(6)  % LIGHT WHISKER TRIAL
            is_stim=1;
            is_light_stim=1;
            is_auditory = 0;
            is_whisker =1;
    end

    % Set light parameters to zero if not a light trial
    if ~is_light_stim || ~light_flag
        is_light_stim=0;
        light_prestim=0;
        light_amp=0;
        light_duration=0;
        light_freq=0;
    end

    %% _ Settings
    reward_valve_duration=handles2give.ValveOpening;    % duration valve open in milliseconds
    reward_delay_time=handles2give.RewardDelay;         % delay in milisecond for delivering reward after stim (if Association=1)
    partial_reward_flag=handles2give.PartialRewardFlag; 


    aud_reward = handles2give.AudRew; % is auditory rewarded
    wh_reward = handles2give.wh_rew;  % is whisker rewarded

    % Probabilistic reward delivery
    if partial_reward_flag

        reward_proba=handles2give.RewardProb; % proportion of rewarded hits
        if isempty('RewardProbOld')
            reward_proba_old = reward_proba;
        end

        % Create a pool of rewarded and unrewarded trials (vector of 1s and 0s)
        if mod(trial_number, n_pool)==1 || reward_proba_old ~= reward_proba
            reward_proba_old = reward_proba;
            reward_pool=[zeros(1,round((1-reward_proba)*n_pool)) ones(1,round(reward_proba*n_pool))]; % zero for no stim, one for Reward
            reward_pool=reward_pool(randperm(numel(reward_pool)));
        end

        is_reward=reward_pool(mod(trial_number,n_pool)+1); % select the next trial from the pool,  0 noReward 1 Reward
    
    % Constant reward delivery
    else
        is_reward=1;
    end


    % Define reward vector
    reward_delay_time=0; %hard-coded here, but defined above from GUI
    rew_vec_amp = 5; %volt
    reward_vec=[zeros(1, reward_delay_time) rew_vec_amp*ones(1,reward_valve_duration*Reward_S_SR/1000) zeros(1,Reward_S_SR/2)];
    
    % Non-rewarded trials
    if ~is_reward
        reward_vec=zeros(1,numel(reward_vec));
    end

    %% Performance Measures
    perf_win_size=handles2give.LastRecentTrials;

    % Inter trial interval
    if min_iti > max_iti
        set(handles2give.OnlineTextTag,'String','Error: Minimum ITI should be smaller than maximum ITI!');

    elseif min_iti==max_iti %constant ITI
        set(handles2give.OnlineTextTag,'String','Warning: ITI will be constant.');
        iti=min_iti;
    else
        iti=randsample(min_iti:.1:max_iti,1);
    end
    
    % Timeout punishment (TO REMOVE?)
    if last_trial_fa 
        iti=iti + fa_timeout;
    end

    %% Get trial duration
    trial_duration = max(trial_duration, (light_prestim + artifact_window + baseline_window + max(response_window, (light_duration-light_prestim))) /1000);

    %% Get whisker stimulus type
    N_stimpool=2;

    if  trial_number==1
        pool_size=1;
    end

    if trial_number==1 || mod(trial_number,pool_size)==1
        stim_index_pool=[];

        for i=1:handles2give.NumStim %Different whisker stimuli
            stim_index_pool = [stim_index_pool i*ones(1,Stim_Weights(i)*N_stimpool)];
        end

        stim_index_pool = [zeros(1,no_stim_weight*N_stimpool) stim_index_pool 7*ones(1,aud_stim_weight*N_stimpool)];
        pool_size = numel(stim_index_pool); %number of elements in array
        stim_pool = randsample(stim_index_pool,pool_size); %random sampling without replacement: shuffling
    end

    if mod(trial_number,pool_size)>0
        StimIndex=stim_pool(mod(trial_number,pool_size));
    else
        StimIndex=stim_pool(end);
    end


    %% Limit Stim/NoStim Trials in a row
    if is_stim==1 && max_stim_trials_flag==1 %applies if 1
        stim_counter=stim_counter+1;
    elseif is_stim==0 && max_stim_trials_flag==1
        no_stim_counter=no_stim_counter+1;
    end

    if stim_counter>max_stim_trials_number
        is_stim=1-is_stim;
        stim_counter=0;
        no_stim_counter=1;
    elseif no_stim_counter>max_stim_trials_number
        is_stim=1-is_stim;

        if Aud_Weight
            StimIndex=randsample([1:length(Stim_Weights),7],1); %??what's 7??
        else
            StimIndex=randsample(1:length(Stim_Weights),1);
        end
        %
        no_stim_counter=0;
        stim_counter=1;
    end

    %% Define stimulus parameters and vectors
    % Catch trials, set stimulus vectors to 0
    if ~is_stim
        aud_stim_duration = 0;
        aud_stim_amp = 0;
        aud_stim_freq = 0;
        wh_stim_duration = 0;
        wh_stim_amp = 0;

        wh_vec = zeros(1,(trial_duration)*(Stim_S_SR/1000));
        aud_vec = zeros(1,(trial_duration)*(Stim_S_SR/1000));

    % Stimulus trial parameters and vectors
    else
        % Sinusoidal auditory stimulus
        if is_auditory

            aud_stim_duration = Astim_Dur; %ms
            aud_stim_amp = Astim_Amp; %volt
            aud_stim_freq = Astim_Freq; %Hz

            aud_vec = aud_stim_amp*[zeros(1,(baseline_window)*Stim_S_SR/1000)...
                sin(linspace(0, aud_stim_duration* aud_stim_freq*2*pi/1000, round(aud_stim_duration*Stim_S_SR/1000))) 0];
            aud_vec=[aud_vec zeros(1,trial_duration*Stim_S_SR/1000-length(aud_vec))];
            
            % Set whisker vec to zero
            wh_stim_duration = 0;
            wh_stim_amp=0;
            wh_vec=zeros(1,(trial_duration)*(Stim_S_SR/1000));

        % Biphasic cosine whisker stimulus
        else
            % Set auditory vector to 0
            aud_stim_duration = 0; 
            aud_stim_amp = 0;
            aud_stim_freq = 0;

            aud_vec=zeros(1,(trial_duration)*(Stim_S_SR/1000));
            
            % OLD PARAMS FROM GUI, BUT HARD CODED NOW (see BELOW)
            %wh_stim_duration=wh_stim_duration_list(1);
            %wh_stim_amp=wh_stim_amp_list(1);

            % CALIBRATE WHISKER STIMULUS SHAPE BASED ON GUI AMPLITUDE PARAM
            % - KEPT BUT COULD BE DELETED?
                %switch wh_stim_amp
                %    case 0.5
                %        ScaleFactor=1.1;
                %        StimDurationRise = wh_stim_duration*Stim_S_SR/2000;
                %        StimDurationDecrease = wh_stim_duration*Stim_S_SR/2000;
                %    case 1
                %        ScaleFactor=1.15;
                %        StimDurationRise = wh_stim_duration*Stim_S_SR/2000;
                %        StimDurationDecrease = wh_stim_duration*Stim_S_SR/2000;
                %    otherwise
                %        ScaleFactor=0.9;
                %        StimDurationRise = wh_stim_duration*Stim_S_SR/2000+15;
                %        StimDurationDecrease = wh_stim_duration*Stim_S_SR/2000+1;
                %end

            %HARD-CODED STIM PARAMS -> check magnetic field with calibration_coil.m 

            wh_stim_amp = 2.3; %volt
            wh_stim_duration_up = 1.5; %ms
            wh_stim_duration_down = 1.5;
            scale_factor = .6; % -> relative amplitude of both cosines to control for artefact transient

            wh_stim_duration_up = wh_stim_duration_up*Stim_S_SR/1000;
            wh_stim_duration_down = wh_stim_duration_down*Stim_S_SR/1000;

            impulse_up = tukeywin(wh_stim_duration_up,1);
            impulse_up = impulse_up(1:end-1);
            impulse_down = -tukeywin(wh_stim_duration_down,1);
            impulse_down = impulse_down(2:end);
            impulse = [impulse_up' scale_factor*impulse_down'];

            wh_vec = wh_stim_amp * [zeros(1,baseline_window*Stim_S_SR/1000) impulse];
            wh_vec = [wh_vec zeros(1,trial_duration*Stim_S_SR/1000 - numel(wh_vec))];

        end
    end


    %% Light / optogenetics, define vector
    if is_light_stim

        disp(['Light' num2str(is_light_stim)])
        time_vec_light = 1/Stim_S_SR : 1/Stim_S_SR : (light_duration/1000);

        light_pulse_train=[ones(1,round(Stim_S_SR*(light_duty/light_freq))) zeros(1,round(Stim_S_SR*((1-light_duty)/light_freq)))];
        light_pulse_train=repmat(light_pulse_train,1,light_duration*light_freq/1000);

        switch light_stim_shape
            case 'sin'
                light_vec=light_amp/2+light_amp/2*[-ones(1,baseline_window*Stim_S_SR/1000) -ones(1,(light_prestim)*Stim_S_SR/1000) -cos(2*pi*light_freq*time_vec_light)];
                light_vec=[light_vec zeros(1,(trial_duration)*(Stim_S_SR/1000)-numel(light_vec))];

                light_vec_shadow= [zeros(1,baseline_window*Stim_S_SR/1000) zeros(1,(light_prestim)*Stim_S_SR/1000) [ones(1,1*length(light_pulse_train)-ramp_down_duration*Stim_S_SR/1000) fliplr(linspace(0,1,ramp_down_duration*Stim_S_SR/1000))]];
                light_vec_shadow =[light_vec_shadow zeros(1,(trial_duration)*(Stim_S_SR/1000)-numel(light_vec_shadow))];

                light_vec=light_vec.*light_vec_shadow;

            otherwise
                light_vec=light_amp*[(zeros(1,(baseline_window - light_prestim)*Stim_S_SR/1000)) light_pulse_train];
                light_vec=[light_vec zeros(1,(trial_duration)*(Stim_S_SR/1000)-numel(light_vec))];
                %
                light_vec_shadow= [zeros(1,(baseline_window-light_prestim)*Stim_S_SR/1000) [ones(1,1*length(light_pulse_train)-ramp_down_duration*Stim_S_SR/1000) fliplr(linspace(0,1,ramp_down_duration*Stim_S_SR/1000))]];
                light_vec_shadow =[light_vec_shadow zeros(1,(trial_duration)*(Stim_S_SR/1000)-numel(light_vec_shadow))];

                light_vec=light_vec.*light_vec_shadow;

        end

    % No light, set light vector to 0
    else
        light_vec=zeros(1,(trial_duration)*(Stim_S_SR/1000));
    end

    %% Making pulse train to Trigger_S Camera

    camera_vec = [ones(1, Stim_S_SR*(camera_duty_cycle/camera_freq)) zeros(1,Stim_S_SR*((1-camera_duty_cycle)/camera_freq))];
    camera_vec = repmat(camera_vec, 1, trial_duration*camera_freq/1000);


    %% Plotting the whisker/auditory stim and camera vector signals
    timevec=linspace(0, trial_duration/1000,(trial_duration)*Stim_S_SR/1000);

    trial_time_window=max(timevec);

    plot(handles2give.CameraAxes,timevec(1:10:end),camera_vec(1:10:end),'k')
    set(handles2give.CameraAxes,'XTick',[])
    xlim(handles2give.CameraAxes,[0 trial_time_window])
    ylabel(handles2give.CameraAxes,'Camera')

    plot(handles2give.AudAxes,timevec(1:1:end),aud_vec(1:1:end),'Color', 'b')
    set(handles2give.AudAxes,'XTick',[])
    xlim(handles2give.AudAxes,[0 trial_time_window])
    ylabel(handles2give.AudAxes,'Auditory')
    ylim(handles2give.AudAxes,[-10 10])

    plot(handles2give.WhAxes,timevec(1:10:end),wh_vec(1:10:end),'Color', 'gr')
    xlim(handles2give.WhAxes,[0 trial_time_window])
    xlabel(handles2give.WhAxes,'time(s)')
    ylabel(handles2give.WhAxes,'Whisker')
    ylim(handles2give.WhAxes,[-5 5])


    %% Online performance for plotting
    if trial_number>1
        
        % Load Results data
        Results=importdata([folder_name '\Results.txt']);

        perf = Results.data(Results.data(:,10) ~= 6,10);
        aud_trials = Results.data(Results.data(:,10) ~= 6,8);
        wh_trials = Results.data(Results.data(:,10) ~= 6,7);
        stim_trials = Results.data(Results.data(:,10) ~= 6,6);
        LightP = Results.data(Results.data(:,10) ~= 6,11);

        % Compute performance and metrics
        WHitRate=round(sum(perf==2)/sum(wh_trials==1)*100)/100;
        AHitRate=round(sum(perf==3)/sum(aud_trials==1)*100)/100;
        FalseAlarm=round(sum(perf==5)/sum(stim_trials==0)*100)/100;
        StimTrial_num=sum(stim_trials==1);
        LA= sum((aud_trials==1).*(LightP == 1));
        LW = sum((wh_trials==1).*(LightP == 1));
        LStim = sum((stim_trials==1).*(LightP == 1));
        LNoStim = sum((stim_trials==0).*(LightP == 1));
        LAH = round(sum((perf==3).*(LightP == 1))/LA*100)/100;
        LWH = round(sum((perf==2).*(LightP == 1))/LW*100)/100;
        WStim = sum(wh_trials==1);
        AStim = sum(aud_trials==1);

        % Display trial counts on GUI (no light)
        set(handles2give.PerformanceText1Tag,'String',['AHR =' num2str(AHitRate) '  WHR=' num2str(WHitRate)...
            '  FAR=' num2str(FalseAlarm) '  Stim='  num2str(StimTrial_num) '  WS=' num2str(WStim) '  AS=' num2str(AStim)  '  EL='  num2str(early_lick_counter) ]);
        set(handles2give.PerformanceText1Tag, 'FontWeight', 'Bold');

        % Make performance plot
        plot_performance(Results, perf_win_size);
    end

    %% Printing out the next trial specs
    TrialTitles={'NoStim',['WS Amp=' num2str(wh_stim_amp) ', ''WS Dur=' num2str(wh_stim_duration)],['AS Amp=' num2str(aud_stim_amp) ', ' 'AS Dur=' num2str(aud_stim_duration) ', '...
        'AS Freq=' num2str(aud_stim_freq)]};
    RewardTitles={'Not Rewarded','Rewarded'};
    LightTitles={'Light:Off','Light:On'};
    AssociationTitles={'','Association'};

    if is_stim

        if is_auditory

            set(handles2give.TrialTimeLineTextTag,'String',['Next Trial:   "' char(TrialTitles(is_stim+2)) '" '...
                char(AssociationTitles(association_flag+1)) '     ' char(RewardTitles(aud_reward+1)) '       ' char(LightTitles(is_light_stim+1))],'ForegroundColor','b');

        else

            set(handles2give.TrialTimeLineTextTag,'String',['Next Trial:   "' char(TrialTitles(is_stim+1)) '" '...
                char(AssociationTitles(association_flag+1)) '     ' char(RewardTitles(wh_reward+1)) '       ' char(LightTitles(is_light_stim+1))],'ForegroundColor','green');

        end

    else
        set(handles2give.TrialTimeLineTextTag,'String',['Next Trial:   "' char(TrialTitles(is_stim+1)) '" '...
            char(AssociationTitles(association_flag+1))  '       ' char(LightTitles(is_light_stim+1))],'ForegroundColor','k');
    end

    %% Parameters are updated: now send signal vectors and triggers
    
    % Close lick trace file for current trial
    if trial_number~=1
        fclose(fid3);
        delete(lh3)
    end
    
    % Open new lick trace file 
    fid3=fopen([folder_name '\LickTrace' num2str(trial_number) '.bin'],'w');
    % Listener for available data form piezo sensor
    lh3 = addlistener(Stim_S,'DataAvailable',@(src, event) log_lick_data(src, event, trial_duration));
    %Stim_S.ScansAvailableFcn = @(src, event)log_lick_data(src, event, Trial_Duration);
    
    trial_lick_data=[];

    % queueOutputData(Stim_S,[Wh_vec; Aud_vec]')
    SITrigger_vec=[ones(1,numel(wh_vec)-2) 0 0]; % ScanImage trigger vector
    queueOutputData(Stim_S,[wh_vec; aud_vec; camera_vec; SITrigger_vec]')
    %preload(Stim_S, [Wh_vec; Aud_vec; Camera_vec; SITrigger_vec]');
    
    while Stim_S.IsRunning
        disp('Here') %?????
    end
    %start(Stim_S, 'Continuous');
    Stim_S.startBackground()
    ScansTobeAcquired=Stim_S.ScansQueued; %this is not used?

    outputSingleScan(Trigger_S,[0 0 0])
    %write(Trigger_S, [0 0 0]);

    % WHAT IS THIS FOR?
    if ~Reward_S.ScansQueued 
        queueOutputData(Reward_S, reward_vec')
        %write(Reward_S, Reward_vec');
        while Reward_S.IsRunning
            disp('Here 2') 
        end
        %start(Reward_S);
        Reward_S.startBackground();
    end

    %% Define response window boundaries
    
    response_window_start = (artifact_window + baseline_window)/1000;
    response_window_end = (artifact_window + baseline_window+response_window)/1000;

    
    %% Update current trial flags
    handles2give.ReportPause=1; %not currently paused

    trial_started_flag=0;
    stim_flag=1;
    deliver_reward_flag=0;
    perf_and_save_results_flag=0;
    mouse_licked_flag=0;
    reward_delivered_flag=0;
    update_parameters_flag=0;

    % Reset variables
    reaction_time=0;

end