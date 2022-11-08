function reward_delivery
% REWARD_DELIVERY Gives unitary reward if conditions are met.

    global  Stim_NoStim Trigger_S RewardTime Aud_NoAud Wh_NoWh Aud_Rew Wh_Rew ...
        RewardDelivered ...

    % Reward only stimulus trials
    if  Stim_NoStim
        % Check if stim trials are rewarded
        if (Aud_NoAud && Aud_Rew) || (Wh_NoWh && Wh_Rew) 

            %Trigger reward signal
            %outputSingleScan(Trigger_S, [0 1 0]);
            write(Trigger_S, [0 1 0]);

            RewardTime=tic;
            RewardDelivered=1;
        end
    end
end