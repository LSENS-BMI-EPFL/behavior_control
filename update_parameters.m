function update_parameters
% UPDATE_PARAMETERS Update parameters at each trial.

global   association_flag response_window trial_duration quiet_window lick_threshold...
    artifact_window iti camera_flag is_stim is_auditory is_whisker is_light is_opto...
    reward_valve_duration  aud_reward wh_reward wh_vec aud_vec light_vec ...
    light_prestim_delay stim_flag perf lick_flag ...
    false_alarm_punish_flag false_alarm_timeout early_lick_punish_flag early_lick_timeout ...
    Stim_S Log_S wh_stim_duration  aud_stim_duration  aud_stim_amp  aud_stim_freq  Stim_S_SR ScansTobeAcquired ...
    Reward_S Reward_S_SR  Trigger_S TTL_S fid_lick_trace mouse_licked_flag reaction_time ...
    trial_started_flag  trial_number main_pool_size_old opto_stim_proba_old folder_name handles2give...
    stim_proba_old aud_stim_proba_old wh_stim_proba_old opto_aud_proba_old opto_wh_proba_old opto_ctrl_proba_old...
    light_flag baseline_window camera_vec deliver_reward_flag ...
    wh_stim_amp wh_stim_amp_mT wh_scaling_factor response_window_start response_window_end...
    perf_and_save_results_flag reward_delivered_flag update_parameters_flag...
    is_reward reward_pool partial_reward_flag reward_proba_old...
    light_duration light_freq light_amp light_duty camera_freq SITrigger_vec main_trial_pool...
    whisker_trial_counter mouse_rewarded_context context_block context_flag block_id wh_rewarded_context...
    pink_noise_player brown_noise_player identical_block_count extra_time Context_S...
    WF_S wf_cam_vec LED1_vec LED2_vec opto_vec galv_x galv_y ...
    passive_stim_flag_enable passive_stim_flag passive_trial_max passive_iti passive_trial_counter is_passive ...
    TTL_info pdco_trial_on_flags pdco_trial_off_flags pdco_block_counter pdco_block_mode_started ...
    pdco_activation_block_counter pdco_prev_config_key pdco_continuous_stop_armed ttl1_vec ttl2_vec ...
    ttl1_edge_times_s ttl1_edge_states ttl1_edge_idx ...
    ttl2_edge_times_s ttl2_edge_states ttl2_edge_idx ...
    ttl1_current_state ttl2_current_state pdco_prev_ch2_start pdco_trial pdco_activation pdco_is_on ...
    pdco_alternate_start_block


% outputSingleScan(Trigger_S,[0 0 0])
% pause(.5)
% outputSingleScan(Trigger_S,[0 0 0])
try
    if ~isempty(Trigger_S) && isa(Trigger_S,'daq.ni.Session')
        outputSingleScan(Trigger_S,[0 0 0]);
    end
catch
end

trial_number = trial_number+1;

%% GENERAL SETTINGS FROM BEHAVIOUR GUI

association_flag=handles2give.association_flag; % 0 detection 1 assosiation
light_flag=handles2give.light_flag;

% Context info flag
context_flag = handles2give.context_flag;
context_block_size = handles2give.context_block_size;

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
max_iti=handles2give.max_iti; % InterStimInterval in ms
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

% Stimuli parameters
aud_stim_amp =  handles2give.aud_stim_amp;
aud_stim_duration = handles2give.aud_stim_duration;
aud_stim_freq = handles2give.aud_stim_freq;

wh_stim_amp = handles2give.wh_stim_amp_1; % default amplitude, overwritten at stim. definition
wh_stim_duration = handles2give.wh_stim_duration;
wh_scaling_factor = handles2give.wh_scaling_factor;

aud_stim_weight = handles2give.aud_stim_weight;
wh_stim_weight = get_whisker_weight(handles2give);
no_stim_weight = handles2give.no_stim_weight;

if light_flag % If light stimulus, to be implemented
    light_amp = handles2give.light_amp;
    light_duration = handles2give.light_duration;
    light_prestim_delay = handles2give.light_prestim_delay;
    light_freq = handles2give.light_freq;
    light_duty = handles2give.light_duty;
    light_stim_weight = handles2give.light_stim_weight;
end

% Passive stimulation
passive_stim_flag_enable = handles2give.passive_stim_flag_enable;
passive_stim_flag = handles2give.passive_stim_flag;
passive_trial_max = handles2give.passive_trial_max;
passive_iti = handles2give.passive_iti;
is_passive = 0;

if passive_stim_flag_enable
    contexts = {'active', 'passive'};
    if passive_stim_flag
        if passive_trial_counter < passive_trial_max
            is_passive = 1;
            association_flag = 1; % to exclude from performance and plots
            trial_duration = 1000;
            quiet_window = 0;
            iti = passive_iti;

            passive_trial_counter = passive_trial_counter + 1;
            context_block = contexts(is_passive+1)
            disp(['Passive trial ' num2str(passive_trial_counter)]);
        else
            is_passive = 0;
            association_flag = 0;
            passive_stim_flag=0;
            context_block = contexts(is_passive+1)
            set(handles2give.PassiveOnToggleButton,'Value',0);
            handles2give.passive_stim_flag = 0; % this will be reset when toggle button pressed again
            disp('End of passive stimulation.')
        end
    else
        context_block = contexts(is_passive+1)
        passive_trial_counter = 0; % keep counter
    end
else
    is_passive=0;
end


%% Compute stimulus probability
stim_proba = (aud_stim_weight + wh_stim_weight)/(aud_stim_weight + wh_stim_weight + no_stim_weight);
%stim_proba = compute_stim_proba(handles2give);
if isempty(stim_proba_old)
    stim_proba_old = stim_proba;
end

aud_stim_proba = (aud_stim_weight)/(aud_stim_weight + wh_stim_weight + no_stim_weight);
if isempty(aud_stim_proba_old)
    aud_stim_proba_old = aud_stim_proba;
end

wh_stim_proba = (wh_stim_weight)/(aud_stim_weight + wh_stim_weight + no_stim_weight);
if isempty(wh_stim_proba_old)
    wh_stim_proba_old = wh_stim_proba;
end


%% Compute opto-stimulus probability
if handles2give.opto_session
    global Opto_info
    opto_stim_proba = Opto_info.nostim_proba; % proportion of light trials
    if isempty(opto_stim_proba_old)
        opto_stim_proba_old = opto_stim_proba;
    end

    opto_aud_proba = Opto_info.aud_proba; % proportion of light trials
    if isempty(opto_aud_proba_old)
        opto_aud_proba_old = opto_aud_proba;
    end

    opto_wh_proba = Opto_info.wh_proba; % proportion of light trials
    if isempty(opto_wh_proba_old)
        opto_wh_proba_old = opto_wh_proba;
    end

    opto_ctrl_proba = Opto_info.ctrl_proba;
    if isempty(opto_ctrl_proba_old)
        opto_ctrl_proba_old = opto_ctrl_proba;
    end
else
    opto_stim_proba = 0;
    opto_aud_proba = 0;
    opto_wh_proba = 0;
    opto_ctrl_proba = 0;
end

%% Define new pool of stimuli

if trial_number > 1
    results=readtable(strcat(folder_name, '\results.csv'));
    n_completed_trials=sum(results.perf~=6);
else
    n_completed_trials=0;
end

% Size of pool (i.e. trial block) to get trials from
% If context is not used:
main_pool_size = aud_stim_weight + wh_stim_weight + no_stim_weight; %in an non-light task
if isempty(main_pool_size_old)
    main_pool_size_old = main_pool_size;
end

TRIAL_NOSTIM      = 900;
TRIAL_AUD         = 901;
TRIAL_WH          = 902;
TRIAL_OPTO_NOSTIM = 903;
TRIAL_OPTO_AUD    = 904;
TRIAL_OPTO_WH     = 905;
TRIAL_OPTO_CTRL   = 906;

stim_light_list = [TRIAL_NOSTIM, TRIAL_AUD, TRIAL_WH, ...
    TRIAL_OPTO_NOSTIM, TRIAL_OPTO_AUD, TRIAL_OPTO_WH, TRIAL_OPTO_CTRL];

is_new_block = ...
    mod(n_completed_trials, main_pool_size) == 0 || ...
    main_pool_size_old ~= main_pool_size || ...
    stim_proba_old ~= stim_proba || ...
    aud_stim_proba_old ~= aud_stim_proba || ...
    wh_stim_proba_old ~= wh_stim_proba || ...
    opto_stim_proba_old ~= opto_stim_proba || ...
    opto_aud_proba_old ~= opto_aud_proba || ...
    opto_wh_proba_old ~= opto_wh_proba || ...
    opto_ctrl_proba_old ~= opto_ctrl_proba;
if is_new_block



    % --- Creation of pseudo-random pool of trials (= block) ---
    % Create new trial pool when current pool finished, or, when change in parameters



    % Save old probabilities and pool size
    opto_aud_proba_old = opto_aud_proba;
    opto_stim_proba_old = opto_stim_proba;
    opto_wh_proba_old = opto_wh_proba;
    opto_ctrl_proba_old = opto_ctrl_proba; % TBD: proba of trials stimulating in control location vs. no stimulation

    aud_stim_proba_old = aud_stim_proba;
    wh_stim_proba_old = wh_stim_proba;
    stim_proba_old = stim_proba;

    main_pool_size_old = main_pool_size;

    % Stim. probability and trial pool when opto-stimulus
    if handles2give.opto_session

        no_stim_opto_proba =(1-stim_proba)*opto_stim_proba;
        no_stim_no_opto_proba = (1-stim_proba)*(1-opto_stim_proba);
        aud_stim_opto = aud_stim_proba*opto_aud_proba;
        aud_stim_no_opto = aud_stim_proba*(1-opto_aud_proba);
        wh_stim_opto = wh_stim_proba*opto_wh_proba;
        wh_stim_no_opto = wh_stim_proba*(1-opto_wh_proba);

        main_trial_pool=[stim_light_list(1)*ones(1,round(round(no_stim_no_opto_proba*main_pool_size*100)/100)),...
            stim_light_list(2)*ones(1,round(round(aud_stim_no_opto*main_pool_size*100)/100)),...
            stim_light_list(3)*ones(1,round(round(wh_stim_no_opto*main_pool_size*100)/100)),...
            stim_light_list(4)*ones(1,round(round(no_stim_opto_proba*main_pool_size*100)/100)),...
            stim_light_list(5)*ones(1,round(round(aud_stim_opto*main_pool_size*100)/100)),...
            stim_light_list(6)*ones(1,round(round(wh_stim_opto*main_pool_size*100)/100)),...
            ];

        % Stim. probability and trial pool when no opto-stimulus
    else
        main_trial_pool=[stim_light_list(1)*ones(1,round(round(((1-stim_proba)*main_pool_size)*100)/100)) ,...
            stim_light_list(2)*ones(1,round(round(aud_stim_proba*main_pool_size*100)/100)),...
            stim_light_list(3)*ones(1,round(round(wh_stim_proba*main_pool_size*100)/100)),...
            ];
    end

    %Randomize occurrence of trials in pool
    main_trial_pool=main_trial_pool(randperm(numel(main_trial_pool)));

    if passive_stim_flag_enable
        contexts = {'active', 'passive'};
    else
        context_block = {'NA'};
    end

    % if context task
    if context_flag
        contexts = {'pink', 'brown'};
        if trial_number==1
            identical_block_count = 1;
            [pink_noise_player, brown_noise_player] = create_context_background_noise(handles2give.bckg_noise_directory);
            mouse_rewarded_context = get_or_determine_mouse_rewarded_context(handles2give.context_table_directory, handles2give.mouse_name, contexts);
            block_id = randi([1, size(contexts, 2)], 1);
            context_block = contexts(block_id);
            outputSingleScan(Context_S, [0])
            if handles2give.context_sound_on
                play_context_background(context_block, pink_noise_player, brown_noise_player, Context_S)
            else
                outputSingleScan(Context_S, [1])
            end
        else
            old_block_id = block_id;
            block_id = randi([1, size(contexts, 2)], 1);
            if block_id == old_block_id
                identical_block_count = identical_block_count + 1;
            else
                identical_block_count = 1;
            end
            if identical_block_count > context_block_size  % We don't want more than 2 consecutive context A or B block
                new_block_id = block_id;
                while new_block_id == block_id
                    new_block_id = randi([1, size(contexts, 2)], 1);
                end
                block_id = new_block_id;
                identical_block_count = 1;
            end
            context_block = contexts(block_id);
            outputSingleScan(Context_S, [0])
            if handles2give.context_sound_on
                play_context_background(context_block, pink_noise_player, brown_noise_player, Context_S)
            else
                outputSingleScan(Context_S, [1])
            end
        end
        wh_rewarded_context = strcmp(context_block, mouse_rewarded_context);
    else
        block_id = 1;
    end
end

% --- End of trial pool creation ---

trial_in_block_idx = mod(n_completed_trials, main_pool_size) + 1;
first_half_last_idx = max(1, floor(main_pool_size/2));
second_half_first_idx = min(main_pool_size, first_half_last_idx + 1);
is_last_trial_in_block = (trial_in_block_idx == main_pool_size);

if isempty(pdco_block_counter)
    pdco_block_counter = 0;
end
if is_new_block
    pdco_block_counter = pdco_block_counter + 1;
end

% Select next trial
%trial_type = main_trial_pool(mod(n_completed_trials,main_pool_size)+1); %0 noLight 1 Light

if is_passive

    main_trial_pool_passive = main_trial_pool((main_trial_pool~=900) & (main_trial_pool~=903)); % remove no stim trials
    main_pool_passive_size = wh_stim_weight + aud_stim_weight;
    %         trial_type = main_trial_pool_passive(mod(n_completed_trials,main_pool_passive_size)+1); %0 noLight 1 Light
    trial_type = randsample(main_trial_pool_passive, 1);

    switch trial_type

        case stim_light_list(2) % AUDITORY TRIAL
            is_stim=1;
            is_auditory=1;
            is_whisker=0;
            is_light=0;
            is_opto=0;
        case stim_light_list(3) % WHISKER TRIAL
            is_stim=1;
            is_auditory=0;
            is_whisker=1;
            is_light=0;
            is_opto=0;
            whisker_trial_counter=whisker_trial_counter+1; %for proba. reward pool indexing

        case stim_light_list(5) % LIGHT AUDITORY TRIAL
            is_stim=1;
            is_auditory=1;
            is_whisker=0;
            is_light=0;
            is_opto=1;
        case stim_light_list(6)  % LIGHT WHISKER TRIAL
            is_stim=1;
            is_auditory=0;
            is_whisker=1;
            is_light=0;
            is_opto=1;
            whisker_trial_counter=whisker_trial_counter+1; %for proba. reward pool indexing
    end
else

    trial_type = main_trial_pool(mod(n_completed_trials,main_pool_size)+1); %0 noLight 1 Light

    switch trial_type
        case stim_light_list(1) % NO STIM TRIAL
            is_stim=0;
            is_auditory=0;
            is_whisker=0;
            is_light=0;
            is_opto=0;
        case stim_light_list(2) % AUDITORY TRIAL
            is_stim=1;
            is_auditory=1;
            is_whisker=0;
            is_light=0;
            is_opto=0;
        case stim_light_list(3) % WHISKER TRIAL
            is_stim=1;
            is_auditory=0;
            is_whisker=1;
            is_light=0;
            is_opto=0;
            whisker_trial_counter=whisker_trial_counter+1; %for proba. reward pool indexing
        case stim_light_list(4) % LIGHT NO STIM TRIAL
            is_stim=0;
            is_auditory=0;
            is_whisker=0;
            is_light=0;
            is_opto=1;
        case stim_light_list(5) % LIGHT AUDITORY TRIAL
            is_stim=1;
            is_auditory=1;
            is_whisker=0;
            is_light=0;
            is_opto=1;
        case stim_light_list(6)  % LIGHT WHISKER TRIAL
            is_stim=1;
            is_auditory=0;
            is_whisker=1;
            is_light=0;
            is_opto=1;
            whisker_trial_counter=whisker_trial_counter+1; %for proba. reward pool indexing
    end
end

% Set light parameters to zero if not a light trial
if ~is_light || ~light_flag
    is_light=0;
    light_prestim_delay=0;
    light_amp=0;
    light_duration=0;
    light_freq=0;
end



%% Reward Settings
reward_valve_duration=handles2give.reward_valve_duration;    % duration valve open in milliseconds

if handles2give.reward_delay_flag
    reward_delay_time=handles2give.reward_delay_time;         % delay in milisecond for delivering reward after stim (if Association=1)
else
    reward_delay_time = 0;
end


aud_reward = handles2give.aud_reward; % is auditory rewarded
if context_flag
    if wh_rewarded_context
        wh_reward=1;
    else
        wh_reward=0;
    end
else
    wh_reward = handles2give.wh_reward;  % is whisker rewarded
end

partial_reward_flag=handles2give.partial_reward_flag;
n_pool_partial = 10;

% PROBABILISTIC reward delivery for whisker
if partial_reward_flag && not(association_flag)

    reward_proba=handles2give.reward_proba; % proportion of rewarded whisker hits
    if isempty('reward_proba_old')
        reward_proba_old = reward_proba;
    end

    % Update pool of rewarded and unrewarded trials (1s and 0s) -> this
    % could be deleted
    if all(mod(whisker_trial_counter, n_pool_partial)==1)|| all(reward_proba_old ~= reward_proba)  %check if reward_proba has changed
        reward_proba_old = reward_proba;
        reward_pool=[zeros(1,round((1-reward_proba)*n_pool_partial)) ones(1,round(reward_proba*n_pool_partial))]; % zero for no stim, one for Reward
        reward_pool=reward_pool(randperm(numel(reward_pool)));
    end

    % Set reward flag per trial type
    if is_whisker
        is_reward = double(rand(1)<reward_proba);
    elseif is_auditory
        is_reward=aud_reward;
    end

    % CONSTANT reward delivery (also for association trials)
elseif not(partial_reward_flag) || association_flag
    is_reward=1;
end


% Define reward vector
rew_vec_amp = 5; %volt
reward_vec = [zeros(1,reward_delay_time) rew_vec_amp*ones(1,reward_valve_duration*Reward_S_SR/1000) zeros(1,Reward_S_SR/2)];

if ~is_reward || ~is_stim
    reward_vec=zeros(1,numel(reward_vec));
end

%% Get trial duration
trial_duration = max(trial_duration, (light_prestim_delay + artifact_window + baseline_window + max(response_window, (light_duration-light_prestim_delay))));


%% Define stimulus parameters and vectors
% Catch trials, set stimulus vectors to 0
if ~is_stim
    aud_stim_duration = 0;
    aud_stim_amp = 0;
    aud_stim_freq = 0;
    wh_stim_duration = 0;
    wh_stim_amp = 0;
    wh_stim_amp_mT = 0;

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
        wh_stim_amp = 0;
        wh_stim_amp_mT = 0;
        wh_vec = zeros(1,(trial_duration)*(Stim_S_SR/1000));

        % Biphasic cosine whisker stimulus
    elseif is_whisker
        % Set auditory vector to 0
        aud_stim_duration = 0;
        aud_stim_amp = 0;
        aud_stim_freq = 0;

        aud_vec=zeros(1,(trial_duration)*(Stim_S_SR/1000));

        wh_stim_duration_up = wh_stim_duration/2*Stim_S_SR/1000;
        wh_stim_duration_down = wh_stim_duration/2*Stim_S_SR/1000;

        impulse_up = tukeywin(wh_stim_duration_up,1);
        impulse_up = impulse_up(1:end-1);
        impulse_down = -tukeywin(wh_stim_duration_down,1);
        impulse_down = impulse_down(2:end);
        impulse = [impulse_up' wh_scaling_factor*impulse_down'];

        [wh_stim_amp, wh_stim_amp_mT] = get_whisker_stim_amp(handles2give);
        wh_vec = wh_stim_amp * [zeros(1,baseline_window*Stim_S_SR/1000) impulse];
        wh_vec = [wh_vec zeros(1,trial_duration*Stim_S_SR/1000 - numel(wh_vec))];

    end
end


% If optogenetics, get opto-stimulus
if handles2give.opto_session
    global opto_gui Opto_S variables_to_save_opto voltage_x voltage_y bregma_x bregma_y opto_count
    if is_opto
        [ML, AP, grid_no, count] = get_next_grid;
        power = opto_gui.amplitude;
        [opto_vec, galv_x, galv_y] = load_opto_vec(ML,AP);
        opto_count = opto_count+1;

    else
        [opto_vec, galv_x, galv_y] = load_opto_vec(5,-5);

        AP = -5;
        ML = 5;
        power = -1;
        grid_no = nan;
        count = trial_number - opto_count;

        opto_gui.plot_grid
        scatter(opto_gui.UIAxes, -5, 5, 'filled', 'MarkerEdgeColor','#DC143C', 'MarkerFaceColor', '#DC143C');
        text(opto_gui.UIAxes, 1, 6.5, {['No opto trial: ' num2str(count) '/' num2str(trial_number)]})
    end

    % Get optogenetic data to save
    variables_to_save_opto = {trial_number is_opto is_stim is_auditory is_whisker context_block opto_gui.baseline*1000 power opto_gui.frequency...
        opto_gui.duration opto_gui.pulse_width grid_no count AP ML ...
        voltage_x voltage_y bregma_x bregma_y};
end

%% PdCo / TTL logic (uses TTL ch1 = ON/start, TTL ch2 = OFF/stop)

pdco_on_flag  = 0;   % gates TTL ch1
pdco_off_flag = 0;   % gates TTL ch2

if isempty(pdco_block_mode_started)
    pdco_block_mode_started = false;
end
if isempty(pdco_activation_block_counter)
    pdco_activation_block_counter = NaN;
end
if isempty(pdco_prev_config_key)
    pdco_prev_config_key = '';
end
if isempty(pdco_continuous_stop_armed)
    pdco_continuous_stop_armed = false;
end
if isempty(pdco_prev_ch2_start)
    pdco_prev_ch2_start = false;
end
if isempty(pdco_is_on)
    pdco_is_on = 0;
end
if isempty(pdco_trial)
    pdco_trial = 0;
end
if isempty(pdco_activation)
    pdco_activation = 0;
end
if isempty(pdco_alternate_start_block)
    pdco_alternate_start_block = NaN;
end

cfg_exp = '';
cfg_block = '';
cfg_start = '';
cfg_repeat = '';
cfg_ch2 = 0;

if isfield(handles2give,'ttl_session') && handles2give.ttl_session && ...
        ~isempty(TTL_info) && isfield(TTL_info,'exp_design')

    if isfield(TTL_info,'exp_design'),      cfg_exp = TTL_info.exp_design; end
    if isfield(TTL_info,'block_design'),    cfg_block = TTL_info.block_design; end
    if isfield(TTL_info,'ttl_ch1_start'),   cfg_start = TTL_info.ttl_ch1_start; end
    if isfield(TTL_info,'repeat_ttl_ch1'),  cfg_repeat = TTL_info.repeat_ttl_ch1; end
    if isfield(TTL_info,'ttl_ch2_start'),   cfg_ch2 = double(TTL_info.ttl_ch2_start); end

    current_pdco_config_key = sprintf('%s|%s|%s|%s', ...
        cfg_exp, cfg_block, cfg_start, cfg_repeat);

    % Reset state when TTL GUI config changes
    if ~strcmp(current_pdco_config_key, pdco_prev_config_key)
        pdco_block_mode_started = false;
        pdco_activation_block_counter = NaN;
        pdco_trial_on_flags = [];
        pdco_trial_off_flags = [];
        pdco_continuous_stop_armed = false;
        pdco_alternate_start_block = NaN;

        % Reset saved PdCO state
        pdco_is_on = 0;
        pdco_trial = 0;
        pdco_activation = 0;

        pdco_prev_config_key = current_pdco_config_key;
    end

    switch TTL_info.exp_design

        case 'Block'

            switch cfg_start
                case 'Session start'
                    if trial_number == 1
                        pdco_block_mode_started = true;
                        if isnan(pdco_activation_block_counter)
                            pdco_activation_block_counter = pdco_block_counter;
                        end
                    end

                case 'Next block'
                    if is_new_block && trial_number > 1 && ~pdco_block_mode_started
                        pdco_block_mode_started = true;
                        pdco_activation_block_counter = pdco_block_counter;
                    end

                otherwise
                    pdco_block_mode_started = false;
                    pdco_activation_block_counter = NaN;
                    pdco_continuous_stop_armed = false;
                    pdco_alternate_start_block = NaN;

                    pdco_is_on = 0;
                    pdco_trial = 0;
                    pdco_activation = 0;
            end

            if pdco_block_mode_started

                switch TTL_info.block_design
                    case 'Alternate blocks'
                        if isnan(pdco_alternate_start_block)
                            pdco_alternate_start_block = pdco_block_counter;
                        end

                        is_pdco_alt_block = ...
                            pdco_block_counter >= pdco_alternate_start_block && ...
                            mod(pdco_block_counter - pdco_alternate_start_block, 2) == 0;

                        if is_pdco_alt_block
                            if is_new_block && ~pdco_is_on
                                pdco_on_flag = 1;
                            end

                            if is_last_trial_in_block && (pdco_is_on || pdco_on_flag)
                                pdco_off_flag = 1;
                            end
                        end
                    case 'First half'
                        if is_new_block && ...
                                pdco_block_counter >= pdco_activation_block_counter && ...
                                ~pdco_is_on
                            pdco_on_flag = 1;
                        end

                        if trial_in_block_idx == first_half_last_idx && ...
                                pdco_block_counter >= pdco_activation_block_counter && ...
                                (pdco_is_on || pdco_on_flag)
                            pdco_off_flag = 1;
                        end

                    case 'Second half'
                        if trial_in_block_idx == second_half_first_idx && ...
                                pdco_block_counter >= pdco_activation_block_counter && ...
                                ~pdco_is_on
                            pdco_on_flag = 1;
                        end

                        if is_last_trial_in_block && ...
                                pdco_block_counter >= pdco_activation_block_counter && ...
                                (pdco_is_on || pdco_on_flag)
                            pdco_off_flag = 1;
                        end

                    case 'Continuous'
                        % Arm one-shot OFF only on button rising edge
                        if cfg_ch2 && ~pdco_prev_ch2_start
                            pdco_continuous_stop_armed = true;
                        end

                        % Repeat TTL1 only while block mode is still active
                        switch cfg_repeat

                            case 'Every N trials'                                
                                repeat_n = max(1, round(TTL_info.repeat_ttl_ch1_n));
                                if mod(trial_in_block_idx-1, repeat_n) == 0 && ...
                                        pdco_block_counter >= pdco_activation_block_counter && ...
                                        pdco_block_mode_started
                                    pdco_on_flag = 1;
                                end

                            case 'Every block start'
                                if is_new_block && ...
                                        pdco_block_counter >= pdco_activation_block_counter && ...
                                        pdco_block_mode_started
                                    pdco_on_flag = 1;
                                end

                            case 'Never'
                                if is_new_block && ...
                                        pdco_block_counter == pdco_activation_block_counter && ...
                                        pdco_block_mode_started && ...
                                        ~pdco_is_on
                                    pdco_on_flag = 1;
                                end
                        end

                        % Fire OFF once at last trial of current block, then stop further TTL1 repetition
                        if pdco_continuous_stop_armed && is_last_trial_in_block && ...
                                pdco_block_counter >= pdco_activation_block_counter && ...
                                (pdco_is_on || pdco_on_flag)

                            pdco_off_flag = 1;
                            pdco_continuous_stop_armed = false;
                            pdco_block_mode_started = false;
                            pdco_activation_block_counter = NaN;
                        end
                end
            end

        case 'Trial'

            if is_new_block || isempty(pdco_trial_on_flags) || isempty(pdco_trial_off_flags)

                pdco_trial_on_flags  = zeros(1, numel(main_trial_pool));
                pdco_trial_off_flags = zeros(1, numel(main_trial_pool));

                % Catch = no stim + opto no stim
                catch_idx = find(main_trial_pool == stim_light_list(1) | main_trial_pool == stim_light_list(4));
                n_catch = numel(catch_idx);
                n_on_catch = round(n_catch * TTL_info.catch_prob);
                v = [ones(1,n_on_catch), zeros(1,n_catch-n_on_catch)];
                if ~isempty(v)
                    v = v(randperm(numel(v)));
                    pdco_trial_on_flags(catch_idx) = v;
                    pdco_trial_off_flags(catch_idx) = v;
                end

                % Auditory = aud + opto aud
                auditory_idx = find(main_trial_pool == stim_light_list(2) | main_trial_pool == stim_light_list(5));
                n_aud = numel(auditory_idx);
                n_on_aud = round(n_aud * TTL_info.aud_prob);
                v = [ones(1,n_on_aud), zeros(1,n_aud-n_on_aud)];
                if ~isempty(v)
                    v = v(randperm(numel(v)));
                    pdco_trial_on_flags(auditory_idx) = v;
                    pdco_trial_off_flags(auditory_idx) = v;
                end

                % Whisker = whisker + opto whisker
                whisker_idx = find(main_trial_pool == stim_light_list(3) | main_trial_pool == stim_light_list(6));
                n_wh = numel(whisker_idx);
                n_on_wh = round(n_wh * TTL_info.wh_prob);
                v = [ones(1,n_on_wh), zeros(1,n_wh-n_on_wh)];
                if ~isempty(v)
                    v = v(randperm(numel(v)));
                    pdco_trial_on_flags(whisker_idx) = v;
                    pdco_trial_off_flags(whisker_idx) = v;
                end
            end

            pdco_on_flag  = logical(pdco_trial_on_flags(trial_in_block_idx));
            pdco_off_flag = logical(pdco_trial_off_flags(trial_in_block_idx));

        otherwise
            pdco_on_flag = 0;
            pdco_off_flag = 0;
    end

    % Remember current button state for rising-edge detection next trial
    pdco_prev_ch2_start = logical(cfg_ch2);
end
%% PdCo trial-state labels for saving
pdco_activation = 0;
pdco_trial = pdco_is_on;

if pdco_on_flag && pdco_off_flag
    pdco_activation = 2;
    pdco_trial = 1;   % same trial still counts as PdCO trial
elseif pdco_on_flag
    pdco_activation = 1;
    pdco_trial = 1;   % activation trial counts as PdCO trial
elseif pdco_off_flag
    pdco_activation = -1;
    pdco_trial = 1;   % off trial still counts as PdCO trial
end

% update state for next trial
if pdco_on_flag && pdco_off_flag
    pdco_is_on = 0;   % on and off happened within same trial, next trial is OFF
elseif pdco_on_flag
    pdco_is_on = 1;
elseif pdco_off_flag
    pdco_is_on = 0;
end
%% Build TTL vectors for this trial (static TTL session, no queueing)
if isfield(handles2give,'ttl_session') && handles2give.ttl_session
    [ttl1_vec, ttl2_vec] = TTL_build_trial_vectors(trial_duration);

    if ~pdco_on_flag
        ttl1_vec(:) = false;
    end

    if ~pdco_off_flag
        ttl2_vec(:) = false;
    end
else
    ttl1_vec = false(0,1);
    ttl2_vec = false(0,1);
end

%% Convert TTL vectors into edge schedules for non-blocking playback
if ~isempty(TTL_info) && isfield(TTL_info,'fs') && ~isempty(TTL_info.fs)
    ttl_fs = TTL_info.fs;
else
    ttl_fs = 10000;
end

[ttl1_edge_times_s, ttl1_edge_states] = ttl_vec_to_edges(ttl1_vec, ttl_fs);
[ttl2_edge_times_s, ttl2_edge_states] = ttl_vec_to_edges(ttl2_vec, ttl_fs);

% ttl1_edge_idx = 1;
% ttl2_edge_idx = 1;

ttl1_current_state = false;
ttl2_current_state = false;

% disp(['pdco_on_flag = ' num2str(pdco_on_flag)])
% disp(['pdco_off_flag = ' num2str(pdco_off_flag)])
% disp(['numel(ttl1_vec) = ' num2str(numel(ttl1_vec)) ', sum(ttl1_vec) = ' num2str(sum(ttl1_vec))])
% disp(['numel(ttl2_vec) = ' num2str(numel(ttl2_vec)) ', sum(ttl2_vec) = ' num2str(sum(ttl2_vec))])
% disp(['ttl1 edges = ' num2str(numel(ttl1_edge_times_s))])
% disp(['ttl2 edges = ' num2str(numel(ttl2_edge_times_s))])
% disp(ttl2_edge_times_s)
%% Light define vector - To update
if is_light

    %         disp(['Light' num2str(is_light)])
    %         time_vec_light = 1/Stim_S_SR : 1/Stim_S_SR : (light_duration/1000);
    %
    %         light_pulse_train=[ones(1,round(Stim_S_SR*(light_duty/light_freq))) zeros(1,round(Stim_S_SR*((1-light_duty)/light_freq)))];
    %         light_pulse_train=repmat(light_pulse_train,1,light_duration*light_freq/1000);
    %
    %         switch light_stim_shape
    %             case 'sin'
    %                 light_vec=light_amp/2+light_amp/2*[-ones(1,baseline_window*Stim_S_SR/1000) -ones(1,(light_prestim_delay)*Stim_S_SR/1000) -cos(2*pi*light_freq*time_vec_light)];
    %                 light_vec=[light_vec zeros(1,(trial_duration)*(Stim_S_SR/1000)-numel(light_vec))];
    %
    %                 light_vec_shadow= [zeros(1,baseline_window*Stim_S_SR/1000) zeros(1,(light_prestim_delay)*Stim_S_SR/1000) [ones(1,1*length(light_pulse_train)-ramp_down_duration*Stim_S_SR/1000) fliplr(linspace(0,1,ramp_down_duration*Stim_S_SR/1000))]];
    %                 light_vec_shadow =[light_vec_shadow zeros(1,(trial_duration)*(Stim_S_SR/1000)-numel(light_vec_shadow))];
    %
    %                 light_vec=light_vec.*light_vec_shadow;
    %
    %             otherwise
    %                 light_vec=light_amp*[(zeros(1,(baseline_window - light_prestim_delay)*Stim_S_SR/1000)) light_pulse_train];
    %                 light_vec=[light_vec zeros(1,(trial_duration)*(Stim_S_SR/1000)-numel(light_vec))];
    %                 %
    %                 light_vec_shadow= [zeros(1,(baseline_window-light_prestim_delay)*Stim_S_SR/1000) [ones(1,1*length(light_pulse_train)-ramp_down_duration*Stim_S_SR/1000) fliplr(linspace(0,1,ramp_down_duration*Stim_S_SR/1000))]];
    %                 light_vec_shadow =[light_vec_shadow zeros(1,(trial_duration)*(Stim_S_SR/1000)-numel(light_vec_shadow))];
    %
    %                 light_vec=light_vec.*light_vec_shadow;
    %
    %         end

    % No light, set light vector to 0
else
    light_vec=zeros(1,(trial_duration)*(Stim_S_SR/1000));
end

%% For Video Filming - Make pulse train for Trigger_S Camera

camera_vec = [ones(1, Stim_S_SR*(camera_duty_cycle/camera_freq)) zeros(1,Stim_S_SR*((1-camera_duty_cycle)/camera_freq))];
camera_vec = repmat(camera_vec, 1, trial_duration*camera_freq/1000);

%% For WF imaging - Load vectors in single trial imaging
if handles2give.wf_session
    global WF_FileInfo
    if ~WF_FileInfo.RecordingContinuous
        wf_imaging
        if ~handles2give.opto_session
            WF_S.start()
            WF_S.write([wf_cam_vec; LED1_vec; LED2_vec;]')
        end
    end
end

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

%% Online performance for plotting
if trial_number>1

    % Load results data
    results=readtable(strcat(folder_name, '\results.csv'));

    % Compute performance and display on GUI
    [aud_hit_rate, wh_hit_rate, fa_rate, stim_trial_number, aud_stim_number, wh_stim_number] = compute_performance(results);

    set(handles2give.PerformanceText1Tag, 'String', ...
        ['AHR=' num2str(aud_hit_rate) ', ' ...
        ' WHR=' num2str(wh_hit_rate) ', ' ...
        ' FAR=' num2str(fa_rate) ', ' ...
        ' Stim='  num2str(stim_trial_number) ', '...
        ' AudStim=' num2str(aud_stim_number) ', '...
        ' WhStim=' num2str(wh_stim_number)], ...
        'FontWeight', 'Bold');

    % Make performance plot
    perf_win_size=handles2give.last_recent_trials;
    plot_performance(results, perf_win_size);

    % Compute approx. reward volume obtained and display on GUI
    volume_per_reward = 5; % in microliter <- THIS MUST BE CALIBRATED
    [aud_tot_volume, wh_tot_volume, asso_tot_volume] = compute_reward_volume(results, volume_per_reward);
    if wh_reward
        wh_tot_volume = wh_tot_volume;
    else
        wh_tot_volume = 0;
    end

    set(handles2give.PerformanceText2Tag, 'String', ...
        ['Reward: Auditory=' num2str(aud_tot_volume) 'uL, '  ...
        ' Whisker=' num2str(wh_tot_volume) 'uL, ' ...
        ' Total=' num2str(aud_tot_volume+wh_tot_volume) 'uL, ' ...
        ' (Asso.=' num2str(asso_tot_volume) 'uL)'], ...
        'FontWeight', 'Bold');

end

%% Printing out the next trial specs
trial_titles={'No stimulus', ...
    ['Amp=' num2str(wh_stim_amp) ', ' 'Duration=' num2str(wh_stim_duration)], ...
    ['Amp=' num2str(aud_stim_amp) ', ' 'Duration=' num2str(aud_stim_duration) ', ' 'Frequency=' num2str(aud_stim_freq)]};

if is_passive
    association_titles={'', ''};
    reward_titles={'Passive', 'Passive'};
else
    association_titles={'', ' Association'};
    reward_titles={'Not rewarded', 'Rewarded'};
end

if is_opto
    opto_titles={'Opto OFF', 'Opto ON'};
else
    opto_titles={'', ''};
end


if is_stim

    if is_auditory

        set(handles2give.TrialTimeLineTextTag,'String', ['Next trial: Auditory.  ' char(trial_titles(is_stim+2)) ' '...
            char(association_titles(association_flag+1)) '   ' char(reward_titles(aud_reward+1)) '     ' char(opto_titles(is_opto+1))],'ForegroundColor',acolor);

    else
        if is_reward==1 && wh_reward==1 % =1 always when no partial rewards
            reward_title = 'Rewarded';
            wcolor = [0.4660 0.6740 0.1880]';
        else
            reward_title = 'Not rewarded';
            wcolor = [0.6350 0.0780 0.1840];
        end

        if is_passive
            reward_title = 'Passive';
        end

        set(handles2give.TrialTimeLineTextTag,'String',['Next trial: Whisker. ' char(trial_titles(is_stim+1)) ' '...
            char(association_titles(association_flag+1)) '   ' char(reward_title) '     ' char(opto_titles(is_opto+1))],'ForegroundColor', wcolor);

    end

else
    set(handles2give.TrialTimeLineTextTag,'String',['Next trial:   ' char(trial_titles(is_stim+1)) ' '...
        char(association_titles(association_flag+1))  '     ' char(opto_titles(is_opto+1))], 'ForegroundColor','k');
end

%% Parameters are updated: now send signal vectors and triggers

N_stim = round(trial_duration * Stim_S_SR / 1000);

SITrigger_vec = [ones(1,max(N_stim-2,0)) 0 0]';
SITrigger_vec = SITrigger_vec(1:N_stim);

% Convert stimulus/session vectors to columns
wh_vec = wh_vec(:);
aud_vec = aud_vec(:);
camera_vec = camera_vec(:);
SITrigger_vec = SITrigger_vec(:);

% Keep Stim_S strictly at nominal trial duration
if numel(wh_vec) < N_stim
    wh_vec(end+1:N_stim,1) = 0;
else
    wh_vec = wh_vec(1:N_stim);
end

if numel(aud_vec) < N_stim
    aud_vec(end+1:N_stim,1) = 0;
else
    aud_vec = aud_vec(1:N_stim);
end

if numel(camera_vec) < N_stim
    camera_vec(end+1:N_stim,1) = 0;
else
    camera_vec = camera_vec(1:N_stim);
end

if numel(SITrigger_vec) < N_stim
    SITrigger_vec(end+1:N_stim,1) = 0;
else
    SITrigger_vec = SITrigger_vec(1:N_stim);
end

% Keep TTL vectors as columns for later playback via TTL_S
ttl1_vec = ttl1_vec(:);
ttl2_vec = ttl2_vec(:);

% ---- Stim_S queue: 4 channels only ----
stim_mat = [ ...
    double(wh_vec), ...
    double(aud_vec), ...
    double(camera_vec > 0), ...
    double(SITrigger_vec > 0)];

queueOutputData(Stim_S, stim_mat);

while Stim_S.IsRunning
    disp('Here')
end

Stim_S.startBackground();

% Keep static TTL session low between trials
if isfield(handles2give,'ttl_session') && handles2give.ttl_session && ~isempty(TTL_S)
    try
        outputSingleScan(TTL_S, [0 0]);
    catch
    end
end

outputSingleScan(Trigger_S,[0 0 0])

if handles2give.opto_session && ~handles2give.wf_session
    try
        queueOutputData(Opto_S, [opto_vec; galv_x; galv_y]')
        pause(.1)

    catch
        disp(['Error preloading Opto_S coords ap ml: ' num2str(AP) ' ' num2str(ML)])
        disp(Opto_S)
    end
    Opto_S.startBackground();

elseif handles2give.opto_session && handles2give.wf_session
    try
        queueOutputData(Opto_S, [opto_vec(1:end-1); galv_x(1:end-1); galv_y(1:end-1); wf_cam_vec]')
        pause(.1)

    catch
        disp(['Error preloading Opto_S coords ap ml: ' num2str(AP) ' ' num2str(ML)])
        disp(Opto_S)
    end
    Opto_S.startBackground();
end

% Queue reward vector
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

% Give user extra time to start video and 2P acquisition before 1st trial start.
% Added to iti condition for trial start in main_control.
if trial_number == 1
    extra_time = 10;
else
    extra_time = 0;
end

end