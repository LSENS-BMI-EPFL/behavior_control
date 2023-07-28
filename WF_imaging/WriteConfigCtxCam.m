%% Written by Vahid Esmaeili and Matthieu Auffret on 25/12/2016. Updated Pol Bech 17.04.2023
function  [FilmingTrialID] = WriteConfigCtxCam(WF_FileInfo)
% VERSIONS ----------------------------------------------------------------
%   Date      Nr      By  Changes
%   --------  ---     --  -------------
%   20180323  1.0     KT  

%
%% DO NOT EDIT/CHANGE THIS SCRIPT -> MAKE A LOCAL COPY
%% Reading the camera template config file
fid = fopen(WF_FileInfo.CameraPathTemplateConfig);
ConfigStrTemplate = fread(fid,'*char')';
fclose(fid);

%% Updating the config file with new block name
ConfigStrgNew = ConfigStrTemplate;

%%% Sets Camera Mode
expression = 'HCMode = dummy;';
replace = ['HCMode = ' WF_FileInfo.CameraMode ';'];
ConfigStrgNew = strrep(ConfigStrgNew,expression,replace);

%%% Sets Trigger Mode
expression = 'triggerMode = dummy;';
replace = ['triggerMode = ' WF_FileInfo.CameraTriggerMode ';'];
ConfigStrgNew = strrep(ConfigStrgNew,expression,replace);

%%% Sets pixel xpos
expression = 'xpos = dummy;';
replace = ['xpos = ' num2str(WF_FileInfo.CameraXpos) ';'];
ConfigStrgNew = strrep(ConfigStrgNew,expression,replace);

%%% Sets pixel ypos
expression = 'ypos = dummy;';
replace = ['ypos = ' num2str(WF_FileInfo.CameraYpos) ';'];
ConfigStrgNew = strrep(ConfigStrgNew,expression,replace);

%%% Sets pixel width
expression = 'width = dummy;';
replace = ['width = ' num2str(WF_FileInfo.CameraWidth) ';'];
ConfigStrgNew = strrep(ConfigStrgNew,expression,replace);

%%% Sets pixel height
expression = 'height = dummy;';
replace = ['height = ' num2str(WF_FileInfo.CameraHeight) ';'];
ConfigStrgNew = strrep(ConfigStrgNew,expression,replace);

%%% Change number of frames to grab
expression = 'nrOfPicturesToGrab = dummy;';
replace = ['nrOfPicturesToGrab = ' num2str(WF_FileInfo.n_frames_to_grab) ';'];
ConfigStrgNew = strrep(ConfigStrgNew,expression,replace);

%%% Change frame rate
expression = 'frameRate = dummy;';
replace = ['frameRate = ' num2str(WF_FileInfo.CameraFrameRate) ';'];
ConfigStrgNew = strrep(ConfigStrgNew,expression,replace);

%%% Change exposure
expression = 'exposure = dummy;';
replace = ['exposure = ' num2str(WF_FileInfo.CameraExposure) ';'];
ConfigStrgNew = strrep(ConfigStrgNew,expression,replace);

%%% Change folder to save movie
expression = 'folderName = dummy;';
replace = ['folderName = ' WF_FileInfo.savedir ';'];
ConfigStrgNew = strrep(ConfigStrgNew,expression,replace); % Use strrep() because the \ characters are not suported by regexprep()

%%% Change trial number
expression = 'filePrefix = dummy;';
FilmingTrialID = WF_FileInfo.file_name;
replace = ['filePrefix = ' WF_FileInfo.file_name ';'];
ConfigStrgNew = strrep(ConfigStrgNew,expression,replace);

%%% Write in the file in WFI PC
fid = fopen(WF_FileInfo.CameraPathConfig,'w');
fwrite(fid,ConfigStrgNew);
fclose(fid);

end