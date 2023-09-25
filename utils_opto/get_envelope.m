function d = get_envelope
%GET_ENVELOPE Return the duty cycle array containing the repetition period
%and the envelope (i.e. Gaussian, or modified ramp up and down)
%   If selecting an envelope in Opto_GUI, return the optogenetic vector
%   envolved in a function that allows for smoother or modified stimulus
%   delivery, such as raised cosines or slow ramp down of power to prevent
%   rebound excitation.

    global Opto_info
    switch Opto_info.envelope
        case 'None'
            d = Opto_info.pulse_width/2 : 1/Opto_info.frequency : Opto_info.duration;
    
        case 'Gaussian'
            d = [Opto_info.pulse_width/2 : 1/Opto_info.frequency : Opto_info.duration;...
                2*sin(2*pi*1*(Opto_info.pulse_width/2:1/Opto_info.frequency:Opto_info.duration))]';
            d(d(:,2)>1,2) = 1; % clip values at the maximum so the ramps are just at the beginning and end of pulse train.
    
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

