function ArmCameraNew(~,event)
% ARMCAMERANEW Re-arm camera for frame acquisition.
%   EVENT


% global Arm_Threshold

dos('Taskkill /im "fastCamRecord.exe"  /f') % First kill existing execution
dos('Taskkill /im cmd.exe /f')

load('D:\camera\TemplateConfigFile\VideoFileInfo.mat'); % Reading the camera template config file
if ~exist(VideoFileInfo.directory, 'dir') % Create directory for frames if inexistant
    disp(VideoFileInfo.directory)
    mkdir(VideoFileInfo.directory);
    %mkdir([VideoFileInfo.directory 'trial_' num2str(VideoFileInfo.trialnumber)]);
end

dos(['"C:\Program Files\LSENS_EPFL\fastCamRecord.exe" ' ... %Excute fastCamRecord specifying parameters
     num2str(VideoFileInfo.nOfFramesToGrab) ... # Number of frames to grab in total
     ' 512 512 60 1 ' ...                       # Frame dimension settings
     char(VideoFileInfo.directory) ...
     'trial_' num2str(VideoFileInfo.trialnumber) ... # Path to frame block aligned at onset of trial "trialnumber"
     ' &']);

display('Camera armed.')
end
