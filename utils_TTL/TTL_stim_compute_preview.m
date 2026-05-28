function [t_ms, y, nP] = TTL_stim_compute_preview(p, fs)

    starts_s = TTL_stim_compute_starts(p);

    t_end_s = max(p.delay_s + p.dur_s, 0);
    if t_end_s <= 0
        t_end_s = max(p.delay_s + p.pw_s, 0.01);
    end

    N = max(1, round(t_end_s * fs) + 1);
    t = (0:N-1)' / fs;
    y = zeros(N,1);

    for k = 1:numel(starts_s)
        t0 = starts_s(k);
        t1 = min(t0 + p.pw_s, t_end_s);
        y(t >= t0 & t < t1) = p.amp;
    end

    t_ms = t * 1000;
    nP = numel(starts_s);
end