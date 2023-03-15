function log_continuously(~, event)

global  Log_S lh4 fid_continuous ...
        trial_start_ttl lick_threshold handles2give trial_duration continous_lick_data cam1_ttl cam2_ttl scan_pos

%% Get and save data to .bin file.

% ai0: lick
% ai1: galvo scanner position
% ai2: trial start ttl
% ai3: camera 1
% ai4: camera 2

data = [event.Data(:,1), event.Data(:,2), event.Data(:,3), event.Data(:,4), event.Data(:,5)]';
fwrite(fid_continuous, data, 'double');

%% Plot continuously.

% Plot trial start.

trial_start_ttl = [trial_start_ttl, event.Data(:,3)'];
trial_start_ttl = trial_start_ttl(end-trial_duration*Log_S.Rate/1000:end);
time = [0:numel(trial_start_ttl)-1]/Log_S.Rate;
plot(handles2give.TrialStartTTL, time, trial_start_ttl, 'Color', 'k'); 
ylabel(handles2give.TrialStartTTL,'Trial TTL')
% Set axes limits
ylim(handles2give.TrialStartTTL, [0 8]); 
xlim(handles2give.TrialStartTTL, [0 time(end)]);

% plot lick traces 
continous_lick_data = [continous_lick_data, abs(event.Data(:,1)')];
continous_lick_data = continous_lick_data(end-trial_duration*Log_S.Rate/1000:end);
plot(handles2give.LickTraceAx, time, continous_lick_data, 'Color', 'k'); 
% Set axes limits
ylim(handles2give.LickTraceAx, [0 lick_threshold*5]); 
xlim(handles2give.LickTraceAx, [0 time(end)]);
ylabel(handles2give.LickTraceAx,'Lick')
% Plot lick treshold
line([0 time(end)],[lick_threshold lick_threshold], ...
    'LineWidth',1, ...
    'LineStyle','--',...
    'Color','r', ...
    'Parent', handles2give.LickTraceAx);

% Plot cam 1

cam1_ttl = [cam1_ttl, event.Data(:,4)'];
cam1_ttl = cam1_ttl(end-trial_duration*Log_S.Rate/1000:end);
time = [0:numel(cam1_ttl)-1]/Log_S.Rate;
plot(handles2give.Cam1Ax, time, cam1_ttl, 'Color', 'k'); 
ylabel(handles2give.Cam1Ax,'Cam 1')
% Set axes limits
ylim(handles2give.Cam1Ax, [0 8]); 
xlim(handles2give.Cam1Ax, [0 time(end)]);

% Plot cam 2

cam2_ttl = [cam2_ttl, event.Data(:,5)'];
cam2_ttl = cam2_ttl(end-trial_duration*Log_S.Rate/1000:end);
time = [0:numel(cam2_ttl)-1]/Log_S.Rate;
plot(handles2give.Cam2Ax, time, cam2_ttl, 'Color', 'k');
ylabel(handles2give.Cam2Ax,'Cam 2')
% Set axes limits
ylim(handles2give.Cam2Ax, [0 8]); 
xlim(handles2give.Cam2Ax, [0 time(end)]);


% Plot scan pos

scan_pos = [scan_pos, event.Data(:,2)'];
scan_pos = scan_pos(end-trial_duration*Log_S.Rate/1000:end);
time = [0:numel(scan_pos)-1]/Log_S.Rate;
plot(handles2give.ScanAx, time, scan_pos, 'Color', 'k'); 
ylabel(handles2give.ScanAx,'Galvo')
% Set axes limits
ylim(handles2give.ScanAx, [-1 3]); 
xlim(handles2give.ScanAx, [0 time(end)]);


end
