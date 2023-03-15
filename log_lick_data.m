function log_lick_data(~, event, trial_duration)
% LOG_LICK_DATA Save trial lick data in .bin files and plots lick data for
% GUI.
% EVENT Data detected.
% TRIAL_DURATION Duration of current trial.

global Stim_S Log_S Stim_S_SR fid_lick_trace handles2give lick_threshold trial_lick_data

%% Get lick data and write downsample data in .bin files

% data = [event.TimeStamps(1:10:end,1), event.Data(1:10:end,1)]' ;
% fwrite(fid_lick_trace, data, 'double');

%% Plotting lick data
% Plot progress bar 
plot(handles2give.TrialStartTTL, [event.TimeStamps(end) event.TimeStamps(end)], [0 1], 'LineWidth', 4, 'Color', 'w')
set(handles2give.TrialStartTTL, 'Color',[0.4 0.4 0.4]);
xlim(handles2give.TrialStartTTL, [0 trial_duration/1000])
set(handles2give.TrialStartTTL, 'XTick',[], 'XColor','w', ...
                                   'YTick',[], 'YColor','w', ...
                                   'Box','off')

% Piezo sensor data as absolute signals
trial_lick_data = [trial_lick_data, abs(event.Data(:,1)')];

% Plot trial lick data
% timevec=linspace(0, numel(trial_lick_data)/Stim_S_SR, numel(trial_lick_data)); %x-axis time vector
timevec=linspace(0, numel(trial_lick_data)/Log_S.Rate, numel(trial_lick_data)); %x-axis time vector Log_S.Rate
plot(handles2give.LickTraceAxes2,timevec, trial_lick_data,'Color','k'); %licking trace

% Show lick detection threshold line
line([0 trial_duration/1000], [lick_threshold lick_threshold], ...
    'LineWidth', 1, ...
    'LineStyle', '--', ... 
    'Color', 'r', ...
    'Parent', handles2give.LickTraceAxes2);

% Set axes limits
ylim(handles2give.LickTraceAxes2, [0 lick_threshold*5]);
xlim(handles2give.LickTraceAxes2, [0 trial_duration/1000]);
set(handles2give.LickTraceAxes2, 'XTick', [])



