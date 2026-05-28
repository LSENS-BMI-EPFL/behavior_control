function starts_s = TTL_stim_compute_starts(p)
% Returns pulse start times for a TTL train.
% The first pulse starts at p.delay_s.
% Additional pulses repeat every p.period_s while remaining within p.dur_s.
% If p.period_s <= 0, a single pulse is generated at p.delay_s.

delay_s  = max(p.delay_s, 0);
dur_s    = max(p.dur_s, 0);
period_s = p.period_s;
pw_s     = max(p.pw_s, 0);

if dur_s <= 0 || pw_s <= 0
    starts_s = [];
    return
end

if period_s <= 0
    starts_s = delay_s;   % single pulse
    return
end

n = floor((dur_s - 1e-12) / period_s) + 1;
starts_s = delay_s + (0:n-1) * period_s;
end
