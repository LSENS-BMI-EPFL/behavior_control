function stim_proba = compute_stim_proba(handles2give)
%COMPUTE_STIM_PROBA Compute probability of stimulus (any).
%   Computes probability of stimulus of any kind between whisker and
%   auditory, relative to no stimulus trials.

no_stim_weight = handles2give.no_stim_weight;
aud_stim_weight = handles2give.aud_stim_weight;

if handles2give.wh_stim_amp_range
    weight_1 = handles2give.wh_stim_weight_1;
    weight_2 = handles2give.wh_stim_weight_2;
    weight_3 = handles2give.wh_stim_weight_3;
    weight_4 = handles2give.wh_stim_weight_4;

    wh_stim_weight = weight_1+weight_2+weight_3+weight_4;
else
    wh_stim_weight = handles2give.wh_stim_weight_1;
end

stim_proba = (aud_stim_weight + wh_stim_weight)/(aud_stim_weight + wh_stim_weight + no_stim_weight);

end

