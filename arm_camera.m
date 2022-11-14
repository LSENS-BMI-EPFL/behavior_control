function arm_camera(~, event)
% ARM_CAMERA Re-arm camera for frame acquisition.
%   EVENT


% First kill existing execution
dos('Taskkill /im "fastCamRecord.exe"  /f') 
dos('Taskkill /im cmd.exe /f')

% Reading the camera template config file
load('D:\camera\TemplateConfigFile\VideoFileInfo.mat'); 

% Create directory for frames if inexistant
if ~exist(VideoFileInfo.directory, 'dir') 
    disp(VideoFileInfo.directory)
    mkdir(VideoFileInfo.directory);
end

%Execute fastCamRecord specifying parameters
dos(['"C:\Program Files\LSENS_EPFL\fastCamRecord.exe" ' ... 
     num2str(VideoFileInfo.nOfFramesToGrab) ... # Number of frames to grab in total
     ' 512 512 60 1 ' ...                       # Frame dimension settings + timeout + number of sweeps
     char(VideoFileInfo.directory) ...
     'trial_' num2str(VideoFileInfo.trial_number) ... # Path to frame block aligned at onset of trial "trial_number"
     ' &']);

disp('Camera armed.');
end
