function [aud_hit_rate,wh_hit_rate,fa_rate,stim_trial_number,aud_stim_number,wh_stim_number] = compute_performance(results)
%COMPUTE_PERFORMANCE Compute session-wide performance.
% RESULTS: results structure to compute metrics from.

non_asso_trials = results.association_flag~=1;

% Get perf column and trial types
perf = results.perf(non_asso_trials);
aud_trials = results.is_auditory(non_asso_trials);
wh_trials = results.is_whisker(non_asso_trials);
stim_trials = results.is_stim(non_asso_trials);

% Compute performance and completed trial counts 
stim_trial_number = sum(stim_trials==1);

aud_stim_number = sum(aud_trials==1); 
aud_hit_rate = round(sum(perf==3)/aud_stim_number*100)/100;

wh_stim_number = sum(wh_trials==1);
wh_hit_rate = round(sum(perf==2)/wh_stim_number*100)/100;

fa_rate = round(sum(perf==5)/sum(stim_trials==0)*100)/100;

end

