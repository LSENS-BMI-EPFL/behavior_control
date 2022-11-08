function manual_reward_delivery

global Trigger_S

%outputSingleScan(Trigger_S,[0 1 0 ]);
%outputSingleScan(Trigger_S,[0 0 0 ]);

write(Trigger_S, [0 1 0]);
write(Trigger_S, [0 0 0]);

end