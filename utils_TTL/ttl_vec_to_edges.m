function [edge_times_s, edge_states] = ttl_vec_to_edges(ttl_vec, fs)
% Convert a logical TTL vector into edge times and target states.
%
% Inputs:
%   ttl_vec : Nx1 logical or numeric vector
%   fs      : sampling rate in Hz
%
% Outputs:
%   edge_times_s : Kx1 edge times in seconds, relative to trial start
%   edge_states  : Kx1 logical states after each edge

    ttl_vec = logical(ttl_vec(:));

    if isempty(ttl_vec) || ~any(ttl_vec)
        edge_times_s = zeros(0,1);
        edge_states  = false(0,1);
        return
    end

    edge_idx = find([ttl_vec(1); diff(ttl_vec) ~= 0]);
    edge_times_s = (edge_idx - 1) / fs;
    edge_states  = ttl_vec(edge_idx);
end