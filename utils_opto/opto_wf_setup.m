function opto_wf_setup(trigger)
%OPTO_SETUP Summary of this function goes here
%   Detailed explanation goes here

    arguments
        trigger = 0;
    end
    global Opto_S
    
    % For old daq session configuration
    Opto_S = daq.createSession('ni');
    addAnalogOutputChannel(Opto_S, 'Dev3', 'ao4', 'Voltage');
    addAnalogOutputChannel(Opto_S, 'Dev3', 'ao5', 'Voltage');
    addAnalogOutputChannel(Opto_S, 'Dev3', 'ao6', 'Voltage');
    addAnalogOutputChannel(Opto_S, 'Dev3', 'ao0', 'Voltage'); % WF Camera output
   
    Opto_S.Rate = 100000;
    Opto_S.IsContinuous = true;
    addTriggerConnection(Opto_S,'External','Dev3/PFI0','StartTrigger');
    Opto_S.ExternalTriggerTimeout = Inf;

end

