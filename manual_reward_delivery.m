function manual_reward_delivery
% MANUAL_REWARD_DELIVERY Give unitary reward manually from GUI button.

global Trigger_S

outputSingleScan(Trigger_S,[0 1 0 ]);
outputSingleScan(Trigger_S,[0 0 0 ]);

%write(Trigger_S, [0 1 0]);
%write(Trigger_S, [0 0 0]);

end