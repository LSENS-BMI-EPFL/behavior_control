function reward_delivery(is_stim, is_auditory, is_whisker, aud_reward, wh_reward)
% REWARD_DELIVERY Gives unitary reward if conditions are met.

    global Trigger_S reward_time reward_delivered_flag ...

    % Reward only stimulus trials
    if  is_stim

        %% Check if stimulus trials are rewarded
        if (is_auditory && aud_reward) || (is_whisker && wh_reward) 

        %Trigger reward signal (pulse defined in update_parameters.m)
        
        outputSingleScan(Trigger_S, [0 1 0]);

        reward_time=tic;
        reward_delivered_flag=1;
            
        end
    end
end