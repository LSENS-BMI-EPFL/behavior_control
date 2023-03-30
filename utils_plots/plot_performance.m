function plot_performance(results, perf_win_size)
% PLOT_PERFORMANCE Plot performance metrics on GUI, given results
% data and sliding window length (in number of trials).
%
% RESULTS: results structure to compute metrics from.
% PERF_WIN_SIZE: Length of window to compute metrics in.

global handles2give wh_reward

% Count current trial number (omitting early licks and association trials).
n_current_trials = sum(sum(results.perf~=6));

% Set plotting params
lw = 1.5;
acolor = [0 0.4470 0.7410];
acolor_str = '0 0.4470 0.7410';
if wh_reward
    wcolor = [0.4660 0.6740 0.1880]';
    wcolor_str = '0.4660 0.6740 0.1880';
else
    wcolor = [0.6350 0.0780 0.1840];
    wcolor_str = '0.6350 0.0780 0.1840';
end

%% Plot hit rates and false alarm rates
if n_current_trials > 0
    
    perf = results.perf(results.perf~=6);
    stim_trials = results.is_stim(results.perf~=6);
    wh_trials = results.is_whisker(results.perf~=6);
    aud_trials = results.is_auditory(results.perf~=6);

    current_trials = 1:n_current_trials;
    aud_HR = zeros(1,n_current_trials);
    wh_HR = zeros(1,n_current_trials);
    FAR = zeros(1,n_current_trials);
 

    hax = handles2give.PerformanceAxes;
    
    % Compute performance in window
    for trial = current_trials
        indices = max(1, trial-perf_win_size+1):trial; % This gets indices of all trials in window before trial
        aud_HR(trial)=sum(perf(indices) == 3)/sum(aud_trials(indices)== 1);
        wh_HR(trial)=sum(perf(indices) == 2)/sum(wh_trials(indices) == 1);
        FAR(trial)=sum(perf(indices) == 5)/sum(stim_trials(indices) == 0);
    end

    
    % Plot performance curves
    stairs(hax,current_trials,aud_HR,'LineWidth',lw,'Color',acolor);
    hold (hax,'on')
    stairs(hax,current_trials,wh_HR,'LineWidth',lw,'Color',wcolor);
    hold (hax,'on')
    stairs(hax,current_trials,FAR,'LineWidth',lw,'Color','black') 
    hold (hax,'off')

    % Labels and axes limits
    if wh_reward
        ylabel(hax, '\fontsize{11} {\color[rgb]{0 0.4470 0.7410}A Hit rate} / {\color[rgb]{0.4660 0.6740 0.1880}W Hit rate} / {\color{black}FA rate}')
    else
        ylabel(hax, '\fontsize{11} {\color[rgb]{0 0.4470 0.7410}A Hit rate} / {\color[rgb]{0.6350 0.0780 0.18400}W Hit rate} / {\color{black}FA rate}')
    end

    if n_current_trials>1
        xlim(hax,[1 n_current_trials])
    end
    xlabel(hax, 'Trial number')

    % Define tick placements and number regularly
    h_ticks=1:ceil(n_current_trials/10):n_current_trials;
    if ~ismember(h_ticks,n_current_trials)
        h_ticks=[h_ticks n_current_trials];
    end
    set(hax,'XTick', h_ticks)
    set(hax,'YLim',[0 1])
    set(hax,'YTick',0:.2:1)
    set(hax,'Box','off')
end

%% Plot early-lick rate 
if sum(results.perf==6) >= 1
    EarlyLicksCount=zeros(1, size(results.trial_number));
    for i=1:size(results.trial_number)
        indices=max(1,i-perf_win_size):i;
        EarlyLicksCount(i)=sum(results.early_lick(indices))/length(indices); %Early lick rate from results, at each "real" trial
    end
    stairs(handles2give.EarlyLickAxes, 1:size(results.trial_number),EarlyLicksCount, 'LineWidth',lw, 'Color','k')
    h_ticks = 1:ceil(size(results.trial_number)/10):size(results.trial_number);
    if ~ismember(h_ticks, size(rresults.trial_number))
        h_ticks = [h_ticks  size(results.trial_number)];
    end
    set(handles2give.EarlyLickAxes,'XTick', h_ticks)
    ylabel(handles2give.EarlyLickAxes,'Early Lick rate')
    xlabel(handles2give.EarlyLickAxes,'Trial number')
    ylim(handles2give.EarlyLickAxes,[0 1])
end