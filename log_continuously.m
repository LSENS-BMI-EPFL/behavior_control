function log_continuously(~, event)

global  Log_S_SR fid_continuous...
        trial_start_ttl lick_threshold handles2give continous_lick_data cam1_ttl cam2_ttl scan_pos

% Get and save data to binary file.
% ---------------------------------

% ai0: lick
% ai1: galvo scanner position
% ai2: trial start ttl
% ai3: camera 1
% ai4: camera 2

data = [event.Data(:,1), event.Data(:,2), event.Data(:,3), event.Data(:,4), event.Data(:,5)]';
fwrite(fid_continuous, data, 'double');


% Plot continuously.
% ------------------

% Plot trial start TTL.

trial_start_ttl = [trial_start_ttl, event.Data(:,3)'];
trial_start_ttl = trial_start_ttl(end-10*Log_S_SR+1:end);
time = [0:numel(trial_start_ttl)-1]/Log_S_SR;
plot(handles2give.TrialStartTTL, time, trial_start_ttl, 'Color', 'k');
ylabel(handles2give.TrialStartTTL,'Trial TTL')
% Set axes limits
ylim(handles2give.TrialStartTTL, [-1 8]);
xlim(handles2give.TrialStartTTL, [0 time(end)]);

% Plot lick traces.

continous_lick_data = [continous_lick_data, abs(event.Data(:,1)')];
continous_lick_data = continous_lick_data(end-10*Log_S_SR+1:end);
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

% Plot camera 1 TTL.

cam1_ttl = [cam1_ttl, event.Data(:,4)'];
cam1_ttl = cam1_ttl(end-10*Log_S_SR+1:end);
time = [0:numel(cam1_ttl)-1]/Log_S_SR;
plot(handles2give.Cam1Ax, time, cam1_ttl, 'Color', 'k'); 
ylabel(handles2give.Cam1Ax,'Cam 1')
% Set axes limits
ylim(handles2give.Cam1Ax, [-1 8]); 
xlim(handles2give.Cam1Ax, [0 time(end)]);

% Plot camera 2 TTL.

cam2_ttl = [cam2_ttl, event.Data(:,5)'];
cam2_ttl = cam2_ttl(end-10*Log_S_SR+1:end);
time = [0:numel(cam2_ttl)-1]/Log_S_SR;
plot(handles2give.Cam2Ax, time, cam2_ttl, 'Color', 'k');
ylabel(handles2give.Cam2Ax,'Cam 2')
% Set axes limits
ylim(handles2give.Cam2Ax, [-1 8]); 
xlim(handles2give.Cam2Ax, [0 time(end)]);

% Plot galvo scanner position.

scan_pos = [scan_pos, event.Data(:,2)'];
scan_pos = scan_pos(end-10*Log_S_SR+1:end);
time = [0:numel(scan_pos)-1]/Log_S_SR;
plot(handles2give.ScanAx, time, scan_pos, 'Color', 'k'); 
ylabel(handles2give.ScanAx,'Galvo')
% Set axes limits
ylim(handles2give.ScanAx, [-2 3]); 
xlim(handles2give.ScanAx, [0 time(end)]);

end
