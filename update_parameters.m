function update_parameters
% UPDATE_PARAMETERS Update parameters at each trial.

    global   association_flag response_window trial_duration quiet_window lick_threshold...
        artifact_window iti camera_flag is_stim is_auditory is_whisker is_light_stim ...
        reward_valve_duration  aud_reward wh_reward wh_vec aud_vec light_vec ...
        light_prestim_delay stim_flag perf lick_flag ...
        false_alarm_punish_flag false_alarm_timeout early_lick_punish_flag early_lick_timeout ...
        Stim_S wh_stim_duration  aud_stim_duration  aud_stim_amp  aud_stim_freq  Stim_S_SR ScansTobeAcquired ...
        Reward_S Reward_S_SR  Trigger_S fid_lick_trace mouse_licked_flag reaction_time ...
        trial_started_flag  trial_number light_proba_old folder_name handles2give...
        stim_proba_old aud_stim_proba_old wh_stim_proba_old aud_light_proba_old wh_light_proba_old light_flag baseline_window camera_vec...
        deliver_reward_flag ...
        wh_stim_amp response_window_start response_window_end...
        perf_and_save_results_flag lh3 reward_delivered_flag update_parameters_flag...
        is_reward reward_pool partial_reward_flag reward_proba_old...
        light_duration light_freq light_amp camera_freq SITrigger_vec main_trial_pool trial_lick_data...
       
       

    outputSingleScan(Trigger_S,[0 0 0])
    pause(.5)
    outputSingleScan(Trigger_S,[0 0 0])
    
    % Light parameters
    ramp_down_duration=100; % in miliseconds
    light_amp = handles2give.light_amp;
    light_prestim_delay = handles2give.light_prestim_delay;

    light_durations = [light_amp]+ramp_down_duration;
    light_prestim_delays =[light_prestim_delay];
    light_duration = handles2give.light_duration;

    % Trial pool
    n_pool=10; % Making the pool for stimulus and partial rewards
    camera_block_duration = 300; % in seconds (added for block filming)

    trial_number = trial_number+1;

    %% Update Video Parameters and Arm the Camera

    camera_flag = handles2give.camera_flag;

    % SAVING CAMERA FRAMES
    % if camera_flag && (trial_number==1 || toc(cameraStartTime)>Block_Duration)
    if camera_flag
        camera_freq=handles2give.camera_freq; % Hz

        VideoFileInfo.trial_number=trial_number;

        % TODO: remove hard coded basename 
        VideoFileInfo.directory=[handles.video_directory char(handles2give.mouse_name)...
            '\' [char(handles2give.mouse_name) '_' char(handles2give.date) '_' char(handles2give.session_time) '\']];

        % Define number of frames to save in block
        VideoFileInfo.n_frames_to_grab = trial_duration*camera_freq/1000;
        %VideoFileInfo.n_frames_to_grab = camera_block_duration*camera_freq/1000; %KEEP

        save('D:\Behavior\TemplateConfigFile\VideoFileInfo', 'VideoFileInfo');
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

    association_flag=handles2give.association_flag; % 0 detection 1 assosiation
    light_flag=handles2give.light_flag;

    % Camera settings
    camera_freq=handles2give.camera_freq; % Hz
    camera_duty_cycle=0.5;
    
    trial_duration=handles2give.trial_duration; % ms

    % Lick sensor threshold
    lick_threshold=handles2give.lick_threshold; %in volts

    % Trial timeline settings
    min_quiet_window = handles2give.min_quiet_window; % in ms
    max_quiet_window = handles2give.max_quiet_window; % in ms
    if min_quiet_window > max_quiet_window
        set(handles2give.OnlineTextTag,'String','Error: Minimum quiet window should be smaller than maximum quiet window!');
    
    elseif min_quiet_window==max_quiet_window
        set(handles2give.OnlineTextTag,'String','Warning: quiet window will be constant.');
        quiet_window=min_quiet_window;
    else
        quiet_window=randsample(min_quiet_window:.1:max_quiet_window,1);
    end

    response_window=handles2give.response_window; % in ms
    artifact_window=handles2give.artifact_window; % in ms
    baseline_window=handles2give.baseline_window; % in ms

    % Inter-trial interval range
    min_iti=handles2give.min_iti; % InterStimInterval in ms
    max_iti=handles2give.max_isi; % InterStimInterval in ms
    if min_iti > max_iti
        set(handles2give.OnlineTextTag,'String','Error: Minimum ITI should be smaller than maximum ITI!');

    elseif min_iti==max_iti %constant ITI
        set(handles2give.OnlineTextTag,'String','Warning: ITI will be constant.');
        iti=min_iti;
    else
        iti=randsample(min_iti:.1:max_iti,1);
    end
       
    % Timeout
    false_alarm_punish_flag = handles2give.false_alarm_punish_flag;
    false_alarm_timeout=handles2give.false_alarm_timeout; % in ms
    early_lick_punish_flag = handles2give.early_lick_punish_flag;
    early_lick_timeout=handles2give.early_lick_timeout; % in ms

    % Auditory and whisker stim parameters
    aud_stim_amp =  handles2give.aud_stim_amp;
    aud_stim_duration = handles2give.aud_stim_duration;
    aud_stim_freq = handles2give.aud_stim_freq;
    aud_stim_weight = handles2give.aud_stim_weight;
    
    wh_stim_weight = handles2give.wh_stim_weight(1); %for whisker , hard-coded for now (see below)
    
    no_stim_weight=handles2give.no_stim_weight;
    

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


    %% Compute light probability and light parameters
    light_proba=handles2give.light_proba; % proportion of light trials
    if isempty(light_proba_old)
        light_proba_old = light_proba;
    end

    light_aud_proba=handles2give.light_aud_proba; % proportion of light trials
    if isempty(aud_light_proba_old)
        aud_light_proba_old = light_aud_proba;
    end
    light_wh_proba=handles2give.light_wh_proba; % proportion of light trials
    if isempty(wh_light_proba_old)
        wh_light_proba_old = light_wh_proba;
    end

    light_stim_shape='rect'; % "rect" or "sin" %%% for now only use 'rect'
    light_amp=handles2give.light_amp;
    light_freq=handles2give.light_freq; % frequency of the pulse train
    light_duty=handles2give.light_duty; % duty cycle (0-1)

    %% Define new pool of stimuli

    if trial_number > 1
        results=importdata([folder_name '\results.txt']);
        n_completed_trials=sum(results.data(:,2)~=6);
    else
        n_completed_trials=1;
    end

    % Size of pool (i.e. trial block) to get trials from
    main_pool_size = 20;
    stim_light_list=[900,901,902,903,904,905]; % code for each stimuli
    
    % Save old probabilities
    aud_light_proba_old =light_aud_proba;
    light_proba_old =light_proba;
    wh_light_proba_old = light_wh_proba;

    aud_stim_proba_old = aud_stim_proba;
    wh_stim_proba_old = wh_stim_proba;

    % CREATE NEW TRIAL POOL WHEN CURRENT POOL FINISHED

    if mod(n_completed_trials, main_pool_size)==1 || light_proba_old ~= light_proba || aud_light_proba_old ~= light_aud_proba ||  wh_light_proba_old ~= light_wh_proba ||stim_proba_old ~= stim_proba || aud_stim_proba_old ~= aud_stim_proba|| wh_stim_proba_old ~= wh_stim_proba
        
        % Stim. probability and trial pool when light stimulus
        if light_flag

            no_stim_light_proba =(1-stim_proba)*light_proba;
            no_stim_no_light_proba = (1-stim_proba)*(1-light_proba);
            stim_no_light = stim_proba*(1-light_proba);
            aud_stim_light = aud_stim_proba*light_aud_proba;
            aud_stim_no_light = aud_stim_proba*(1-light_aud_proba);
            wh_stim_light = wh_stim_proba*light_wh_proba;
            wh_stim_no_light = wh_stim_proba*(1-light_wh_proba);

            main_trial_pool=[stim_light_list(1)*ones(1,round(round(no_stim_no_light_proba*main_pool_size*100))/100) ,...
                stim_light_list(2)*ones(1,round(round(aud_stim_no_light*main_pool_size*100)/100)) ,...
                stim_light_list(3)*ones(1,round(round(wh_stim_no_light*main_pool_size*100)/100)) ,...
                stim_light_list(4)*ones(1,round(round(no_stim_light_proba*main_pool_size*100)/100)) ,...
                stim_light_list(5)*ones(1,round(round(aud_stim_light*main_pool_size*100)/100)) ,...
                stim_light_list(6)*ones(1,round(round(wh_stim_light*main_pool_size*100)/100)) ,...
                ];

        % Stim. probability and trial pool when no light stimulus
        else
            main_trial_pool=[stim_light_list(1)*ones(1,round(round(((1-stim_proba)*main_pool_size)*100)/100)) ,...
                stim_light_list(2)*ones(1,round(round(aud_stim_proba*main_pool_size*100)/100)),...
                stim_light_list(3)*ones(1,round(round(wh_stim_proba*main_pool_size*100)/100)),...
                ];
        end

        %Randomize occurrence of trials in pool
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

    % Select next trial
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
        light_prestim_delay=0;
        light_amp=0;
        light_duration=0;
        light_freq=0;
    end

    %% Reward Settings
    reward_valve_duration=handles2give.reward_valve_duration;    % duration valve open in milliseconds
    reward_delay_time=handles2give.reward_delay_time;         % delay in milisecond for delivering reward after stim (if Association=1)
    partial_reward_flag=handles2give.partial_reward_flag; 


    aud_reward = handles2give.aud_reward; % is auditory rewarded
    wh_reward = handles2give.wh_reward;  % is whisker rewarded

    % Probabilistic reward delivery
    if partial_reward_flag

        reward_proba=handles2give.reward_proba; % proportion of rewarded hits
        if isempty('reward_proba_old')
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
    rew_vec_amp = 5; %volt
    reward_vec=[zeros(1, reward_delay_time) rew_vec_amp*ones(1,reward_valve_duration*Reward_S_SR/1000) zeros(1,Reward_S_SR/2)];
    
    % Non-rewarded trials
    if ~is_reward
        reward_vec=zeros(1,numel(reward_vec));
    end

    %% Get trial duration
    trial_duration = max(trial_duration, (light_prestim_delay + artifact_window + baseline_window + max(response_window, (light_duration-light_prestim_delay))) /1000);


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
            wh_stim_duration = wh_stim_duration_up + wh_stim_duration_down;
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
                light_vec=light_amp/2+light_amp/2*[-ones(1,baseline_window*Stim_S_SR/1000) -ones(1,(light_prestim_delay)*Stim_S_SR/1000) -cos(2*pi*light_freq*time_vec_light)];
                light_vec=[light_vec zeros(1,(trial_duration)*(Stim_S_SR/1000)-numel(light_vec))];

                light_vec_shadow= [zeros(1,baseline_window*Stim_S_SR/1000) zeros(1,(light_prestim_delay)*Stim_S_SR/1000) [ones(1,1*length(light_pulse_train)-ramp_down_duration*Stim_S_SR/1000) fliplr(linspace(0,1,ramp_down_duration*Stim_S_SR/1000))]];
                light_vec_shadow =[light_vec_shadow zeros(1,(trial_duration)*(Stim_S_SR/1000)-numel(light_vec_shadow))];

                light_vec=light_vec.*light_vec_shadow;

            otherwise
                light_vec=light_amp*[(zeros(1,(baseline_window - light_prestim_delay)*Stim_S_SR/1000)) light_pulse_train];
                light_vec=[light_vec zeros(1,(trial_duration)*(Stim_S_SR/1000)-numel(light_vec))];
                %
                light_vec_shadow= [zeros(1,(baseline_window-light_prestim_delay)*Stim_S_SR/1000) [ones(1,1*length(light_pulse_train)-ramp_down_duration*Stim_S_SR/1000) fliplr(linspace(0,1,ramp_down_duration*Stim_S_SR/1000))]];
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
    
    % Set plotting params
    acolor = [0 0.4470 0.7410];
    acolor_str = '0 0.4470 0.7410';
    if wh_reward
        wcolor = [0.4660 0.6740 0.1880]';
        wcolor_str = '0.4660 0.6740 0.1880';
    else
        wcolor = [0.6350 0.0780 0.1840];
        wcolor_str = '0.6350 0.0780 0.1840';
    end
    
    timevec=linspace(0, trial_duration/1000,(trial_duration)*Stim_S_SR/1000);
    trial_time_window=max(timevec);

    plot(handles2give.CameraAxes,timevec(1:10:end),camera_vec(1:10:end),'k')
    set(handles2give.CameraAxes,'XTick',[])
    xlim(handles2give.CameraAxes,[0 trial_time_window])
    ylabel(handles2give.CameraAxes,'Camera')

    plot(handles2give.AudAxes,timevec(1:1:end),aud_vec(1:1:end),'Color', acolor)
    set(handles2give.AudAxes,'XTick',[])
    xlim(handles2give.AudAxes,[0 trial_time_window])
    ylabel(handles2give.AudAxes,'Auditory')
    ylim(handles2give.AudAxes,[-10 10])

    plot(handles2give.WhAxes,timevec(1:10:end),wh_vec(1:10:end),'Color', wcolor)
    xlim(handles2give.WhAxes,[0 trial_time_window])
    xlabel(handles2give.WhAxes,'Time(s)')
    ylabel(handles2give.WhAxes,'Whisker')
    ylim(handles2give.WhAxes,[-5 5])


    %% Online performance for plotting
    if trial_number>1
        
        % Load results data
        results=importdata([folder_name '\results.txt']);
        n_asso_trials = sum(results.data(:,2)==6);
        
        perf = results.data(results.data(:,2) ~= 6,2);
        aud_trials = results.data(results.data(:,2) ~= 6,9);
        wh_trials = results.data(results.data(:,2) ~= 6,8);
        stim_trials = results.data(results.data(:,2) ~= 6,7);

        % Compute performance and metrics -> modularize
        wh_hit_rate = round(sum(perf==2)/sum(wh_trials==1)*100)/100;
        aud_hit_rate = round(sum(perf==3)/sum(aud_trials==1)*100)/100;
        fa_rate = round(sum(perf==5)/sum(stim_trials==0)*100)/100;
        stim_trial_number = sum(stim_trials==1);
        wh_stim_number = sum(wh_trials==1);
        aud_stim_number = sum(aud_trials==1);

        % Display current performance & trial counts on GUI
        set(handles2give.PerformanceText1Tag, 'String', ...
            ['AHR =' num2str(aud_hit_rate) ', ' ...
            ' WHR=' num2str(wh_hit_rate) ', ' ...
            ' FAR=' num2str(fa_rate) ', ' ...
            ' Stim.='  num2str(stim_trial_number) ', '...
            ' WhStim=' num2str(wh_stim_number) ', '...
            ' AudStim=' num2str(aud_stim_number)], ...
            'FontWeight', 'Bold');
        
        % Make performance plot
        perf_win_size=handles2give.last_recent_trials;
        plot_performance(results, perf_win_size);
        
    % Display reward volume obtained
    volume_per_reward = handles2give.reward_valve_duration /10; % in microliter (calibrated valve; 10ms opening -> 1 microliter)
    aud_tot_volume = volume_per_reward * sum(perf==3);
    wh_tot_volume = volume_per_reward * sum(perf==2);
    asso_tot_volume = volume_per_reward * n_asso_trials;
    
    set(handles2give.PerformanceText2Tag, 'String', ...
        ['Reward: Auditory =' num2str(aud_tot_volume) 'uL, '  ...
        ' Whisker =' num2str(wh_tot_volume) 'uL, ' ...
        ' Total =' num2str(aud_tot_volume+wh_tot_volume) 'uL, ' ...
        ' (Asso.=' num2str(asso_tot_volume) 'uL)'], ...
         'FontWeight', 'Bold');
     
     
      
    end

    %% Printing out the next trial specs
    trial_titles={'No stimulus', ...
        ['Amp=' num2str(wh_stim_amp) ', ' 'Duration=' num2str(wh_stim_duration)], ...
        ['Amp=' num2str(aud_stim_amp) ', ' 'Duration=' num2str(aud_stim_duration) ', ' 'Frequency=' num2str(aud_stim_freq)]};

    reward_titles={'Not rewarded', 'Rewarded'};
    light_titles={'Light OFF', 'Light ON'};
    association_titles={'', ' Association'};

    if is_stim

        if is_auditory

            set(handles2give.TrialTimeLineTextTag,'String', ['Next trial: Auditory.  ' char(trial_titles(is_stim+2)) ' '...
                char(association_titles(association_flag+1)) '   ' char(reward_titles(aud_reward+1)) '       ' char(light_titles(is_light_stim+1))],'ForegroundColor',acolor);

        else

            set(handles2give.TrialTimeLineTextTag,'String',['Next trial: Whisker. ' char(trial_titles(is_stim+1)) ' '...
                char(association_titles(association_flag+1)) '   ' char(reward_titles(wh_reward+1)) '       ' char(light_titles(is_light_stim+1))],'ForegroundColor',wcolor);

        end

    else
        set(handles2give.TrialTimeLineTextTag,'String',['Next trial:   ' char(trial_titles(is_stim+1)) ' '...
            char(association_titles(association_flag+1))  '     ' char(light_titles(is_light_stim+1))], 'ForegroundColor','k');
    end

    %% Parameters are updated: now send signal vectors and triggers
    
    % Close lick trace file for current trial
    if trial_number~=1
        fclose(fid_lick_trace);
        delete(lh3)
    end
    
    % Open new lick trace file 
    fid_lick_trace=fopen([folder_name '\LickTrace' num2str(trial_number) '.bin'],'w');
    % Listener for available data form piezo sensor
    lh3 = addlistener(Stim_S,'DataAvailable',@(src, event) log_lick_data(src, event, trial_duration));
    
    trial_lick_data=[];

    SITrigger_vec=[ones(1,numel(wh_vec)-2) 0 0]; % ScanImage trigger vector
    queueOutputData(Stim_S,[wh_vec; aud_vec; camera_vec; SITrigger_vec]')
    
    while Stim_S.IsRunning
        disp('Here') %?????
    end
    Stim_S.startBackground()
    ScansTobeAcquired=Stim_S.ScansQueued; %this is not used?

    outputSingleScan(Trigger_S,[0 0 0])

    % WHAT IS THIS FOR?
    if ~Reward_S.ScansQueued 
        queueOutputData(Reward_S, reward_vec')
        while Reward_S.IsRunning
            disp('Here 2') 
        end
        Reward_S.startBackground();
    end

    %% Define response window boundaries
    
    response_window_start = (artifact_window + baseline_window)/1000;
    response_window_end = (artifact_window + baseline_window + response_window)/1000;

    
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