function wh_stim_weight = get_whisker_weight(handles2give)
%GET_WHISKER_WEIGHT Get sum of total whisker stimulus weights.

if handles2give.wh_stim_amp_range
    wh_stim_weight = handles2give.wh_stim_weight_1+...
    handles2give.wh_stim_weight_2+...
    handles2give.wh_stim_weight_3+...
    handles2give.wh_stim_weight_4;

else
    wh_stim_weight = handles2give.wh_stim_weight_1;
end

end

