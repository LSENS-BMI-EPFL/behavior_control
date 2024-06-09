function [output] = rescue_gui()
%RESCUE_GUI Summary of this function goes here
%   Detailed explanation goes here
    global   association_flag response_window trial_duration quiet_window lick_threshold...
        artifact_window iti camera_flag is_stim is_auditory is_whisker is_light is_opto...
        reward_valve_duration  aud_reward wh_reward wh_vec aud_vec light_vec ...
        light_prestim_delay stim_flag perf lick_flag ...
        false_alarm_punish_flag false_alarm_timeout early_lick_punish_flag early_lick_timeout ...
        Stim_S Log_S wh_stim_duration  aud_stim_duration  aud_stim_amp  aud_stim_freq  Stim_S_SR ScansTobeAcquired ...
        Reward_S Reward_S_SR  Trigger_S fid_lick_trace mouse_licked_flag reaction_time ...
        trial_started_flag  trial_number main_pool_size_old opto_stim_proba_old folder_name handles2give...
        stim_proba_old aud_stim_proba_old wh_stim_proba_old opto_aud_proba_old opto_wh_proba_old opto_ctrl_proba_old...
        light_flag baseline_window camera_vec deliver_reward_flag ...
        wh_stim_amp wh_scaling_factor response_window_start response_window_end...
        perf_and_save_results_flag reward_delivered_flag update_parameters_flag...
        is_reward reward_pool partial_reward_flag reward_proba_old...
        light_duration light_freq light_amp light_duty camera_freq SITrigger_vec main_trial_pool...
        whisker_trial_counter mouse_rewarded_context context_block context_flag block_id wh_rewarded_context...
        pink_noise_player brown_noise_player identical_block_count extra_time Context_S...
        WF_S wf_cam_vec LED1_vec LED2_vec opto_vec galv_x galv_y opto_gui Opto_S variables_to_save_opto voltage_x voltage_y bregma_x bregma_y opto_count

    reward_delay_time = 0;
    % Define reward vector
    rew_vec_amp = 5; %volt
    reward_vec = [zeros(1,reward_delay_time) rew_vec_amp*ones(1,reward_valve_duration*Reward_S_SR/1000) zeros(1,Reward_S_SR/2)];
    if ~is_reward || ~is_stim
        reward_vec=zeros(1,numel(reward_vec));
    end

    Stim_S.stop()
    SITrigger_vec=[ones(1,numel(wh_vec)-2) 0 0]; % ScanImage trigger vector
    queueOutputData(Stim_S,[wh_vec; aud_vec; camera_vec; SITrigger_vec]');

    while Stim_S.IsRunning
        disp('Here') %?????
    end
    Stim_S.startBackground();
    outputSingleScan(Trigger_S,[0 0 0]);

    queueOutputData(Opto_S, [opto_vec; galv_x; galv_y]');
    pause(.1)
    Opto_S.startBackground();

    if ~Reward_S.ScansQueued
        queueOutputData(Reward_S, reward_vec')
        while Reward_S.IsRunning
            disp('Here 2')
        end
        Reward_S.startBackground();
    end

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

