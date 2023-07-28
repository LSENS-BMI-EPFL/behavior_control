function wf_setup(trigger)
    arguments
        trigger = 1;
    end
    global WF_S

    WF_S = daq('ni');
    addoutput(WF_S, 'Dev3', 'ao0', 'Voltage');
    addoutput(WF_S, 'Dev3', 'ao1', 'Voltage');
    addoutput(WF_S, 'Dev3', 'ao2', 'Voltage');
    WF_S.Rate = 100000;

%     if trigger
%         addtrigger(WF_S, 'Digital', 'StartTrigger', 'External', 'Dev3/PFI0');
%         WF_S.DigitalTriggerTimeout = Inf;
%     end
    
end