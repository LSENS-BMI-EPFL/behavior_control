function varargout = DetectionGUI(varargin)
% DetectionGUI MATLAB code for DetectionGUI.fig
%      DetectionGUI, by itself, creates a new DetectionGUI or raises the existing
%      singleton*.
%
%      H = DetectionGUI returns the handle to a new DetectionGUI or the handle to
%      the existing singleton*.
%
%      DetectionGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DetectionGUI.M with the given input arguments.
%
%      DetectionGUI('Property','Value',...) creates a new DetectionGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DetectionGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DetectionGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DetectionGUI

% Last Modified by GUIDE v2.5 31-Oct-2023 12:12:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DetectionGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @DetectionGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before DetectionGUI is made visible.
function DetectionGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DetectionGUI (see VARARGIN)
global handles2give

% Choose default command line output for DetectionGUI
handles.output = hObject;

% % Add subfolders to MATLAB path
% addpath('utils\');
% addpath('utils_context\');
% addpath('utils_plots\');
% addpath('utils_savings\');
% addpath('utils_opto\');


%% Set default session type
set(handles.TwoPhotonCheckbox,'Value',0); handles.twophoton_session = get(handles.TwoPhotonCheckbox,'Value');
set(handles.ThreePhotonCheckbox,'Value',0); handles.threephoton_session = get(handles.ThreePhotonCheckbox,'Value');
set(handles.WFCheckbox,'Value',0); handles.wf_session = get(handles.WFCheckbox,'Value');
set(handles.EphysCheckbox,'Value',0); handles.ephys_session = get(handles.EphysCheckbox,'Value');
set(handles.OptoCheckbox,'Value',0); handles.opto_session = get(handles.OptoCheckbox,'Value');
set(handles.ChemoCheckbox,'Value',0); handles.chemo_session = get(handles.ChemoCheckbox,'Value');
set(handles.PharmaCheckbox,'Value',0); handles.pharma_session = get(handles.PharmaCheckbox,'Value');


%% Set general session information
formatOut = 'yyyymmdd';
handles.date = datestr(now,formatOut);
formatOut = 'yyyy/mm/dd';
Date2Display = datestr(now,formatOut);
set(handles.SetDateTag,'String',Date2Display);
set(handles.SetDateTag,'Enable','off');

% [TO CUSTOMIZE BY EACH USER]
set(handles.MouseNameTag,'String','PBXXX'); handles.mouse_name = get(handles.MouseNameTag,'String');
handles.behaviour_directory = 'D:\behavior';
set(handles.BehaviorDirectoryTag,'String', handles.behaviour_directory);

%% Set general session settings
set(handles.FalseAlarmPunishmentCheckbox,'Value',0); handles.false_alarm_punish_flag = get(handles.FalseAlarmPunishmentCheckbox,'Value');
set(handles.FalseAlarmPunishmentCheckbox,'Enable','on');
set(handles.EarlyLickPunishmentCheckbox,'Value',0); handles.early_lick_punish_flag = get(handles.EarlyLickPunishmentCheckbox,'Value');
set(handles.EarlyLickPunishmentCheckbox,'Enable','on');
set(handles.AssociationCheckbox,'Value',0); handles.association_flag = get(handles.AssociationCheckbox,'Value');
set(handles.AssociationCheckbox,'Enable','on');
set(handles.CameraTagCheck,'Value', 1); handles.camera_flag = get(handles.CameraTagCheck,'Value');   
set(handles.CameraTagCheck,'Enable','on');
set(handles.DummySessionCheckbox,'Value',0); handles.dummy_session_flag = get(handles.DummySessionCheckbox,'Value');
set(handles.DummySessionCheckbox,'Enable','on');
set(handles.ContextCheckBox,'Value',0); handles.context_flag = get(handles.ContextCheckBox,'Value');
set(handles.ContextCheckBox,'Enable','on');

behaviour_type = get(handles.BehaviourTypeMenu, 'String');
handles.behaviour_type = behaviour_type{get(handles.BehaviourTypeMenu, 'Value')}; %default, as most often the most common behaviour session type

%% Set the timeline parameters
set(handles.MinQuietWindowTag,'String','2000'); handles.min_quiet_window = str2double(get(handles.MinQuietWindowTag,'String'));
set(handles.MaxQuietWindowTag,'String','5000'); handles.max_quiet_window = str2double(get(handles.MaxQuietWindowTag,'String'));
set(handles.ResponseWindowTag,'String','1000'); handles.response_window = str2double(get(handles.ResponseWindowTag,'String'));
set(handles.ArtifactWindowTag,'String','100'); handles.artifact_window = str2double(get(handles.ArtifactWindowTag,'String'));
set(handles.MinISITag,'String','6000'); handles.min_iti = str2double(get(handles.MinISITag,'String'));
set(handles.MaxISITag,'String','10000'); handles.max_iti = str2double(get(handles.MaxISITag,'String'));
set(handles.BaselineWindowTag,'String','0'); handles.baseline_window = str2double(get(handles.BaselineWindowTag,'String'));
set(handles.TrialDurationTag,'String','5000'); handles.trial_duration = str2double(get(handles.TrialDurationTag,'String'));


%% Set Light parameters
set(handles.LightCheckbox,'Value',0); handles.light_flag = get(handles.LightCheckbox,'Value');
set(handles.LightCheckbox,'Enable','on');

set(handles.LightDurationTag,'Enable','off');
set(handles.LightPrestimDelayTag,'Enable','off');
set(handles.LightAmpTag,'Enable','off');
set(handles.LightFreqTag,'Enable','off');
set(handles.LightDutyTag,'Enable','off');
set(handles.LightStimWeightTag,'Enable','off');

set(handles.LightDurationTag,'String','200'); handles.light_duration = str2double(get(handles.LightDurationTag,'String'));
set(handles.LightPrestimDelayTag,'String','100'); handles.light_prestim_delay = str2double(get(handles.LightPrestimDelayTag,'String'));
set(handles.LightAmpTag,'String','5'); handles.light_amp = str2double(get(handles.LightAmpTag,'String'));
set(handles.LightFreqTag,'String','100'); handles.light_freq = str2double(get(handles.LightFreqTag,'String'));
set(handles.LightDutyTag,'String','0.65'); handles.light_duty = str2double(get(handles.LightDutyTag,'String'));
set(handles.LightStimWeightTag,'String','0'); handles.light_aud_proba = str2double(get(handles.LightStimWeightTag,'String'));

%% Set Punishment parameters

set(handles.FalseAlarmTimeOutTag,'String','0000'); handles.false_alarm_timeout = str2double(get(handles.FalseAlarmTimeOutTag,'String'));
set(handles.FalseAlarmTimeOutTag,'Enable','off');

set(handles.EarlyLickTimeOutTag,'String','0000'); handles.early_lick_timeout = str2double(get(handles.EarlyLickTimeOutTag,'String'));
set(handles.EarlyLickTimeOutTag,'Enable','off');

%% Auditory stimulus parameters
set(handles.ToneDurationTag,'String','10'); handles.aud_stim_duration = str2double(get(handles.ToneDurationTag,'String'));
set(handles.ToneDurationTag,'Enable','on');
set(handles.ToneAmpTag,'String','5'); handles.aud_stim_amp = str2double(get(handles.ToneAmpTag,'String'));
set(handles.ToneAmpTag,'Enable','on');
set(handles.ToneFreqTag,'String','10000'); handles.aud_stim_freq= str2double(get(handles.ToneFreqTag,'String'));
set(handles.ToneFreqTag,'Enable','on');

set(handles.AStimWeightTag,'Enable','on')
set(handles.AStimWeightTag,'String','4'); handles.aud_stim_weight = str2double(get(handles.AStimWeightTag,'String'));

set(handles.BckgNoiseFolderPath,'String','M:\analysis\Pol_Bech\behaviour_context_files'); handles.bckg_noise_directory = get(handles.BckgNoiseFolderPath,'String');
set(handles.BckgNoiseFolderPath,'Enable','off');
set(handles.ContextSoundCheckBox,'Value',1); handles.context_sound_on = get(handles.ContextSoundCheckBox,'Value');
set(handles.ContextSoundCheckBox,'Enable','off');

%%  Whisker stimulus parameters
%   Default whisker stimulus parameters (if one stimulus type)
set(handles.StimDuration1Tag,'String','3'); handles.wh_stim_duration = str2double(get(handles.StimDuration1Tag,'String'));
set(handles.StimDuration1Tag,'Enable','on');
set(handles.scaling_factor,'String','0.9'); handles.wh_scaling_factor = str2double(get(handles.scaling_factor,'String'));
set(handles.scaling_factor,'Enable','on');
set(handles.StimAmp1Tag,'String','2.8'); handles.wh_stim_amp_1 = str2double(get(handles.StimAmp1Tag,'String'));
set(handles.StimWeight1Tag,'String','8'); handles.wh_stim_weight_1 = str2double(get(handles.StimWeight1Tag,'String'));
set(handles.StimAmp1Tag,'Enable','on');

%  For additional whisker stimulis of different amplitudes
set(handles.StimAmpRangeCheckbox,'Value',0); handles.wh_stim_amp_range = get(handles.StimAmpRangeCheckbox,'Value');

set(handles.StimAmp2Tag,'String','0'); handles.wh_stim_amp_2 = str2double(get(handles.StimAmp2Tag,'String'));
set(handles.StimWeight2Tag,'String','0'); handles.wh_stim_weight_2 = str2double(get(handles.StimWeight2Tag,'String'));
set(handles.StimAmp2Tag,'Enable','off');
set(handles.StimWeight2Tag,'Enable','off');

set(handles.StimAmp3Tag,'String','0'); handles.wh_stim_amp_3 = str2double(get(handles.StimAmp3Tag,'String'));
set(handles.StimWeight3Tag,'String','0'); handles.wh_stim_weight_3 = str2double(get(handles.StimWeight3Tag,'String'));
set(handles.StimAmp3Tag,'Enable','off');
set(handles.StimWeight3Tag,'Enable','off');

set(handles.StimAmp4Tag,'String','0'); handles.wh_stim_amp_4 = str2double(get(handles.StimAmp4Tag,'String'));
set(handles.StimWeight4Tag,'String','0'); handles.wh_stim_weight_4 = str2double(get(handles.StimWeight4Tag,'String'));
set(handles.StimAmp4Tag,'Enable','off');
set(handles.StimWeight4Tag,'Enable','off');

%% No stimulus probability
set(handles.NostimWeightTag,'String','8'); handles.no_stim_weight = str2double(get(handles.NostimWeightTag,'String'));
set(handles.NostimWeightTag,'Enable','on');

%% Context task information
set(handles.BlockSizeTag,'String','1'); handles.context_block_size = str2double(get(handles.BlockSizeTag,'String'));
set(handles.BlockSizeTag,'Enable','off');
set(handles.ContextTablePath,'String','M:\analysis\Pol_Bech\behaviour_context_files'); handles.context_table_directory = get(handles.ContextTablePath,'String');
set(handles.ContextTablePath,'Enable','off');

%% Set reward parameters
set(handles.ValveOpeningTag,'String','45'); handles.reward_valve_duration = str2double(get(handles.ValveOpeningTag,'String'));
set(handles.ValveOpeningTag, 'Enable', 'on');
set(handles.RewardDelayCheckbox,'Value',0); handles.reward_delay_flag = get(handles.RewardDelayCheckbox,'Value');
set(handles.RewardDelayCheckbox,'Enable','off');
set(handles.RewardDelayTag,'String','0'); handles.reward_delay_time = str2double(get(handles.RewardDelayTag,'String'));
set(handles.RewardDelayTag,'Enable','off');
set(handles.PartialRewardCheckbox,'Value',0); handles.partial_reward_flag = get(handles.PartialRewardCheckbox,'Value');
set(handles.PartialRewardCheckbox,'Enable','on');
set(handles.RewardProbTag,'String','1'); handles.reward_proba = str2double(get(handles.RewardProbTag,'String'));
set(handles.RewardProbTag,'Enable','off');
set(handles.AudRewTag,'Value',1); handles.aud_reward = get(handles.AudRewTag,'Value');
set(handles.AudRewTag,'Enable','off');
set(handles.WhRewTag,'Value',1); handles.wh_reward = get(handles.WhRewTag,'Value');
set(handles.WhRewTag,'Enable','on');
set(handles.LickThresholdTag,'String','0.05'); handles.lick_threshold = str2double(get(handles.LickThresholdTag,'String'));

%% Behaviour camera settings
set(handles.CameraFrameRateTag,'String','200'); handles.camera_freq = str2double(get(handles.CameraFrameRateTag,'String'));
set(handles.CameraFrameRateTag,'Enable','off');
set(handles.CameraStartDelayTag,'String','3'); handles.camera_start_delay = str2double(get(handles.CameraStartDelayTag,'String'));
set(handles.CameraStartDelayTag,'Enable','off');
set(handles.CameraExposureTimeTag,'String','2'); handles.camera_exposure_time = str2double(get(handles.CameraExposureTimeTag,'String'));
set(handles.CameraExposureTimeTag,'Enable','off');

%% Initialize axes
axes(handles.TrialStartTTL); set(gca,'XTick',[]); set(gca,'XColor','w'); set(gca,'YTick',[]); set(gca,'YColor','w');
axes(handles.Cam1Ax); set(gca,'XTick',[]); set(gca,'XColor','w'); set(gca,'YTick',[]); set(gca,'YColor','w');
axes(handles.Cam2Ax); set(gca,'XTick',[]); set(gca,'XColor','w'); set(gca,'YTick',[]); set(gca,'YColor','w');
axes(handles.LightAx); set(gca,'XTick',[]); set(gca,'XColor','w'); set(gca,'YTick',[]); set(gca,'YColor','w');
axes(handles.ScanAx); set(gca,'XTick',[]); set(gca,'XColor','w'); set(gca,'YTick',[]); set(gca,'YColor','w');

axes(handles.EarlyLickAxes); set(gca,'XTick',[]); set(gca,'XColor','w'); set(gca,'YTick',[]); set(gca,'YColor','w');
axes(handles.PerformanceAxes); set(gca,'XTick',[]); set(gca,'XColor','w'); set(gca,'YTick',[]); set(gca,'YColor','w');
set(handles.LastRecentTrialsTag,'String','5'); handles.last_recent_trials = str2double(get(handles.LastRecentTrialsTag,'String'));
axes(handles.LickTraceAx); set(gca,'XTick',[]); set(gca,'XColor','w'); set(gca,'YTick',[]); set(gca,'YColor','w');


%% Initialize text display

handles.PauseRequested=0;

% Update handles structure
handles2give=handles;
guidata(hObject, handles);

% UIWAIT makes DetectionGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DetectionGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;



function MinQuietWindowTag_Callback(hObject, eventdata, handles)
% hObject    handle to MinQuietWindowTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MinQuietWindowTag as text
%        str2double(get(hObject,'String')) returns contents of MinQuietWindowTag as a double
global handles2give

handles.min_quiet_window = round(str2double(get(handles.MinQuietWindowTag,'String')));
set(handles.MinQuietWindowTag,'String',handles.min_quiet_window);
% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function MinQuietWindowTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MinQuietWindowTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ResponseWindowTag_Callback(hObject, eventdata, handles)
% hObject    handle to ResponseWindowTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ResponseWindowTag as text
%        str2double(get(hObject,'String')) returns contents of ResponseWindowTag as a double
global handles2give
handles.response_window = round(str2double(get(handles.ResponseWindowTag,'String')));
set(handles.ResponseWindowTag,'String',handles.response_window);

    time_limit = handles.baseline_window + handles.response_window;

if handles.trial_duration < time_limit
    disp('Trial duration cannot be shorter than baseline + response window. Setting sum of two as default.');
    handles.trial_duration = time_limit;
    set(handles.TrialDurationTag,'String',num2str(handles.trial_duration));
end

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ResponseWindowTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ResponseWindowTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ArtifactWindowTag_Callback(hObject, eventdata, handles)
% hObject    handle to ArtifactWindowTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ArtifactWindowTag as text
%        str2double(get(hObject,'String')) returns contents of ArtifactWindowTag as a double
global handles2give
handles.artifact_window = round(str2double(get(handles.ArtifactWindowTag,'String')));
set(handles.ArtifactWindowTag,'String',handles.artifact_window);

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ArtifactWindowTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ArtifactWindowTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MinISITag_Callback(hObject, eventdata, handles)
% hObject    handle to MinISITag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MinISITag as text
%        str2double(get(hObject,'String')) returns contents of MinISITag as a double
global handles2give
handles.min_iti = round(str2double(get(handles.MinISITag,'String')));
set(handles.MinISITag,'String',handles.min_iti);

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function MinISITag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MinISITag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MaxISITag_Callback(hObject, eventdata, handles)
% hObject    handle to MaxISITag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaxISITag as text
%        str2double(get(hObject,'String')) returns contents of MaxISITag as a double
global handles2give
handles.max_iti = round(str2double(get(handles.MaxISITag,'String')));
set(handles.MaxISITag,'String',handles.max_iti);

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function MaxISITag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxISITag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in DummySessionCheckbox.
function TwoPhotonCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to TwoPhotonCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TwoPhotonCheckbox
global handles2give
handles.twophoton_session = get(handles.TwoPhotonCheckbox,'Value');

% Update handles structure
handles2give=handles;
guidata(hObject, handles);

% --- Executes on button press in DummySessionCheckbox.
function ThreePhotonCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to ThreePhotonCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ThreePhotonCheckbox
global handles2give
handles.threephoton_session = get(handles.ThreePhotonCheckbox,'Value');

% Update handles structure
handles2give=handles;
guidata(hObject, handles);

% --- Executes on button press in DummySessionCheckbox.
function WFCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to WFCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of WFCheckbox
global handles2give wf_gui

handles.wf_session = get(handles.WFCheckbox,'Value');

if handles.wf_session == 1
    addpath([fileparts(cd) '\WF_imaging\'])
    wf_gui = WF_GUI;
elseif exist('wf_gui') && handles.wf_session==0
    wf_gui.delete()
    clear wf_gui
end

% Update handles structure
handles2give=handles;
guidata(hObject, handles);

% --- Executes on button press in DummySessionCheckbox.
function EphysCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to EphysCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of EphysCheckbox
global handles2give
handles.ephys_session = get(handles.EphysCheckbox,'Value');

% Update handles structure
handles2give=handles;
guidata(hObject, handles);

% --- Executes on button press in DummySessionCheckbox.
function OptoCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to OptoCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OptoCheckbox
global handles2give opto_gui

handles.opto_session = get(handles.OptoCheckbox,'Value');

if handles.opto_session == 1
    addpath([cd '\utils_opto\'])
    opto_gui = Opto_GUI;
elseif exist('opto_gui') && handles.opto_session==0
    opto_gui.delete()
    clear opto_gui
end

% Update handles structure
handles2give=handles;
guidata(hObject, handles);

% --- Executes on button press in DummySessionCheckbox.
function ChemoCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to ChemoCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ChemoCheckbox
global handles2give
handles.chemo_session = get(handles.ChemoCheckbox,'Value');

% Update handles structure
handles2give=handles;
guidata(hObject, handles);

% --- Executes on button press in DummySessionCheckbox.
function PharmaCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to PharmaCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PharmaCheckbox
global handles2give
handles.pharma_session = get(handles.PharmaCheckbox,'Value');

% Update handles structure
handles2give=handles;
guidata(hObject, handles);

% --- Executes on button press in AssociationCheckbox.
function AssociationCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to AssociationCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AssociationCheckbox
global handles2give
handles.association_flag = get(handles.AssociationCheckbox,'Value');

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes on button press in DummySessionCheckbox.
function DummySessionCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to DummySessionCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DummySessionCheckbox
global handles2give
handles.dummy_session_flag = get(handles.DummySessionCheckbox,'Value');

% Update handles structure
handles2give=handles;
guidata(hObject, handles);



% --- Executes on button press in EarlyLickPunishmentCheckbox.
function EarlyLickPunishmentCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to EarlyLickPunishmentCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of EarlyLickPunishmentCheckbox
global handles2give
handles.early_lick_punish_flag = get(handles.EarlyLickPunishmentCheckbox,'Value');

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


function SetDateTag_Callback(hObject, eventdata, handles)
% hObject    handle to SetDateTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SetDateTag as text
%        str2double(get(hObject,'String')) returns contents of SetDateTag as a double


% --- Executes during object creation, after setting all properties.
function SetDateTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SetDateTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MouseNameTag_Callback(hObject, eventdata, handles)
% hObject    handle to MouseNameTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MouseNameTag as text
%        str2double(get(hObject,'String')) returns contents of MouseNameTag as a double
global handles2give
handles.mouse_name = get(handles.MouseNameTag,'String');

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function MouseNameTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MouseNameTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BehaviorDirectoryTag_Callback(hObject, eventdata, handles)
% hObject    handle to BehaviorDirectoryTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BehaviorDirectoryTag as text
%        str2double(get(hObject,'String')) returns contents of BehaviorDirectoryTag as a double
global handles2give
handles.behaviour_directory = get(handles.BehaviorDirectoryTag,'String');

% Update handles structure
handles2give=handles;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function BehaviorDirectoryTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BehaviorDirectoryTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function ToneDurationTag_Callback(hObject, eventdata, handles)
% hObject    handle to ToneDurationTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ToneDurationTag as text
%        str2double(get(hObject,'String')) returns contents of ToneDurationTag as a double
global handles2give

handles.aud_stim_duration = round(str2double(get(handles.ToneDurationTag,'String')));
set(handles.ToneDurationTag,'String',num2str(handles.aud_stim_duration));

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ToneDurationTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ToneDurationTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StimDuration1Tag_Callback(hObject, eventdata, handles)
% hObject    handle to StimDuration1Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StimDuration1Tag as text
%        str2double(get(hObject,'String')) returns contents of StimDuration1Tag as a double
global handles2give

handles.wh_stim_duration = round(str2double(get(handles.StimDuration1Tag,'String'))*100)/100;
set(handles.StimDuration1Tag,'String',num2str(handles.wh_stim_duration));

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function StimDuration1Tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StimDuration1Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StimAmp1Tag_Callback(hObject, eventdata, handles)
% hObject    handle to StimAmp1Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StimAmp1Tag as text
%        str2double(get(hObject,'String')) returns contents of StimAmp1Tag as a double
global handles2give

handles.wh_stim_amp_1 = round(str2double(get(handles.StimAmp1Tag,'String'))*100)/100;
set(handles.StimAmp1Tag,'String',num2str(handles.wh_stim_amp_1));

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function StimAmp1Tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StimAmp1Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StimWeight1Tag_Callback(hObject, eventdata, handles)
% hObject    handle to StimWeight1Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StimWeight1Tag as text
%        str2double(get(hObject,'String')) returns contents of StimWeight1Tag as a double
global handles2give

handles.wh_stim_weight_1 = round(str2double(get(handles.StimWeight1Tag,'String')));
set(handles.StimWeight1Tag,'String',num2str(handles.wh_stim_weight_1));

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function StimWeight1Tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StimWeight1Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function StimAmp2Tag_Callback(hObject, eventdata, handles)
% hObject    handle to StimAmp2Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StimAmp2Tag as text
%        str2double(get(hObject,'String')) returns contents of StimAmp2Tag as a double
global handles2give

handles.wh_stim_amp_2 = round(str2double(get(handles.StimAmp2Tag,'String'))*100)/100;
set(handles.StimAmp2Tag,'String',num2str(handles.wh_stim_amp_2));

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function StimAmp2Tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StimAmp2Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StimWeight2Tag_Callback(hObject, eventdata, handles)
% hObject    handle to StimWeight2Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StimWeight2Tag as text
%        str2double(get(hObject,'String')) returns contents of StimWeight2Tag as a double
global handles2give

handles.wh_stim_weight_2 = round(str2double(get(handles.StimWeight2Tag,'String')));
set(handles.StimWeight2Tag,'String',num2str(handles.wh_stim_weight_2));

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function StimWeight2Tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StimWeight2Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function StimAmp3Tag_Callback(hObject, eventdata, handles)
% hObject    handle to StimAmp3Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StimAmp3Tag as text
%        str2double(get(hObject,'String')) returns contents of StimAmp3Tag as a double
global handles2give

handles.wh_stim_amp_3 = round(str2double(get(handles.StimAmp3Tag,'String'))*100)/100;
set(handles.StimAmp3Tag,'String',num2str(handles.wh_stim_amp_3));

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function StimAmp3Tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StimAmp3Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StimWeight3Tag_Callback(hObject, eventdata, handles)
% hObject    handle to StimWeight3Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StimWeight3Tag as text
%        str2double(get(hObject,'String')) returns contents of StimWeight3Tag as a double
global handles2give

handles.wh_stim_weight_3 = round(str2double(get(handles.StimWeight3Tag,'String')));
set(handles.StimWeight3Tag,'String',num2str(handles.wh_stim_weight_3));

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function StimWeight3Tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StimWeight3Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function StimAmp4Tag_Callback(hObject, eventdata, handles)
% hObject    handle to StimAmp4Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StimAmp4Tag as text
%        str2double(get(hObject,'String')) returns contents of StimAmp4Tag as a double
global handles2give

handles.wh_stim_amp_4 = round(str2double(get(handles.StimAmp4Tag,'String'))*100)/100;
set(handles.StimAmp4Tag,'String',num2str(handles.wh_stim_amp_4));

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function StimAmp4Tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StimAmp4Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StimWeight4Tag_Callback(hObject, eventdata, handles)
% hObject    handle to StimWeight4Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StimWeight4Tag as text
%        str2double(get(hObject,'String')) returns contents of StimWeight4Tag as a double
global handles2give

handles.wh_stim_weight_4 = round(str2double(get(handles.StimWeight4Tag,'String')));
set(handles.StimWeight4Tag,'String',num2str(handles.wh_stim_weight_4));

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function StimWeight4Tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StimWeight4Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in StartBehaviourTag.
function StartBehaviourTag_Callback(hObject, eventdata, handles)
% hObject    handle to StartBehaviourTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    
global handles2give

% Get session time info
formatOut = 'yyyymmdd';
handles.date = datestr(now,formatOut); %get date of today upon session start

format shortg
c = clock;   % https://ch.mathworks.com/help/matlab/ref/clock.html
handles.session_time=[num2str(c(4),'%02.f') num2str(c(5),'%02.f') num2str(round(c(6)),'%02.f')];

% Create session directory
if ~exist([char(handles.behaviour_directory) '\' char(handles.mouse_name)],'dir')
    mkdir(handles.behaviour_directory,handles.mouse_name);
end
if ~exist([char(handles.behaviour_directory) '\' char(handles.mouse_name) '\'  char(handles.mouse_name) '_' char(handles.date) '_' handles.session_time],'dir')
    mkdir([char(handles.behaviour_directory) '\' char(handles.mouse_name)],[char(handles.mouse_name) '_' char(handles.date) '_' handles.session_time]);
end

% Clear current GUI axes
cla(handles.TrialStartTTL);
cla(handles.Cam1Ax);
cla(handles.Cam2Ax);
cla(handles.ScanAx);
cla(handles.LightAx);
cla(handles.PerformanceAxes);
cla(handles.LickTraceAx);
cla(handles.EarlyLickAxes);

set(handles2give.PerformanceText1Tag,'String',' ');
set(handles2give.PerformanceText2Tag,'String',' ');
set(handles2give.PerformanceText3Tag,'String',' ');
set(handles2give.OnlineTextTag,'String',' ');
set(handles2give.TrialTimeLineTextTag,'String',' ');

if handles2give.wf_session
    global wf_gui
    wf_gui.DirectoryEditField.Enable = 'Off';
    wf_gui.TriggermodeDropDown.Enable = 'Off';
    wf_gui.CameramodeDropDown.Enable = 'Off';
    wf_gui.ONCheckBox.Enable = 'Off';
    wf_gui.ONCheckBox_2.Enable = 'Off';
    wf_gui.Switch.Enable = 'Off';
    wf_gui.Switch_2.Enable = 'Off';
    
    wf_gui.update_WF_info

end

if handles2give.opto_session
    global opto_gui Opto_S
    opto_gui.GridDropDown.Enable = 'off';
    opto_gui.AssignbregmaCheckBox.Enable = 'off';
    opto_gui.update_opto_info
    
end

% Get handles for control and save handles as session configuration
handles2give= handles; 
save_session_config(handles);

% Define sessions
defining_sessions;

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in StopBehaviourTag.
function StopBehaviourTag_Callback(hObject, eventdata, handles)
% hObject    handle to StopBehaviourTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stop_sessions
global handles2give
if handles2give.wf_session
    global wf_gui
    wf_gui.DirectoryEditField.Enable = 'On';
    wf_gui.TriggermodeDropDown.Enable = 'On';
    wf_gui.CameramodeDropDown.Enable = 'On';
    wf_gui.ONCheckBox.Enable = 'On';
    wf_gui.ONCheckBox_2.Enable = 'On';
    wf_gui.Switch.Enable = 'On';
    wf_gui.Switch_2.Enable = 'On';
end

if handles2give.opto_session
    global opto_gui
    opto_gui.GridDropDown.Enable = 'on';
    opto_gui.AssignbregmaCheckBox.Enable = 'on';
end

function StimProbTag_Callback(hObject, eventdata, handles)
% hObject    handle to StimProbTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StimProbTag as text
%        str2double(get(hObject,'String')) returns contents of StimProbTag as a double
global handles2give

handles.StimProb = round(str2double(get(handles.StimProbTag,'String'))*100)/100;
if handles.StimProb > 1
    handles.StimProb = 1;
elseif handles.StimProb < 0
    handles.StimProb = 0;
end
set(handles.StimProbTag,'String',handles.StimProb);

% Update handles structure
handles2give= handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function StimProbTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StimProbTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NostimWeightTag_Callback(hObject, eventdata, handles)
% hObject    handle to NostimWeightTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NostimWeightTag as text
%        str2double(get(hObject,'String')) returns contents of NostimWeightTag as a double
global handles2give

handles.no_stim_weight = round(str2double(get(handles.NostimWeightTag,'String')));
set(handles.NostimWeightTag,'String',num2str(handles.no_stim_weight));

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function NostimWeightTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NostimWeightTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ToneAmpTag_Callback(hObject, eventdata, handles)
% hObject    handle to ToneAmpTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ToneAmpTag as text
%        str2double(get(hObject,'String')) returns contents of ToneAmpTag as a double
global handles2give

handles.aud_stim_amp = round(str2double(get(handles.ToneAmpTag,'String'))*100)/100;
set(handles.ToneAmpTag,'String',num2str(handles.aud_stim_amp));

% Update handles structure
handles2give= handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ToneAmpTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ToneAmpTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ToneFreqTag_Callback(hObject, eventdata, handles)
% hObject    handle to ToneFreqTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ToneFreqTag as text
%        str2double(get(hObject,'String')) returns contents of ToneFreqTag as a double
global handles2give

handles.aud_stim_freq = round(str2double(get(handles.ToneFreqTag,'String'))*100)/100;
set(handles.ToneFreqTag,'String',num2str(handles.aud_stim_freq));

% Update handles structure
handles2give= handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ToneFreqTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ToneFreqTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function ValveOpeningTag_Callback(hObject, eventdata, handles)
% hObject    handle to ValveOpeningTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ValveOpeningTag as text
%        str2double(get(hObject,'String')) returns contents of ValveOpeningTag as a double
global handles2give

handles.reward_valve_duration = round(str2double(get(handles.ValveOpeningTag,'String')));
set(handles.ValveOpeningTag,'String',num2str(handles.reward_valve_duration));

% Update handles structure
handles2give= handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ValveOpeningTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ValveOpeningTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RewardDelayTag_Callback(hObject, eventdata, handles)
% hObject    handle to RewardDelayTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RewardDelayTag as text
%        str2double(get(hObject,'String')) returns contents of RewardDelayTag as a double
global handles2give

handles.reward_delay_time = round(str2double(get(handles.RewardDelayTag,'String')));
set(handles.RewardDelayTag,'String',num2str(handles.reward_delay_time));

% Update handles structure
handles2give= handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function RewardDelayTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RewardDelayTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RewardDelayCheckbox.
function RewardDelayCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to RewardDelayCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RewardDelayCheckbox
global handles2give

handles.reward_delay_flag = get(handles.RewardDelayCheckbox,'Value');
if handles.reward_delay_flag
    set(handles.RewardDelayTag,'Enable','on');
else
    set(handles.RewardTag,'Enable','off');
end

% Update handles structure
handles2give= handles;
guidata(hObject, handles);



function LickThresholdTag_Callback(hObject, eventdata, handles)
% hObject    handle to LickThresholdTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LickThresholdTag as text
%        str2double(get(hObject,'String')) returns contents of LickThresholdTag as a double
global handles2give

handles.lick_threshold = round(str2double(get(handles.LickThresholdTag,'String'))*1000)/1000;
set(handles.LickThresholdTag,'String',num2str(handles.lick_threshold));

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function LickThresholdTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LickThresholdTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function FalseAlarmTimeOutTag_Callback(hObject, eventdata, handles)
% hObject    handle to FalseAlarmTimeOutTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EarlyLickTimeOutTag as text
%        str2double(get(hObject,'String')) returns contents of EarlyLickTimeOutTag as a double
global handles2give

handles.false_alarm_timeout = round(str2double(get(handles.FalseAlarmTimeOutTag,'String')));
set(handles.FalseAlarmTimeOutTag,'String',num2str(handles.false_alarm_timeout));

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function FalseAlarmTimeOutTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FalseAlarmTimeOutTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function EarlyLickTimeOutTag_Callback(hObject, eventdata, handles)
% hObject    handle to EarlyLickTimeOutTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EarlyLickTimeOutTag as text
%        str2double(get(hObject,'String')) returns contents of EarlyLickTimeOutTag as a double
global handles2give

handles.early_lick_timeout = round(str2double(get(handles.EarlyLickTimeOutTag,'String')));
set(handles.EarlyLickTimeOutTag,'String',num2str(handles.early_lick_timeout));

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function EarlyLickTimeOutTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EarlyLickTimeOutTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function LastRecentTrialsTag_Callback(hObject, eventdata, handles)
% hObject    handle to LastRecentTrialsTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LastRecentTrialsTag as text
%        str2double(get(hObject,'String')) returns contents of LastRecentTrialsTag as a double
global handles2give

handles.last_recent_trials = round(abs(str2double(get(handles.LastRecentTrialsTag,'String'))));
if handles.last_recent_trials < 1
    handles.last_recent_trials = 1;
end
set(handles.LastRecentTrialsTag,'String',num2str(handles.last_recent_trials));

% Update handles structure
handles2give=handles;
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function LastRecentTrialsTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LastRecentTrialsTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BrowseButton.
function BrowseButton_Callback(hObject, eventdata, handles)
% hObject    handle to BrowseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global handles2give

handles.behaviour_directory=uigetdir;
set(handles.BehaviorDirectoryTag,'String',handles.behaviour_directory);

handles2give=handles;
% Update handles structure
guidata(hObject, handles);



function PerformanceText1Tag_Callback(hObject, eventdata, handles)
% hObject    handle to PerformanceText1Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PerformanceText1Tag as text
%        str2double(get(hObject,'String')) returns contents of PerformanceText1Tag as a double


% --- Executes during object creation, after setting all properties.
function PerformanceText1Tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PerformanceText1Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PerformanceText2Tag_Callback(hObject, eventdata, handles)
% hObject    handle to PerformanceText2Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PerformanceText2Tag as text
%        str2double(get(hObject,'String')) returns contents of PerformanceText2Tag as a double


% --- Executes during object creation, after setting all properties.
function PerformanceText2Tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PerformanceText2Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PerformanceText3Tag_Callback(hObject, eventdata, handles)
% hObject    handle to PerformanceText3Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PerformanceText3Tag as text
%        str2double(get(hObject,'String')) returns contents of PerformanceText3Tag as a double


% --- Executes during object creation, after setting all properties.
function PerformanceText3Tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PerformanceText3Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TrialTimeLineTextTag_Callback(hObject, eventdata, handles)
% hObject    handle to TrialTimeLineTextTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TrialTimeLineTextTag as text
%        str2double(get(hObject,'String')) returns contents of TrialTimeLineTextTag as a double


% --- Executes during object creation, after setting all properties.
function TrialTimeLineTextTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TrialTimeLineTextTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OnlineTextTag_Callback(hObject, eventdata, handles)
% hObject    handle to OnlineTextTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OnlineTextTag as text
%        str2double(get(hObject,'String')) returns contents of OnlineTextTag as a double


% --- Executes during object creation, after setting all properties.
function OnlineTextTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OnlineTextTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BaselineWindowTag_Callback(hObject, eventdata, handles)
% hObject    handle to BaselineWindowTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BaselineWindowTag as text
%        str2double(get(hObject,'String')) returns contents of BaselineWindowTag as a double
global handles2give
handles.baseline_window = round(str2double(get(handles.BaselineWindowTag,'String')));
set(handles.BaselineWindowTag,'String',handles.baseline_window);

time_limit = handles.baseline_window + handles.response_window;

if handles.trial_duration < time_limit
    disp('Trial duration cannot be shorter than baseline + response window. Setting sum of two as default.');
    handles.trial_duration = time_limit;
    set(handles.TrialDurationTag,'String',num2str(handles.trial_duration));
end

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function BaselineWindowTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BaselineWindowTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TrialDurationTag_Callback(hObject, eventdata, handles)
% hObject    handle to TrialDurationTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TrialDurationTag as text
%        str2double(get(hObject,'String')) returns contents of TrialDurationTag as a double
global handles2give

handles.trial_duration = round(str2double(get(handles.TrialDurationTag,'String')));
set(handles.TrialDurationTag,'String',num2str(handles.trial_duration));

time_limit = handles.baseline_window + handles.response_window;

if handles.trial_duration < time_limit
    disp('Trial duration cannot be shorter than baseline + response window. Setting sum of two as default.');
    handles.trial_duration = time_limit;
    set(handles.TrialDurationTag,'String',num2str(handles.trial_duration));
end

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function TrialDurationTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TrialDurationTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CameraFrameRateTag_Callback(hObject, eventdata, handles)
% hObject    handle to CameraFrameRateTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CameraFrameRateTag as text
%        str2double(get(hObject,'String')) returns contents of CameraFrameRateTag as a double
global handles2give

handles.camera_freq = round(str2double(get(handles.CameraFrameRateTag,'String')));
set(handles.CameraFrameRateTag,'String',num2str(handles.camera_freq));

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function CameraFrameRateTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CameraFrameRateTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in FalseAlarmPunishmentCheckbox.
function FalseAlarmPunishmentCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to FalseAlarmPunishmentCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FalseAlarmPunishmentCheckbox
global handles2give

handles.false_alarm_punish_flag = get(handles.FalseAlarmPunishmentCheckbox,'Value');

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes on button press in ManualRewardButton.
function ManualRewardButton_Callback(hObject, eventdata, handles)
% hObject    handle to ManualRewardButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
manual_reward_delivery



% --- Executes on button press in PauseBehaviourTag.
function PauseBehaviourTag_Callback(hObject, eventdata, handles)
% hObject    handle to PauseBehaviourTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global handles2give

handles.PauseRequested=1;
handles.ReportPause=1;
% Update handles structure
handles2give= handles;
guidata(hObject, handles);


% --- Executes on button press in ResumeBehaviourTag.
function ResumeBehaviourTag_Callback(hObject, eventdata, handles)
% hObject    handle to ResumeBehaviourTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global handles2give

handles.PauseRequested=0;
% Update handles structure
handles2give= handles;
guidata(hObject, handles);



function RewardProbTag_Callback(hObject, eventdata, handles)
% hObject    handle to RewardProbTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RewardProbTag as text
%        str2double(get(hObject,'String')) returns contents of RewardProbTag as a double
global handles2give

handles.reward_proba = round(str2double(get(handles.RewardProbTag,'String'))*10)/10;
set(handles.RewardProbTag,'String',num2str(handles.reward_proba));

% Update handles structure
handles2give= handles;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function RewardProbTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RewardProbTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PartialRewardCheckbox.
function PartialRewardCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to PartialRewardCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PartialRewardCheckbox
global handles2give

handles.partial_reward_flag = get(handles.PartialRewardCheckbox,'Value');
if handles.partial_reward_flag
    set(handles.RewardProbTag,'Enable','on');
else
    set(handles.RewardProbTag,'Enable','off');
end

% Update handles structure
handles2give= handles;
guidata(hObject, handles);



function MaxQuietWindowTag_Callback(hObject, eventdata, handles)
% hObject    handle to MaxQuietWindowTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaxQuietWindowTag as text
%        str2double(get(hObject,'String')) returns contents of MaxQuietWindowTag as a double
global handles2give

handles.max_quiet_window = round(str2double(get(handles.MaxQuietWindowTag,'String')));
set(handles.MaxQuietWindowTag,'String',handles.max_quiet_window);
% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function MaxQuietWindowTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxQuietWindowTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in MappingCheckbox.
function MappingCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to MappingCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of MappingCheckbox

handles.MappingFlag = get(handles.MappingCheckbox,'Value');



function AStimWeightTag_Callback(hObject, eventdata, handles)
% hObject    handle to AStimWeightTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AStimWeightTag as text
%        str2double(get(hObject,'String')) returns contents of AStimWeightTag as a double

global handles2give

handles.aud_stim_weight = round(str2double(get(handles.AStimWeightTag,'String')));
set(handles.AStimWeightTag,'String',num2str(handles.aud_stim_weight));


if handles.aud_stim_weight > 0
    
    set(handles.ToneDurationTag,'Enable','on');
    set(handles.ToneAmpTag,'Enable','on');
    set(handles.ToneFreqTag,'Enable','on');
    set(handles.AudRewTag,'Enable','on');
    
else 
    
    set(handles.ToneDurationTag,'Enable','off');
    set(handles.ToneAmpTag,'Enable','off');
    set(handles.ToneFreqTag,'Enable','off');
    set(handles.AudRewTag,'Enable','off');
end
    

% Update handles structure
handles2give=handles;
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function AStimWeightTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AStimWeightTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AudRewTag.
function AudRewTag_Callback(hObject, eventdata, handles)
% hObject    handle to AudRewTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AudRewTag
global handles2give
handles.aud_reward = get(handles.AudRewTag,'Value');
handles2give=handles;
guidata(hObject, handles)


% --- Executes on button press in WhRewTag.
function WhRewTag_Callback(hObject, eventdata, handles)
% hObject    handle to WhRewTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of WhRewTag
global handles2give
handles.wh_reward = get(handles.WhRewTag,'Value');
handles2give=handles;
guidata(hObject, handles)


% --- Executes on button press in CameraTagCheck.
function CameraTagCheck_Callback(hObject, eventdata, handles)
% hObject    handle to CameraTagCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CameraTagCheck
global handles2give
handles.camera_flag=get(handles.CameraTagCheck,'Value');

if handles.camera_flag
    set(handles.CameraFrameRateTag,'Enable','on');
    set(handles.CameraStartDelayTag,'Enable','on');
    set(handles.CameraExposureTimeTag,'Enable','on');
else
    set(handles.CameraFrameRateTag,'Enable','off');
    set(handles.CameraStartDelayTag,'Enable','off');
    set(handles.CameraExposureTimeTag,'Enable','off');
end
handles2give=handles;
guidata(hObject, handles)



function LightDurationTag_Callback(hObject, eventdata, handles)
% hObject    handle to LightDurationTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LightDurationTag as text
%        str2double(get(hObject,'String')) returns contents of LightDurationTag as a double

global handles2give

handles.light_duration = round(str2double(get(handles.LightDurationTag,'String')));
set(handles.LightDurationTag,'String',num2str(handles.light_duration));

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function LightDurationTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LightDurationTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function LightPrestimDelayTag_Callback(hObject, eventdata, handles)
% hObject    handle to LightPrestimDelayTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LightPrestimDelayTag as text
%        str2double(get(hObject,'String')) returns contents of LightPrestimDelayTag as a double
global handles2give

handles.light_prestim_delay = round(str2double(get(handles.LightPrestimDelayTag,'String')));
set(handles.LightPrestimDelayTag,'String',num2str(handles.light_prestim_delay));

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function LightPrestimDelayTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LightPrestimDelayTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function LightAmpTag_Callback(hObject, eventdata, handles)
% hObject    handle to LightAmpTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LightAmpTag as text
%        str2double(get(hObject,'String')) returns contents of LightAmpTag as a double
global handles2give

handles.light_amp = round(str2double(get(handles.LightAmpTag,'String'))*100)/100;
set(handles.LightAmpTag,'String',num2str(handles.light_amp));

% Update handles structure
handles2give= handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function LightAmpTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LightAmpTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function LightFreqTag_Callback(hObject, eventdata, handles)
% hObject    handle to LightFreqTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LightFreqTag as text
%        str2double(get(hObject,'String')) returns contents of LightFreqTag as a double

global handles2give

handles.light_freq = round(str2double(get(handles.LightFreqTag,'String'))*100)/100;
set(handles.LightFreqTag,'String',num2str(handles.light_freq));

% Update handles structure
handles2give= handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function LightFreqTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LightFreqTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function LightDutyTag_Callback(hObject, eventdata, handles)
% hObject    handle to LightDutyTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LightDutyTag as text
%        str2double(get(hObject,'String')) returns contents of LightDutyTag as a double
global handles2give

handles.light_duty = round(str2double(get(handles.LightDutyTag,'String'))*100)/100;
set(handles.LightDutyTag,'String',num2str(handles.light_duty));

% Update handles structure
handles2give= handles;
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function LightDutyTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LightDutyTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% function LightProbAudTag_Callback(hObject, eventdata, handles)
% % hObject    handle to LightProbAudTag (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: get(hObject,'String') returns contents of LightProbAudTag as text
% %        str2double(get(hObject,'String')) returns contents of LightProbAudTag as a double
% global handles2give
% 
% handles.light_aud_proba = round(str2double(get(handles.LightProbAudTag,'String'))*100)/100;
% if handles.light_aud_proba > 1
%     handles.light_aud_proba = 1;
% elseif handles.light_aud_proba < 0
%     handles.light_aud_proba = 0;
% end
% set(handles.LightProbAudTag,'String',handles.light_aud_proba);
% 
% % Update handles structure
% handles2give= handles;
% guidata(hObject, handles);


% % --- Executes during object creation, after setting all properties.
% function LightProbAudTag_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to LightProbAudTag (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: edit controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end


% --- Executes on button press in LightCheckbox.
function LightCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to LightCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LightCheckbox

global handles2give

handles.light_flag = get(handles.LightCheckbox,'Value');
if handles.light_flag
    set(handles.LightDurationTag,'Enable','on');
    set(handles.LightPrestimDelayTag,'Enable','on');
    set(handles.LightAmpTag,'Enable','on');
    set(handles.LightFreqTag,'Enable','on');
    set(handles.LightDutyTag,'Enable','on');
    set(handles.LightStimWeightTag,'Enable','on');

else
    set(handles.LightDurationTag,'Enable','off');
    set(handles.LightPrestimDelayTag,'Enable','off');
    set(handles.LightAmpTag,'Enable','off');
    set(handles.LightFreqTag,'Enable','off');
    set(handles.LightDutyTag,'Enable','off');
    set(handles.LightStimWeightTag,'Enable','off');

end

% Update handles structure
handles2give=handles;
guidata(hObject, handles);



% function LightProbWhTag_Callback(hObject, eventdata, handles)
% % hObject    handle to LightProbWhTag (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: get(hObject,'String') returns contents of LightProbWhTag as text
% %        str2double(get(hObject,'String')) returns contents of LightProbWhTag as a double
% 
% global handles2give
% 
% handles.light_wh_proba = round(str2double(get(handles.LightProbWhTag,'String'))*100)/100;
% if handles.light_wh_proba > 1
%     handles.light_wh_proba = 1;
% elseif handles.light_wh_proba < 0
%     handles.light_wh_proba = 0;
% end
% set(handles.LightProbWhTag,'String',handles.light_wh_proba);
% 
% % Update handles structure
% handles2give= handles;
% guidata(hObject, handles);

% 
% % --- Executes during object creation, after setting all properties.
% function LightProbWhTag_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to LightProbWhTag (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: edit controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end



% function LightProbNoStimTag_Callback(hObject, eventdata, handles)
% % hObject    handle to LightProbNoStimTag (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: get(hObject,'String') returns contents of LightProbNoStimTag as text
% %        str2double(get(hObject,'String')) returns contents of LightProbNoStimTag as a double
% global handles2give
% 
% handles.light_proba = round(str2double(get(handles.LightProbNoStimTag,'String'))*100)/100;
% if handles.light_proba > 1
%     handles.light_proba = 1;
% elseif handles.light_proba < 0
%     handles.light_proba = 0;
% end
% set(handles.LightProbNoStimTag,'String',handles.light_proba);
% 
% % Update handles structure
% handles2give= handles;
% guidata(hObject, handles);


% % --- Executes during object creation, after setting all properties.
% function LightProbNoStimTag_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to LightProbNoStimTag (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: edit controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end


function MouseWeightBeforeTag_Callback(hObject, eventdata, handles)
% hObject    handle to MouseWeightBeforeTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MouseWeightBeforeTag as text
%        str2double(get(hObject,'String')) returns contents of MouseWeightBeforeTag as a double

global handles2give
handles.mouse_weight_before = str2double(get(handles.MouseWeightBeforeTag,'String'));

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function MouseWeightBeforeTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MouseWeightBeforeTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MouseWeightAfterTag_Callback(hObject, eventdata, handles)
% hObject    handle to MouseWeightAfterTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MouseWeightAfterTag as text
%        str2double(get(hObject,'String')) returns contents of MouseWeightAfterTag as a double

global handles2give
handles.mouse_weight_after = str2double(get(handles.MouseWeightAfterTag,'String'));

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function MouseWeightAfterTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MouseWeightAfterTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in UpdateWeightTag.
function UpdateWeightTag_Callback(hObject, eventdata, handles)
% hObject    handle to UpdateWeightTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.mouse_weight_before = str2double(get(handles.MouseWeightBeforeTag,'String'));
handles.mouse_weight_after = str2double(get(handles.MouseWeightAfterTag,'String'));

% Update config file
save_session_config(handles);
disp('Updated config file.');

guidata(hObject, handles);


% --- Executes on button press in ContextCheckBox.
function ContextCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to ContextCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ContextCheckBox
global handles2give

handles.context_flag = get(handles.ContextCheckBox,'Value');
if handles.context_flag
    set(handles.BlockSizeTag,'Enable','on');
    set(handles.ContextTablePath,'Enable','on');
    set(handles.BckgNoiseFolderPath,'Enable','on');
    set(handles.ContextSoundCheckBox,'Enable','on');
    set(handles.WhRewTag,'Value',1); handles.wh_reward = get(handles.WhRewTag,'Value');
    set(handles.WhRewTag,'Enable','off');
else 
    set(handles.BlockSizeTag,'Enable','off');
    set(handles.ContextTablePath,'Enable','off');
    set(handles.BckgNoiseFolderPath,'Enable','off');
    set(handles.ContextSoundCheckBox,'Enable','off');
    set(handles.WhRewTag,'Value',1); handles.wh_reward = get(handles.WhRewTag,'Value');
    set(handles.WhRewTag,'Enable','on');
end
% Update handles structure
handles2give=handles;
guidata(hObject, handles);



function BlockSizeTag_Callback(hObject, eventdata, handles)
% hObject    handle to BlockSizeTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BlockSizeTag as text
%        str2double(get(hObject,'String')) returns contents of BlockSizeTag as a double
global handles2give

handles.context_block_size = round(str2double(get(handles.BlockSizeTag,'String')));
set(handles.BlockSizeTag,'String',num2str(handles.context_block_size));

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function BlockSizeTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BlockSizeTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BckgNoiseFolderPath_Callback(hObject, eventdata, handles)
% hObject    handle to BckgNoiseFolderPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BckgNoiseFolderPath as text
%        str2double(get(hObject,'String')) returns contents of
%        BckgNoiseFolderPath as a double
global handles2give
handles.bckg_noise_directory = get(handles.BckgNoiseFolderPath,'String');

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function BckgNoiseFolderPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BckgNoiseFolderPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ContextTablePath_Callback(hObject, eventdata, handles)
% hObject    handle to ContextTablePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ContextTablePath as text
%        str2double(get(hObject,'String')) returns contents of ContextTablePath as a double
global handles2give
handles.context_table_directory = get(handles.ContextTablePath,'String');

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ContextTablePath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ContextTablePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function scaling_factor_Callback(hObject, eventdata, handles)
% hObject    handle to scaling_factor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scaling_factor as text
%        str2double(get(hObject,'String')) returns contents of scaling_factor as a double
global handles2give

handles.wh_scaling_factor = round(str2double(get(handles.scaling_factor,'String'))*100)/100;
set(handles.scaling_factor,'String',num2str(handles.scaling_factor));

% Update handles structure
handles2give= handles;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function scaling_factor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scaling_factor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CameraExposureTimeTag_Callback(hObject, eventdata, handles)
% hObject    handle to CameraExposureTimeTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CameraExposureTimeTag as text
%        str2double(get(hObject,'String')) returns contents of CameraExposureTimeTag as a double
global handles2give

handles.camera_exposure_time = round(str2double(get(handles.CameraExposureTimeTag,'String'))*100)/100;
set(handles.CameraExposureTimeTag,'String',num2str(handles.camera_exposure_time));

% Update handles structure
handles2give= handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function CameraExposureTimeTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CameraExposureTimeTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CameraStartDelayTag_Callback(hObject, eventdata, handles)
% hObject    handle to CameraStartDelayTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CameraStartDelayTag as text
%        str2double(get(hObject,'String')) returns contents of CameraStartDelayTag as a double
global handles2give

handles.camera_start_delay = round(str2double(get(handles.CameraStartDelayTag,'String'))*100)/100;
set(handles.CameraStartDelayTag,'String',num2str(handles.camera_start_delay));

% Update handles structure
handles2give= handles;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function CameraStartDelayTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CameraStartDelayTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in StimAmpRangeCheckbox.
function StimAmpRangeCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to StimAmpRangeCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of StimAmpRangeCheckbox
global handles2give

handles.wh_stim_amp_range = get(handles.StimAmpRangeCheckbox,'Value');
if handles.wh_stim_amp_range
    set(handles.StimAmp2Tag,'Enable','on');
    set(handles.StimWeight2Tag,'Enable','on');
    set(handles.StimAmp3Tag,'Enable','on');
    set(handles.StimWeight3Tag,'Enable','on');
    set(handles.StimAmp4Tag,'Enable','on');
    set(handles.StimWeight4Tag,'Enable','on');
else
    set(handles.StimAmp2Tag,'Enable','off');
    set(handles.StimWeight2Tag,'Enable','off');
    set(handles.StimWeight2Tag,'String','0'); handles.wh_stim_weight_2 = str2double(get(handles.StimWeight2Tag,'String'));
    set(handles.StimAmp3Tag,'Enable','off');
    set(handles.StimWeight3Tag,'Enable','off');
    set(handles.StimWeight3Tag,'String','0'); handles.wh_stim_weight_3 = str2double(get(handles.StimWeight3Tag,'String'));
    set(handles.StimAmp4Tag,'Enable','off');
    set(handles.StimWeight4Tag,'Enable','off');
    set(handles.StimWeight4Tag,'String','0'); handles.wh_stim_weight_4 = str2double(get(handles.StimWeight4Tag,'String'));
end

% Update handles structure
handles2give=handles;
guidata(hObject, handles);




function LightStimWeightTag_Callback(hObject, eventdata, handles)
% hObject    handle to LightStimWeightTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LightStimWeightTag as text
%        str2double(get(hObject,'String')) returns contents of LightStimWeightTag as a double
global handles2give

handles.light_stim_weight = round(str2double(get(handles.LightStimWeightTag,'String'))*100)/100;
if handles.light_stim_weight > 1
   handles.light_stim_weight = 1;
elseif handles.light_stim_weight < 0
   handles.light_stim_weight = 0;
end
set(handles.LightStimWeightTag,'String',handles.light_stim_weight);

% Update handles structure
handles2give= handles;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function LightStimWeightTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LightStimWeightTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
   set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function BehaviourTypeMenu_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
global handles2give
contents = cellstr(get(hObject, 'String'));
choice = contents{get(hObject, 'Value')};
handles.behaviour_type = choice;

handles2give=handles;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function BehaviourTypeMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in BehaviourTypemenu.
function BehaviourTypemenu_Callback(hObject, eventdata, handles)
% hObject    handle to BehaviourTypemenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns BehaviourTypemenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from BehaviourTypemenu


% --- Executes during object creation, after setting all properties.
function BehaviourTypemenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BehaviourTypemenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ContextSoundCheckBox.
function ContextSoundCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to ContextSoundCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ContextSoundCheckBox
global handles2give

handles.context_sound_on = get(handles.ContextSoundCheckBox,'Value');

% Update handles structure
handles2give=handles;
guidata(hObject, handles);
