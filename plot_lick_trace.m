function PlotLickTraceNew(~,event,TrialDuration)
% PLOTLICKTRACENEW Plot lick trace from piezo sensor.
% 	EVENT
%   TRIALDURATION Duration of current trial.

global LocalCounter Times Data handles2give Lick_Threshold Main_S_SR

LocalCounter=LocalCounter+1;
Times=[Times; event.TimeStamps];
Data=[Data; event.Data(:,1)]; % Get lick whole trial data


if length(Data)>TrialDuration*Main_S_SR/1000 && LocalCounter>40 % --- What is LocalCounter? -- Is if needed here?
    Times=Times(end-TrialDuration*Main_S_SR/1000:end); 
    Data=Data(end-TrialDuration*Main_S_SR/1000:end); % Get only TrialDuration before trial end
    LocalCounter=0;
    
    plot(handles2give.LickTraceAxes, Times-Times(1),abs(Data), 'Color','k'); % Lick data
    line([0 Times(end)-Times(1)],[Lick_Threshold Lick_Threshold], 'LineWidth',1, 'LineStyle','--',... % Treshold line
        'Color','r', 'Parent', handles2give.LickTraceAxes);
  
    ylim(handles2give.LickTraceAxes, [0 Lick_Threshold*5]); % Set axes limits
    xlim(handles2give.LickTraceAxes, [0 Times(end)-Times(1)]);

end
