function save_session_config(handles2give)
%SAVE_CONFIG At session start, saves default initial configuration and parameters
%            used to start Detection GUI. 
%   HANDLES2GIVE Copy of handles, generated from default parameters
%   during GUI instantiation.

folder_name=[char(handles2give.BehaviorDirectory) '\' char(handles2give.MouseName) ...
        '\' [char(handles2give.MouseName) '_' char(handles2give.Date) '_' char(handles2give.FolderName)]];
    
handles2save = handles2give;

field = fieldnames(handles2give);
for k=1:numel(field)
    
    field_name = field{k};
    field_value = handles2give.(field{k});
   
    % Keep numeric or string variables (i.e. remove GUI objects)
    if not(isa(field_value,'numeric')) & not(isa(field_value,'string'))  & not(isa(field_value,'char'))
        disp('yes');
        handles2save = rmfield(handles2save, field_name);
        
    end
    
end

% Encode as json text 
session_config_json = jsonencode(handles2save, PrettyPrint=true);

% Save config file
fid = fopen([folder_name '\session_config.json'],'w');
fprintf(fid, '%s', session_config_json);
fclose(fid);

end

