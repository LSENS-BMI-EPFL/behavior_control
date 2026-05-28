function [ttl, t_ms, nP] = TTL_stim_compute_do(p, fs, nCh)
% Returns a logical TTL waveform (N x nCh) for hardware-timed digital output.
% The waveform is derived directly from TTL_stim_compute_preview so that
% previewed pulse shape and fired pulse shape remain consistent.

    arguments
        p
        fs (1,1) double
        nCh (1,1) double = 1
    end

    [t_ms, y, nP] = TTL_stim_compute_preview(p, fs);

    ttl1 = (y > 0);   % logical N×1

    switch nCh
        case 1
            ttl = ttl1(:);
        case 2
            % Default: same waveform on both channels
            ttl = [ttl1(:), ttl1(:)];
        otherwise
            error("nCh must be 1 or 2");
    end
end
