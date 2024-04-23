function opto_setup(trigger)
%OPTO_SETUP Summary of this function goes here
%   Detailed explanation goes here

    arguments
        trigger = 0;
    end
    global Opto_S

    % TBD switch to new nomenclature for daq objects
%     Opto_S = daq('ni');
%     addoutput(Opto_S, 'Dev3', 'ao4', 'Voltage'); % Laser output
%     addoutput(Opto_S, 'Dev3', 'ao5', 'Voltage'); % Galvo X output
%     addoutput(Opto_S, 'Dev3', 'ao6', 'Voltage'); % Galvo Y output
%     Opto_S.Rate = 100000;
% 
%     if trigger
%         addtrigger(Opto_S, 'Digital', 'StartTrigger', 'External', 'Dev3/PFI0');
%         Opto_S.DigitalTriggerTimeout = Inf;
%     end
    
    % For old daq session configuration
    Opto_S = daq.createSession('ni');
    addAnalogOutputChannel(Opto_S,'Dev3','ao4', 'Voltage');
    addAnalogOutputChannel(Opto_S,'Dev3','ao5', 'Voltage');
    addAnalogOutputChannel(Opto_S,'Dev3','ao6', 'Voltage');
    Opto_S.Rate = 100000;
    if trigger
        Opto_S.IsContinuous = true;
        addTriggerConnection(Opto_S,'External','Dev3/PFI0','StartTrigger');
        Opto_S.ExternalTriggerTimeout = Inf;
    end
end

