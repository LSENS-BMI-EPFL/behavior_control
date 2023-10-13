function wh_stim_amp = get_whisker_stim_amp(handles2give)
%GET_WHISKER_STIM_AMP Get whisker amplitude, in Volt, to use for current
%trial, for unique stimulus amplitude and in the case with a range of
%amplitudes.

disp(handles2give.wh_stim_weight_1);
if handles2give.wh_stim_amp_range

    % Get whisker amplitudes and weights
    wh_stim_amp_list = [handles2give.wh_stim_amp_1; handles2give.wh_stim_amp_2; handles2give.wh_stim_amp_3; handles2give.wh_stim_amp_4];
    wh_stim_weight_total = get_whisker_weight(handles2give);
    wh_stim_proba_weights = [
        handles2give.wh_stim_weight_1/wh_stim_weight_total; ...
        handles2give.wh_stim_weight_2/wh_stim_weight_total; ...
        handles2give.wh_stim_weight_3/wh_stim_weight_total; ...
        handles2give.wh_stim_weight_4/wh_stim_weight_total];

    % Select randomly whisker stimulus amplitude
    wh_stim_amp = randsample(wh_stim_amp_list, 1, true, wh_stim_proba_weights);

else
    wh_stim_amp = handles2give.wh_stim_amp_1;
end

