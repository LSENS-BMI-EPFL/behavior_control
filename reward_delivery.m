function reward_delivery
% REWARD_DELIVERY Gives unitary reward if conditions are met.

    global  is_stim Trigger_S reward_time is_auditory is_whisker aud_reward wh_reward ...
        reward_delivered_flag ...

    % Reward only stimulus trials
    if  Stim_NoStim

        % Check if stimulus trials are rewarded
        if (is_auditory && aud_reward) || (is_whisker && wh_reward) 

            %Trigger reward signal
            outputSingleScan(Trigger_S, [0 1 0]);
            %write(Trigger_S, [0 1 0]);

            reward_time=tic;
            reward_delivered_flag=1;
        end
    end
end