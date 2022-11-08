function plot_performance(Results, perf_win_size)
% Plot performance metrics on GUI, given Results
% data and sliding window length (in number of trials).

% Results: Results structure to compute metrics from.
% perf_win_size: Length of window to compute metrics in.

global handles2give wh_rew

% Count current trial number (omitting early licks).
n_current_trials = sum(Results.data(:,10) ~= 6);

% Set plotting params
lw = 1.5;
acolor = [0 0.4470 0.7410];
acolor_str = '0 0.4470 0.7410';
if wh_rew
    wcolor = [0.6350 0.0780 0.1840];
    wcolor_str = '0.6350 0.0780 0.1840';
else
    wcolor = [0.4660 0.6740 0.1880]';
    wcolor_str = '0.4660 0.6740 0.1880';
end

%% Plot hit rates and false alarm rates
if n_current_trials > 0
    perf = Results.data(Results.data(:,10) ~= 6,10);
    aud_trials = Results.data(Results.data(:,10) ~= 6,8);
    wh_trials = Results.data(Results.data(:,10) ~= 6,7);
    stim_trials = Results.data(Results.data(:,10) ~= 6,6);

    x = 1:n_current_trials;
    aud_HR = zeros(1,length(x));
    wh_HR = zeros(1,length(x));
    FA = zeros(1,length(x));

    hax = handles2give.PerformanceAxes;

    for ix = x
        indices = max(1,ix-perf_win_size+1):ix; % This gets indices of all trials in window before ix
        aud_HR(ix)=sum(perf(indices) == 3)/sum(aud_trials(indices)== 1);
        wh_HR(ix)=sum(perf(indices) == 2)/sum(wh_trials(indices) == 1);
        FA(ix)=sum(perf(indices) == 5)/sum(stim_trials(indices) == 0);
    end

    stairs(hax,x,aud_HR,'LineWidth',lw,'Color',acolor);
    hold (hax,'on')
    stairs(hax,x,wh_HR,'LineWidth',lw,'Color',wcolor);
    hold (hax,'on')
    stairs(hax,x,FA,'LineWidth',lw,'Color','black') 
    hold (hax,'off')

    % Labels and axes limits
    if wh_rew
        ylabel(hax, '\fontsize{11} {\color[rgb]{0 0.4470 0.7410}A Hit rate} / {\color[rgb]{0.6350 0.0780 0.1840}W Hit rate} / {\color{black}FA rate}')
    else
        ylabel(hax, '\fontsize{11} {\color[rgb]{0 0.4470 0.7410}A Hit rate} / {\color[rgb]{0.4660 0.6740 0.1880}W Hit rate} / {\color{black}FA rate}')
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
if sum(Results.data(:,10)==6) >= 1
    EarlyLicksCount=zeros(1, size(Results.data,1));
    for i=1:size(Results.data,1)
        indices=max(1,i-perf_win_size):i;
        EarlyLicksCount(i)=sum(Results.data(indices,10)==6)/length(indices); %Early lick rate from Results, at each "real" trial
    end
    stairs(handles2give.EarlyLickAxes, 1:size(Results.data,1),EarlyLicksCount, 'LineWidth',lw, 'Color','k')
    h_ticks = 1:ceil(size(Results.data,1)/10):size(Results.data,1);
    if ~ismember(h_ticks, size(Results.data,1))
        h_ticks = [h_ticks  size(Results.data,1)];
    end
    set(handles2give.EarlyLickAxes,'XTick', h_ticks)
    ylabel(handles2give.EarlyLickAxes,'Early Lick rate')
    xlabel(handles2give.EarlyLickAxes,'Trial number')
    ylim(handles2give.EarlyLickAxes,[0 1])
end