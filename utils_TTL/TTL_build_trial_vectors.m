function [ttl1_vec, ttl2_vec] = TTL_build_trial_vectors(~)
% Build trial-referenced TTL waveforms from GUI-defined pulse parameters.
%
% Raw pulse shapes are generated via TTL_stim_compute_do and should match
% the GUI preview.
%
% In the current architecture:
%   - ttl1_vec is played by main_control at trial start, but its internal
%     timing is referenced to trial start and anchored to baseline_window
%   - ttl2_vec is played by main_control at trial end logic, but its internal
%     timing is referenced to trial start and anchored to response_window_end
%
% Anchor rules:
%   TTL1 first pulse starts at: baseline_window + ch1.delay
%   TTL2 first pulse starts at: response_window_end + ch2.delay
%
% Notes:
%   - baseline_window is in ms
%   - response_window_end is in s in the current behavioral code
%   - negative effective delays are clipped to 0 by the downstream pulse builder
%
% Input:
%   trial_duration_ms : unused, kept only for compatibility
%
% Outputs:
%   ttl1_vec : Nx1 logical vector for TTL channel 1
%   ttl2_vec : Mx1 logical vector for TTL channel 2

    global TTL_info baseline_window response_window_end artifact_window response_window

    if ~isempty(TTL_info) && isfield(TTL_info,'fs') && ~isempty(TTL_info.fs)
        fs = TTL_info.fs;
    else
        fs = 10000;
    end

    ttl1_vec = false(0,1);
    ttl2_vec = false(0,1);

    if isempty(TTL_info) || ~isfield(TTL_info,'valid') || ~TTL_info.valid
        return
    end

    % TTL1 anchor: end of baseline window
    ttl1_anchor_s = baseline_window / 1000;

    % TTL2 anchor: response_window_end if available, otherwise reconstruct it
    if ~isempty(response_window_end)
        ttl2_anchor_s = response_window_end;
    else
        ttl2_anchor_s = (baseline_window + artifact_window + response_window) / 1000;
    end

    % ---- CH1 waveform anchored to baseline_window ----
    if isfield(TTL_info,'ch1') && isfield(TTL_info.ch1,'p') && ~isempty(TTL_info.ch1.p)
        p1 = TTL_info.ch1.p;

        % Convert GUI delay into absolute delay from trial start
        p1.delay_s = ttl1_anchor_s + p1.delay_s;

        [ttl1_raw, ~, ~] = TTL_stim_compute_do(p1, fs, 1);
        ttl1_vec = logical(ttl1_raw(:));
    end

    % ---- CH2 waveform anchored to response_window_end ----
    if isfield(TTL_info,'ch2') && isfield(TTL_info.ch2,'p') && ~isempty(TTL_info.ch2.p)
        p2 = TTL_info.ch2.p;

        % Convert GUI delay into absolute delay from trial start
        p2.delay_s = ttl2_anchor_s + p2.delay_s;

        [ttl2_raw, ~, ~] = TTL_stim_compute_do(p2, fs, 1);
        ttl2_vec = logical(ttl2_raw(:));
    end
end