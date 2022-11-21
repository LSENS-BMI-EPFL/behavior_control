function save_config(handles_config)
%SAVE_CONFIG At session start, saves default configuration and parameters
%            used to start Detection GUI. 
%   HANDLES_CONFIG Copy of handles, generated from default parameters
%   during GUI instantiation.

disp(handles_config);
jsonencode(handles_config, PrettyPrint=true);

end

