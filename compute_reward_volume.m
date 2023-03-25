function [aud_tot_volume, wh_tot_volume, asso_tot_volume] = compute_reward_volume(results, volume_per_reward)
%COMPUTE_REWARD_VOLUME Compute collected reward volumne per trial types,
% regardless of the flag wh_reward of context block (theoretical reward volume if all rewarded).
%   RESULTS:  results structure to compute metrics from.
%   VOLUME_PER_REWARD: volume per reward, in microliter.

% Separate associative form non-associative trials
asso_trials = results.data(:,4)==1;
asso_stim_trials = results.data(asso_trials, 11);
non_asso_trials = results.data(:,4)~=1;

% Get rewards obtained per trial type
reward_trials_non_asso = results.data(non_asso_trials,14)==1; %=1 only if reward_proba=1
perf = results.data(non_asso_trials, 2);
aud_hits = perf==3;
wh_hits = perf==2;
aud_trials_rewarded = results.data(aud_hits & reward_trials_non_asso, 13); %element-wise vector comparison
wh_trials_rewarded = results.data(wh_hits & reward_trials_non_asso, 12);

% Get volumes: auditory, whisker, associative trials
aud_tot_volume = volume_per_reward * sum(aud_trials_rewarded);
wh_tot_volume = volume_per_reward * sum(wh_trials_rewarded);
asso_tot_volume = volume_per_reward * sum(asso_stim_trials);

end
