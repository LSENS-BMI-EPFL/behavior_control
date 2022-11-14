function log_lick_data(~, evt, TrialDuration)
% LOG_LICK_DATA Save trial lick data in .bin files and plots lick data for
% GUI.
% EVT
% TRIALDURATION Duration of current trial.

global Stim_S fid3 handles2give Lick_Threshold Stim_S_SR TrialLickData

%% Get lick data and write downsample in .bin files
[data_stim, timestamps, trigger_time] = read(Stim_S, Stim_S.ScansAvailableFcnCount,'OutputFormat','Matrix');

data = [timestamps(:,1), data_stim(:,:)]';
fwrite(fid3, downsample(data, 10),'double');

%% Plotting lick data
% Plot progress bar 
plot(handles2give.ProgressBarAxes, [timestamps(end) timestamps(end)], [0 1], 'LineWidth',4, 'Color','w')
set(handles2give.ProgressBarAxes, 'Color',[0.4 0.4 0.4]);
xlim(handles2give.ProgressBarAxes, [0 TrialDuration/1000])
set(handles2give.ProgressBarAxes, 'XTick',[], 'XColor','w', ...
                                   'YTick',[], 'YColor','w', ...
                                   'Box','off')

% Plot trial lick data
TrialLickData = [TrialLickData, abs(data(2,:))];

timevec=linspace(0,numel(TrialLickData)/Stim_S_SR,numel(TrialLickData)); %X-axis time vector
plot(handles2give.LickTraceAxes2,timevec,TrialLickData,'Color','k'); %Licking trace
line([0 TrialDuration/1000],[Lick_Threshold Lick_Threshold],'LineWidth',1,'LineStyle','--',... % Licking threshold line
    'Color','r','Parent', handles2give.LickTraceAxes2);

% Set axes limits
ylim(handles2give.LickTraceAxes2,[0 Lick_Threshold*5]);
xlim(handles2give.LickTraceAxes2,[0 TrialDuration/1000]);
set(handles2give.LickTraceAxes2,'XTick',[])



