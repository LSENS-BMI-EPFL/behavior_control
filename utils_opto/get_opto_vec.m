function [t, opto_vec] = get_opto_vec(trial_duration)
%GET_OPTO_VEC Summary of this function goes here
%   Detailed explanation goes here
    arguments
        trial_duration = 1;
    end

    global Opto_info Opto_S
    
    % Make laser vector
    t = 0:1/Opto_S.Rate:trial_duration; % time vector
    w = Opto_info.pulse_width; % pulse width
    d = get_envelope;

    if strcmp(Opto_info.pulse_shape, 'square')
        y = pulstran(t(1:end/2), d, 'rectpuls', w);

    elseif strcmp(Opto_info.pulse_shape, 'cosine')
        pp = [hanning(Opto_info.pulse_width*Opto_S.Rate)' zeros(1, ...
            fix((1/Opto_info.frequency-Opto_info.pulse_width)*Opto_S.Rate))];
        y = pulstran(t(1:end/2), d, pp, Opto_S.Rate);
    end

    opto_vec = Opto_info.amplitude*[zeros([1,Opto_info.baseline*Opto_S.Rate]) y ...
        zeros([1, round((trial_duration-Opto_info.baseline-length(y)/Opto_S.Rate)*Opto_S.Rate)+1])];

end

