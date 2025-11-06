function [is_wf_setup] = is_wf_computer(computer_name)
%GET_WF_COMPUTERS Summary of this function goes here
%   Detailed explanation goes here
    wf_computers = ["SV-07-051", "SV-07-068"];
    is_wf_setup = any(find(strcmp(computer_name, wf_computers)));
end

