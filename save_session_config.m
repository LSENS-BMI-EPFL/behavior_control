function save_session_config(gui_handles)
%SAVE_CONFIG At session start, saves default initial configuration and parameters
%            used to start Detection GUI. 
%   HANDLES2GIVE Copy of handles, generated from default parameters
%   during GUI instantiation.

folder_name=[char(gui_handles.BehaviorDirectory) '\' char(gui_handles.MouseName) ...
        '\' [char(gui_handles.MouseName) '_' char(gui_handles.Date) '_' char(gui_handles.FolderName)]];
    
handles2save = gui_handles;

field = fieldnames(gui_handles);
for k=1:numel(field)
    
    field_name = field{k};
    field_value = gui_handles.(field{k});
   
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

