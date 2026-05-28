% function wh_stim_amp = get_whisker_stim_amp(handles2give)
% %GET_WHISKER_STIM_AMP Get whisker amplitude, in Volt, to use for current
% %trial, for unique stimulus amplitude and in the case with a range of
% %amplitudes.
% 
% if handles2give.wh_stim_amp_range
% 
%     % Get whisker amplitudes and weights
%     wh_stim_amp_list = [handles2give.wh_stim_amp_1; handles2give.wh_stim_amp_2; handles2give.wh_stim_amp_3; handles2give.wh_stim_amp_4];
%     wh_stim_weight_total = get_whisker_weight(handles2give);
%     wh_stim_proba_weights = [
%         handles2give.wh_stim_weight_1/wh_stim_weight_total; ...
%         handles2give.wh_stim_weight_2/wh_stim_weight_total; ...
%         handles2give.wh_stim_weight_3/wh_stim_weight_total; ...
%         handles2give.wh_stim_weight_4/wh_stim_weight_total];
% 
%     % Select randomly whisker stimulus amplitude
%     wh_stim_amp = randsample(wh_stim_amp_list, 1, true, wh_stim_proba_weights);
% 
% else
%     wh_stim_amp = handles2give.wh_stim_amp_1;
% end

function [wh_stim_amp, wh_stim_amp_mT] = get_whisker_stim_amp(handles2give)
%GET_WHISKER_STIM_AMP Get whisker amplitude for current whisker trial.
% If multiple amplitudes are enabled, this uses a shuffled amplitude pool,
% so each amplitude appears exactly according to its weight before the pool
% is reshuffled.

global wh_stim_amp_pool wh_stim_amp_pool_idx wh_stim_amp_pool_key

if handles2give.wh_stim_amp_range

    wh_stim_amp_list = [
        handles2give.wh_stim_amp_1;
        handles2give.wh_stim_amp_2;
        handles2give.wh_stim_amp_3;
        handles2give.wh_stim_amp_4];

    wh_stim_amp_mT_list = [
        handles2give.wh_stim_amp_mT_1;
        handles2give.wh_stim_amp_mT_2;
        handles2give.wh_stim_amp_mT_3;
        handles2give.wh_stim_amp_mT_4];

    wh_stim_weight_list = [
        handles2give.wh_stim_weight_1;
        handles2give.wh_stim_weight_2;
        handles2give.wh_stim_weight_3;
        handles2give.wh_stim_weight_4];

    % Keep only amplitudes with positive weight
    valid_idx = wh_stim_weight_list > 0;

    wh_stim_amp_list = wh_stim_amp_list(valid_idx);
    wh_stim_amp_mT_list = wh_stim_amp_mT_list(valid_idx);
    wh_stim_weight_list = round(wh_stim_weight_list(valid_idx));

    % Safety fallback
    if isempty(wh_stim_amp_list) || sum(wh_stim_weight_list) == 0
        wh_stim_amp = handles2give.wh_stim_amp_1;
        wh_stim_amp_mT = handles2give.wh_stim_amp_mT_1;
        return
    end

    % Key detects GUI changes in amplitudes, mT values, and weights
    current_key = sprintf('%g_', [ ...
        wh_stim_amp_list(:); ...
        wh_stim_amp_mT_list(:); ...
        wh_stim_weight_list(:)]);

    % Rebuild pool if empty, exhausted, or GUI settings changed
    if isempty(wh_stim_amp_pool) || isempty(wh_stim_amp_pool_idx) || ...
            wh_stim_amp_pool_idx > numel(wh_stim_amp_pool) || ...
            isempty(wh_stim_amp_pool_key) || ~strcmp(current_key, wh_stim_amp_pool_key)

        wh_stim_amp_pool = [];

        % Store indices, not amplitudes
        for i = 1:numel(wh_stim_amp_list)
            wh_stim_amp_pool = [wh_stim_amp_pool; repmat(i, wh_stim_weight_list(i), 1)];
        end

        wh_stim_amp_pool = wh_stim_amp_pool(randperm(numel(wh_stim_amp_pool)));
        wh_stim_amp_pool_idx = 1;
        wh_stim_amp_pool_key = current_key;
    end

    selected_idx = wh_stim_amp_pool(wh_stim_amp_pool_idx);

    wh_stim_amp = wh_stim_amp_list(selected_idx);
    wh_stim_amp_mT = wh_stim_amp_mT_list(selected_idx);

    wh_stim_amp_pool_idx = wh_stim_amp_pool_idx + 1;

else
    wh_stim_amp = handles2give.wh_stim_amp_1;
    wh_stim_amp_mT = handles2give.wh_stim_amp_mT_1;
end

end