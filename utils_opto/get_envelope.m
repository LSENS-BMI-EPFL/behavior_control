function d = get_envelope
%GET_ENVELOPE Summary of this function goes here
%   Detailed explanation goes here
    global Opto_info
    switch Opto_info.envelope
        case 'None'
            d = Opto_info.pulse_width/2 : 1/Opto_info.frequency : Opto_info.duration;
    
        case 'Gaussian'
            d = [Opto_info.pulse_width/2 : 1/Opto_info.frequency : Opto_info.duration;...
                2*sin(2*pi*1*(Opto_info.pulse_width/2:1/Opto_info.frequency:Opto_info.duration))]';
            d(d(:,2)>1,2) = 1;
    
        case 'Ramp' % By default ramp down in the last 100ms Esmaeili, Tamura 2021
            if Opto_info.frequency >= 40
                time = Opto_info.pulse_width/2 : 1/Opto_info.frequency : Opto_info.duration+0.1;
                d = [time;...
                    [ones(1, length(time)- 0.1*Opto_info.frequency) linspace(1, 0, 0.1*Opto_info.frequency)]]';
            else
                d = Opto_info.pulse_width/2 : 1/Opto_info.frequency : Opto_info.duration;
              
            end
    end
end

