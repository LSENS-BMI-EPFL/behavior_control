function plot_lick_trace(~,event,trial_duration)
% PLOTLICKTRACENEW Plot lick trace from piezo sensor.
% 	EVENT
%   TRIALDURATION Duration of current trial.

global local_counter lick_channel_times lick_data handles2give lick_threshold Main_S_SR

local_counter=local_counter+1; %-> what is this? useful?

%% Get data available
lick_channel_times=[lick_channel_times; event.TimeStamps];
lick_data=[lick_data; event.Data(:,1)]; % Get lick whole trial data

%% Plot lick data if more data than trial_duration
if length(lick_data)>trial_duration*Main_S_SR/1000 && local_counter>40 
    lick_channel_times=lick_channel_times(end-trial_duration*Main_S_SR/1000:end); 

    % Get only most recent lick data (trial duration)
    lick_data=lick_data(end-trial_duration*Main_S_SR/1000:end);
    local_counter=0;
    
    % Plot lick data
    plot(handles2give.LickTraceAxes, lick_channel_times-lick_channel_times(1), abs(lick_data), 'Color','k'); 

    % Plot lick treshold
    line([0 lick_channel_times(end)-lick_channel_times(1)],[lick_threshold lick_threshold], ...
        'LineWidth',1, ...
        'LineStyle','--',... 
        'Color','r', ...
        'Parent', handles2give.LickTraceAxes);

    % Set axes limits
    ylim(handles2give.LickTraceAxes, [0 lick_threshold*5]); 
    xlim(handles2give.LickTraceAxes, [0 lick_channel_times(end)-lick_channel_times(1)]);

end
