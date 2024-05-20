function [t, opto_vec] = get_opto_vec(trial_duration)
%GET_OPTO_VEC Generate Optogenetic pulse trains and return time vector t
%and opto_vec with the values at each time.

    arguments
        trial_duration = 1; % Seconds
    end

    global Opto_info Opto_S
    
    % Make laser vector
    t = 0:1/Opto_S.Rate:trial_duration; % time vector
    w = Opto_info.pulse_width; % pulse width
    d = get_envelope;
    
    % Determine shape of pulse
    if strcmp(Opto_info.pulse_shape, 'square')
        y = pulstran(t(1:Opto_info.duration*2*Opto_S.Rate), d, 'rectpuls', w);
        
    elseif strcmp(Opto_info.pulse_shape, 'cosine')
        pp = [hanning(Opto_info.pulse_width*Opto_S.Rate)' zeros(1, ...
            fix((1/Opto_info.frequency-Opto_info.pulse_width)*Opto_S.Rate))];
        y = pulstran(t(1:end/2), d, pp, Opto_S.Rate);
    end

    
    opto_vec = Opto_info.amplitude*[zeros([1,round(Opto_info.baseline*Opto_S.Rate)]) y ...
        zeros([1, round((trial_duration-Opto_info.baseline-length(y)/Opto_S.Rate)*Opto_S.Rate)+1])];
    opto_vec(opto_vec==0) = -1;
end

