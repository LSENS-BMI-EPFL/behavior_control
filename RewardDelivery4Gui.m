function RewardDelivery4Gui
% REWARDDELIVERY4GUI Delivery of reward/punishment in stimulus and catch trials.
%
%

global  Stim_NoStim Trigger_S RewardTime RewardSound_vec Fs_Reward LastTrialFA Aud_NoAud Wh_NoWh Aud_Rew Wh_Rew ...
    RewardSound FalseAlarmPunishment Punishment RewardDelivered Reward_NoReward...
      

if  Stim_NoStim
    
    if (Aud_NoAud && Aud_Rew) || (Wh_NoWh && Wh_Rew) % Only if stim trial and rewarded, trigger reward
    
    outputSingleScan(Trigger_S,[0 1 0]);
    %if RewardSound && Reward_NoReward % Reward sound cue?
    %    sound(RewardSound_vec, Fs_Reward)
    %end

    RewardTime=tic;
    RewardDelivered=1;
    end
else % Should there be a lick flag here?
    if FalseAlarmPunishment %If no stimulus and FA punishement ON (negative reward)
        % sound(Punishment)
        LastTrialFA=1;
    end
end
end