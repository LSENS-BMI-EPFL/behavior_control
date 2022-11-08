function reward_delivery

    global  Stim_NoStim Trigger_S RewardTime Aud_NoAud Wh_NoWh Aud_Rew Wh_Rew ...
        RewardDelivered ...

    if  Stim_NoStim
        if (Aud_NoAud && Aud_Rew) || (Wh_NoWh && Wh_Rew) % Only if stim trial and rewarded, trigger reward
            outputSingleScan(Trigger_S, [0 1 0]);
            RewardTime=tic;
            RewardDelivered=1;
        end
    end
    
end