function log_continuously(~, event)

global  Log_S_SR fid_continuous ...
        trial_start_ttl lick_threshold handles2give continuous_lick_data cam1_ttl cam2_ttl ...
        scan_pos context_flag context_ttl wh_rewarded_context ttl_ch1 ttl_ch2

% Channel map in acquisition order:
% 1  -> ai0   : lick dummy
% 1  -> ai0   : lick 
% 2  -> ai1   : galvo scanner position
% 3  -> ai2   : trial start ttl
% 4  -> ai3   : camera 1
% 5  -> ai4   : camera 2
% 6  -> ai5   : context transition
% 7  -> ai6   : TTL ch1
% 8  -> ai7   : TTL ch2

%% Save data to binary file
% event.Data is [samples x channels]
% data becomes [channels x samples]
data = event.Data.';
fwrite(fid_continuous, data, 'double');

%% Extract channels once for readability
lick          = event.Data(:,1).';
galvo         = event.Data(:,2).';
trial_ttl     = event.Data(:,3).';
cam1          = event.Data(:,4).';
cam2          = event.Data(:,5).';
context_trans = event.Data(:,6).';
ttl1          = event.Data(:,7).';   % ai6
ttl2          = event.Data(:,8).';   % ai7
dummy_ch1     = event.Data(:,9).';   % ai16
dummy_ch2     = event.Data(:,10).';  % ai17
%% Plot continuously

% ------------------------------
% Plot trial start TTL + context
% ------------------------------
trial_start_ttl = [trial_start_ttl, trial_ttl];
trial_start_ttl = trial_start_ttl(max(1, numel(trial_start_ttl) - 10*Log_S_SR + 1):end);
time = (0:numel(trial_start_ttl)-1) / Log_S_SR;

if context_flag
    context_ttl = [context_ttl, context_trans];
    context_ttl = context_ttl(max(1, numel(context_ttl) - 10*Log_S_SR + 1):end);

    if wh_rewarded_context
        context_color = 'g';
    else
        context_color = 'r';
    end

    n = min(numel(trial_start_ttl), numel(context_ttl));
    plot(handles2give.TrialStartTTL, ...
        time(end-n+1:end), trial_start_ttl(end-n+1:end), 'k', ...
        time(end-n+1:end), context_ttl(end-n+1:end), context_color);
else
    plot(handles2give.TrialStartTTL, time, trial_start_ttl, 'k');
end

ylabel(handles2give.TrialStartTTL, 'Trial TTL');
ylim(handles2give.TrialStartTTL, [-1 8]);
if ~isempty(time)
    xlim(handles2give.TrialStartTTL, [0 time(end)]);
end

% ----------------
% Plot lick traces
% ----------------
continuous_lick_data = [continuous_lick_data, abs(lick)];
continuous_lick_data = continuous_lick_data(max(1, numel(continuous_lick_data) - 10*Log_S_SR + 1):end);
time = (0:numel(continuous_lick_data)-1) / Log_S_SR;

cla(handles2give.LickTraceAx);
plot(handles2give.LickTraceAx, time, continuous_lick_data, 'k');
hold(handles2give.LickTraceAx, 'on');
yline(handles2give.LickTraceAx, lick_threshold, '--r', 'LineWidth', 1);
hold(handles2give.LickTraceAx, 'off');

ylabel(handles2give.LickTraceAx, 'Lick');
ylim(handles2give.LickTraceAx, [0 lick_threshold*5]);
if ~isempty(time)
    xlim(handles2give.LickTraceAx, [0 time(end)]);
end

% ----------------
% Plot camera 1 TTL
% ----------------
cam1_ttl = [cam1_ttl, cam1];
cam1_ttl = cam1_ttl(max(1, numel(cam1_ttl) - 10*Log_S_SR + 1):end);
time = (0:numel(cam1_ttl)-1) / Log_S_SR;

plot(handles2give.Cam1Ax, time, cam1_ttl, 'k');
ylabel(handles2give.Cam1Ax, 'Cam 1');
ylim(handles2give.Cam1Ax, [-1 8]);
if ~isempty(time)
    xlim(handles2give.Cam1Ax, [0 time(end)]);
end

% ----------------
% Plot camera 2 TTL
% ----------------
cam2_ttl = [cam2_ttl, cam2];
cam2_ttl = cam2_ttl(max(1, numel(cam2_ttl) - 10*Log_S_SR + 1):end);
time = (0:numel(cam2_ttl)-1) / Log_S_SR;

plot(handles2give.Cam2Ax, time, cam2_ttl, 'k');
ylabel(handles2give.Cam2Ax, 'Cam 2');
ylim(handles2give.Cam2Ax, [-1 8]);
if ~isempty(time)
    xlim(handles2give.Cam2Ax, [0 time(end)]);
end

% --------------------------
% Plot galvo scanner position
% --------------------------
scan_pos = [scan_pos, galvo];
scan_pos = scan_pos(max(1, numel(scan_pos) - 10*Log_S_SR + 1):end);
time = (0:numel(scan_pos)-1) / Log_S_SR;

plot(handles2give.ScanAx, time, scan_pos, 'k');
ylabel(handles2give.ScanAx, 'Galvo');
ylim(handles2give.ScanAx, [-2 3]);
if ~isempty(time)
    xlim(handles2give.ScanAx, [0 time(end)]);
end

% ----------------------
% Plot TTL ch1 and ch2
% ----------------------
ttl_ch1 = [ttl_ch1, ttl1];
ttl_ch1 = ttl_ch1(max(1, numel(ttl_ch1) - 10*Log_S_SR + 1):end);

ttl_ch2 = [ttl_ch2, ttl2];
ttl_ch2 = ttl_ch2(max(1, numel(ttl_ch2) - 10*Log_S_SR + 1):end);


n = min(numel(ttl_ch1), numel(ttl_ch2));
if n > 0
    ttl_ch1_plot = ttl_ch1(end-n+1:end);
    ttl_ch2_plot = ttl_ch2(end-n+1:end);
    time = (0:n-1) / Log_S_SR;

    cla(handles2give.LightAx, 'reset');
    hold(handles2give.LightAx, 'on');

    plot(handles2give.LightAx, time, ttl_ch1_plot, 'Color', [0.5 0 0.5], 'LineWidth', 1);
    plot(handles2give.LightAx, time, ttl_ch2_plot, 'Color', [0 0.6 0], 'LineWidth', 1);

    hold(handles2give.LightAx, 'off');

    ylabel(handles2give.LightAx, 'TTL ch1/ch2', 'Color', 'k');
    xlabel(handles2give.LightAx, 'Time (s)', 'Color', 'k');

    ylim(handles2give.LightAx, [-1 8]);
    xlim(handles2give.LightAx, [0 time(end)]);

    set(handles2give.LightAx, ...
        'Box', 'on', ...
        'Color', [1 1 1], ...
        'XColor', [0 0 0], ...
        'YColor', [0 0 0], ...
        'Visible', 'on');
end
end