function save_opto_config
%SAVE_OPTO_CONFIG Summary of this function goes here
%   Detailed explanation goes here
% Encode as json text 
    global folder_name opto_gui Opto_info
    
    opto_config_json = jsonencode(Opto_info, PrettyPrint=true);
    
% Save config file
    fid = fopen([folder_name '\opto_config.json'],'w');
    fprintf(fid, '%s', opto_config_json);
    fclose(fid);
    
% Save grid and vector info
    saveas(opto_gui.UIAxes, [folder_name '\Grid'], 'fig');
    exportgraphics(opto_gui.UIAxes, [folder_name '\Grid.png']);
    saveas(opto_gui.UIAxes2, [folder_name '\Opto_stim_vec'], 'fig');
    exportgraphics(opto_gui.UIAxes2, [folder_name '\Opto_stim_vec.png']);

end

