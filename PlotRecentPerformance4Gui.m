function PlotRecentPerformance4Gui(Results, perf_win_size)
% PLOTRECENTPERFORMANCE4GUI Plot performance metrics on GUI, given Results
% data and sliding window length (in number of trials).

% Results: Results structure to compute metrics from.
% perf_win_size: Length of window to compute metrics in.

global handles2give wh_rew

% Count current trial number (omitting early licks).
n_current_trials = sum(Results.data(:,10) ~= 6);

% Set plotting params
lw = 1.5;
if wh_rew %currently not used
    wcolor = 'green';
    wcolor_rgb = '0.4660 0.6740 0.1880';
else
    wcolor = 'r';
    wcolor_rgb = '1 0 0';
end

%% Plot hit rates and false alarm rates
if n_current_trials > 0
    
perf = Results.data(Results.data(:,10) ~= 6,10);
aud_trials = Results.data(Results.data(:,10) ~= 6,8);
wh_trials = Results.data(Results.data(:,10) ~= 6,7);
stim = Results.data(Results.data(:,10) ~= 6,6);

 % If current trial number SMALLER than window size, plot metrics for all
 % available trials
if n_current_trials <= perf_win_size
    AHitRate=zeros(1,n_current_trials); % Init vectors
    WHitRate=zeros(1,n_current_trials);
    FalseAlarm=zeros(1,n_current_trials);
    Adprime=zeros(1,n_current_trials);
    Wdprime=zeros(1,n_current_trials);
    
    for i=1:n_current_trials
        Indices=max(1, i-perf_win_size):i; % Get trial indices
        AHitRate(i)=sum(perf(Indices)==3)/sum(aud_trials(Indices)== 1); % Compute rates
        WHitRate(i)=sum(perf(Indices)==2)/sum(wh_trials(Indices) == 1);
        FalseAlarm(i)=sum(perf(Indices)==5)/sum(stim==0);
        
        Adprime(i)=norminv(AHitRate(i))-norminv(FalseAlarm(i)); % Compute d-prime
        Wdprime(i)=norminv(WHitRate(i))-norminv(FalseAlarm(i));
    end

    x=1:n_current_trials; % Make x-axis vector
    [hAx,hAHit,hWHit] = plotyy(handles2give.PerformanceAxes, ...
                                        x, AHitRate, ...
                                        x, WHitRate, ...
                                        @stairs, @stairs); %Plot using this function
    
    % Set axes
    set(hAx(1),'YLim',[0 1]) % rate limit
    set(hAx(1),'YTick',0:.2:1)
    
    set(hAx(2),'YLim',[0 3]) %d-prime limit
    set(hAx(2),'YTick',0:.5:3)
    
    set(hAx(1),'Box','off')
    
    set(hAHit,'LineWidth',lw)
    set(hWHit,'LineWidth',lw)

    hold (handles2give.PerformanceAxes,'on')
    stairs(hAx(1),x,FalseAlarm,'LineWidth',lw,'Color','black') 

    % Colors
    set(hAHit,'color','blue');
    set(hWHit,'color','green');
    set(hAx,{'ycolor'},{'k';'k'})
    
    % Labels and axes limits
    ylabel(hAx(1), '\fontsize{11} {\color{blue}A Hit rate} / {\color[rgb]{0.4660 0.6740 0.1880}W Hit rate} / {\color{black}FA rate}')    
    ylabel(hAx(2), '\fontsize{11} {\color{blue}A d-prime} / {\color[rgb]{0.4660 0.6740 0.1880}W d-prime}')
    
    if size(Results.data,1)>1
        xlim(hAx(1),[1 max(2,n_current_trials)])
        xlim(hAx(2),[1 max(2,n_current_trials)])
    end
    xlabel(handles2give.PerformanceAxes, 'Trial number')

     % Define tick placements and number regularly
    TICKS=1:ceil(size(Results.data,1)/10):size(Results.data,1);
    if ~ismember(TICKS,size(Results.data,1))
        TICKS=[TICKS size(Results.data,1)];
    end
    set(handles2give.PerformanceAxes,'XTick', TICKS)
    
    hold (handles2give.PerformanceAxes,'off')

% Else, if current trial index LARGER than window size, then compute
% metrics in latest trials
else
    minindex=min(perf_win_size,n_current_trials);
    Trials=minindex:n_current_trials; % Get all trials satisfying the above if condition i.e. excludes all trial indices below window size
    AHitRate=zeros(1,length(Trials)); % Init vectors
    WHitRate=zeros(1,length(Trials));
    FalseAlarm=zeros(1,length(Trials));
    Adprime=zeros(1,length(Trials));
    Wdprime=zeros(1,length(Trials));
    Counter=0;

    for ThisTrial=Trials %Compute metrics for all trials, in window defined
        Counter=Counter+1;
        Indices=max(1, ThisTrial-perf_win_size):ThisTrial; % This gets indices of all trials in window before ThisTrial
        AHitRate(Counter)=sum(perf(Indices) == 3)/sum(aud_trials(Indices)== 1);
        WHitRate(Counter)=sum(perf(Indices) == 2)/sum(wh_trials(Indices) == 1);
        FalseAlarm(Counter)=sum(perf(Indices) == 5)/sum(stim(Indices) == 0);
        
        Adprime(Counter)=norminv(AHitRate(Counter))-norminv(FalseAlarm(Counter));
        Wdprime(Counter)=norminv(WHitRate(Counter))-norminv(FalseAlarm(Counter));
    end
    % note: plotyy not recommended, use yyaxis now
    [hAx,hAHit,hWHit] = plotyy(handles2give.PerformanceAxes, Trials, AHitRate, ...
                                                             Trials, WHitRate, ...
                                                             @stairs,@stairs); % plot using this function
    
    % Set axes
    set(hAx(1),'YLim',[0 1])
    set(hAx(1),'YTick',0:.2:1)
    
    set(hAx(2),'YLim',[0 3])
    set(hAx(2),'YTick',0:.5:3)
    
    set(hAx(1),'Box','off')
    
    set(hAHit,'LineWidth',lw)
    set(hWHit,'LineWidth',lw)

    hold (handles2give.PerformanceAxes,'on')

    stairs(hAx(1),Trials,FalseAlarm,'LineWidth',lw,'Color','black') 
    stairs(hAx(1),Trials,Adprime,'LineWidth',lw,'Color','blue', 'LineStyle',':') 
    stairs(hAx(1),Trials,Wdprime,'LineWidth',lw,'Color','green', 'LineStyle',':') 

    % Colors
    set(hAHit,'color','blue');
    set(hWHit,'color','green');
    set(hAx,{'ycolor'},{'k';'k'})

     % Labels and axes limits
    ylabel(hAx(1),'\fontsize{11} {\color{blue}A Hit rate} / {\color[rgb]{0.4660 0.6740 0.1880}W Hit rate}/ {\color{black}FAR}') % left y-axis    
    ylabel(hAx(2),'\fontsize{11} {\color{blue}A d-prime}/ {\color[rgb]{0.4660 0.6740 0.1880}W d-prime}') % left y-axis

    xlim(hAx(1),[minindex n_current_trials])
    xlim(hAx(2),[minindex n_current_trials])
    xlabel(handles2give.PerformanceAxes, 'Trial number')
    
    % Define tick placements and number regularly
    TICKS=minindex:ceil(n_current_trials/10):n_current_trials;
    if ~ismember(TICKS,n_current_trials)
        TICKS=[TICKS n_current_trials];
    end
    set(handles2give.PerformanceAxes,'XTick', TICKS)
    
    hold (handles2give.PerformanceAxes,'off')
end
end

%% Plot early-lick rate 
if sum(Results.data(:,10)==6) >= 1
    EarlyLicksCount=zeros(1,n_current_trials);
    
    for i=1:n_current_trials
        Indices=max(1, i-perf_win_size):i;
        EarlyLicksCount(i)=sum(Results.data(Indices,10)==6)/length(Indices); %Early lick rate from Results, at each trial
    end

    stairs(handles2give.EarlyLickAxes, 1:n_current_trials,EarlyLicksCount, 'LineWidth',lw, 'Color','k') 
    
    set(handles2give.EarlyLickAxes,'XTick', 1:ceil(n_current_trials/10):n_current_trials)
    ylabel(handles2give.EarlyLickAxes,'Early Lick rate')
    xlabel(handles2give.EarlyLickAxes,'Trial number')
    ylim(handles2give.EarlyLickAxes,[0 1])
end