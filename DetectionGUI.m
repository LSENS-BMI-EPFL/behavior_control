function varargout = DetectionGUI(varargin)
% DETECTIONGUI MATLAB code for DetectionGUI.fig
%      DETECTIONGUI, by itself, creates a new DETECTIONGUI or raises the existing
%      singleton*.
%
%      H = DETECTIONGUI returns the handle to a new DETECTIONGUI or the handle to
%      the existing singleton*.
%
%      DETECTIONGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DETECTIONGUI.M with the given input arguments.
%
%      DETECTIONGUI('Property','Value',...) creates a new DETECTIONGUI or raises the
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

% Last Modified by GUIDE v2.5 24-Oct-2019 09:52:32

% Begin initialization code - DO NOT EDIT
% global handles2give
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

%% Set experimental name for saving data
formatOut = 'yyyymmdd';
handles.Date = datestr(now,formatOut);
formatOut = 'yyyy/mm/dd';
Date2Display = datestr(now,formatOut);
set(handles.SetDateTag,'String',Date2Display);
set(handles.SetDateTag,'Enable','off');
set(handles.MouseNameTag,'String','ARXXX'); handles.MouseName = get(handles.MouseNameTag,'String');
handles.BehaviorDirectory = 'D:\AR';
set(handles.BehaviorDirectoryTag,'String',handles.BehaviorDirectory);

%% Set general settings
set(handles.MappingCheckbox,'Value',0); handles.MappingFlag = get(handles.MappingCheckbox,'Value');
set(handles.MappingCheckbox,'Enable','off');
set(handles.EarlyLickPunishmentCheckbox,'Value',0); handles.EarlyLickPunishmentFlag = get(handles.EarlyLickPunishmentCheckbox,'Value');
set(handles.EarlyLickPunishmentCheckbox,'Enable','off');
set(handles.AssociationCheckbox,'Value',0); handles.AssociationFlag = get(handles.AssociationCheckbox,'Value');
set(handles.CameraTagCheck,'Value',1); handles.CameraFlag = get(handles.CameraTagCheck,'Value');%% Behaviour camera settings

%% Set the timeline paramters
set(handles.MinQuietWindowTag,'String','3000'); handles.MinQuietWindow = str2double(get(handles.MinQuietWindowTag,'String'));
set(handles.MaxQuietWindowTag,'String','5000'); handles.MaxQuietWindow = str2double(get(handles.MaxQuietWindowTag,'String'));
set(handles.ResponseWindowTag,'String','1000'); handles.ResponseWindow = str2double(get(handles.ResponseWindowTag,'String'));
set(handles.ArtifactWindowTag,'String','50'); handles.ArtifactWindow = str2double(get(handles.ArtifactWindowTag,'String'));
set(handles.MinISITag,'String','6000'); handles.MinISI = str2double(get(handles.MinISITag,'String'));
set(handles.MaxISITag,'String','10000'); handles.MaxISI = str2double(get(handles.MaxISITag,'String'));
set(handles.BaselineWindowTag,'String','0'); handles.BaselineWindow = str2double(get(handles.BaselineWindowTag,'String'));
set(handles.TrialDurationTag,'String','7000'); handles.TrialDuration = str2double(get(handles.TrialDurationTag,'String'));

%% Set Light parameters
set(handles.OptoLightCheckbox,'Value',0); handles.LightFlag = get(handles.OptoLightCheckbox,'Value');
set(handles.OptoLightCheckbox,'Enable','off');


set(handles.LightDurationTag,'Enable','off');
set(handles.LightPrestimDelayTag,'Enable','off');
set(handles.LightAmpTag,'Enable','off');
set(handles.LightFreqTag,'Enable','off');
set(handles.LightDutyTag,'Enable','off');
set(handles.LightProbAudTag,'Enable','off');
set(handles.LightProbWhTag,'Enable','off');
set(handles.LightProbNoStimTag,'Enable','off');

set(handles.LightDurationTag,'String','200'); handles.LightDuration = str2double(get(handles.LightDurationTag,'String'));
set(handles.LightPrestimDelayTag,'String','100'); handles.LightPrestimDelay = str2double(get(handles.LightPrestimDelayTag,'String'));
set(handles.LightAmpTag,'String','5'); handles.LightAmp = str2double(get(handles.LightAmpTag,'String'));
set(handles.LightFreqTag,'String','100'); handles.LightFreq = str2double(get(handles.LightFreqTag,'String'));
set(handles.LightDutyTag,'String','0.65'); handles.LightDuty = str2double(get(handles.LightDutyTag,'String'));
set(handles.LightProbAudTag,'String','0.4'); handles.LightProbAud = str2double(get(handles.LightProbAudTag,'String'));
set(handles.LightProbWhTag,'String','0.4'); handles.LightProbWh = str2double(get(handles.LightProbWhTag,'String'));
set(handles.LightProbNoStimTag,'String','0.4'); handles.LightProb = str2double(get(handles.LightProbNoStimTag,'String'));
%% Set Auditory parameters

set(handles.ToneDurationTag,'Enable','on');
set(handles.ToneAmpTag,'Enable','on');
set(handles.ToneFreqTag,'Enable','on');

set(handles.ToneDurationTag,'String','10'); handles.ToneDuration = str2double(get(handles.ToneDurationTag,'String'));
set(handles.ToneAmpTag,'String','2'); handles.ToneAmp = str2double(get(handles.ToneAmpTag,'String'));
set(handles.ToneFreqTag,'String','8000'); handles.ToneFreq= str2double(get(handles.ToneFreqTag,'String'));

%% Set Early Lick Punishment parameters

set(handles.EarlyLickTimeOutTag,'String','3000'); handles.EarlyLickTimeOut = str2double(get(handles.EarlyLickTimeOutTag,'String'));
set(handles.EarlyLickTimeOutTag,'Enable','off');

%% Set the stim paramters

set(handles.NumStimTag,'String','1'); handles.NumStim = str2double(get(handles.NumStimTag,'String'));
set(handles.NumStimTag,'Enable','off');

%Auditory stim
set(handles.AStimWeightTag,'Enable','on')
set(handles.AStimWeightTag,'String','1'); handles.AStimWeight = str2double(get(handles.AStimWeightTag,'String'));

%Whisker stimuli
% Stim 1 
set(handles.StimDuration1Tag,'String','1'); handles.StimDuration(1) = str2double(get(handles.StimDuration1Tag,'String'));
set(handles.StimAmp1Tag,'String','5'); handles.StimAmp(1) = str2double(get(handles.StimAmp1Tag,'String'));
set(handles.StimWeight1Tag,'String','0'); handles.StimWeight(1) = str2double(get(handles.StimWeight1Tag,'String'));

% Stim 2
set(handles.StimDuration2Tag,'String','1'); handles.StimDuration(2) = str2double(get(handles.StimDuration2Tag,'String'));
set(handles.StimDuration2Tag,'Enable','off');
set(handles.StimAmp2Tag,'String','1'); handles.StimAmp(2) = str2double(get(handles.StimAmp2Tag,'String'));
set(handles.StimAmp2Tag,'Enable','off');
set(handles.StimWeight2Tag,'String','1'); handles.StimWeight(2) = str2double(get(handles.StimWeight2Tag,'String'));
set(handles.StimWeight2Tag,'Enable','off');

% Stim 3
set(handles.StimDuration3Tag,'String','1'); handles.StimDuration(3) = str2double(get(handles.StimDuration3Tag,'String'));
set(handles.StimDuration3Tag,'Enable','off');
set(handles.StimAmp3Tag,'String','1.5'); handles.StimAmp(3) = str2double(get(handles.StimAmp3Tag,'String'));
set(handles.StimAmp3Tag,'Enable','off');
set(handles.StimWeight3Tag,'String','1'); handles.StimWeight(3) = str2double(get(handles.StimWeight3Tag,'String'));
set(handles.StimWeight3Tag,'Enable','off');

% Stim 4
set(handles.StimDuration4Tag,'String','1'); handles.StimDuration(4) = str2double(get(handles.StimDuration4Tag,'String'));
set(handles.StimDuration4Tag,'Enable','off');
set(handles.StimAmp4Tag,'String','2'); handles.StimAmp(4) = str2double(get(handles.StimAmp4Tag,'String'));
set(handles.StimAmp4Tag,'Enable','off');
set(handles.StimWeight4Tag,'String','1'); handles.StimWeight(4) = str2double(get(handles.StimWeight4Tag,'String'));
set(handles.StimWeight4Tag,'Enable','off');

% Stim 5
set(handles.StimDuration5Tag,'String','1'); handles.StimDuration(5) = str2double(get(handles.StimDuration5Tag,'String'));
set(handles.StimDuration5Tag,'Enable','off');
set(handles.StimAmp5Tag,'String','2.5'); handles.StimAmp(5) = str2double(get(handles.StimAmp5Tag,'String'));
set(handles.StimAmp5Tag,'Enable','off');
set(handles.StimWeight5Tag,'String','1'); handles.StimWeight(5) = str2double(get(handles.StimWeight5Tag,'String'));
set(handles.StimWeight5Tag,'Enable','off');

% Stim 6
set(handles.StimDuration6Tag,'String','1'); handles.StimDuration(6) = str2double(get(handles.StimDuration6Tag,'String'));
set(handles.StimDuration6Tag,'Enable','off');
set(handles.StimAmp6Tag,'String','3'); handles.StimAmp(6) = str2double(get(handles.StimAmp6Tag,'String'));
set(handles.StimAmp6Tag,'Enable','off');
set(handles.StimWeight6Tag,'String','1'); handles.StimWeight(6) = str2double(get(handles.StimWeight6Tag,'String'));
set(handles.StimWeight6Tag,'Enable','off');

% Stim probability
% set(handles.StimProbTag,'Enable','off')
% set(handles.StimProbTag,'String',''); handles.StimProb = str2double(get(handles.StimProbTag,'String'));
set(handles.NostimWeightTag,'String','1'); handles.NostimWeight = str2double(get(handles.NostimWeightTag,'String'));
set(handles.NostimWeightTag,'Enable','on');

% Max number of trials in row
set(handles.MaxTrialsInRowCheckbox,'Value',0); handles.MaxTrialsInRowFlag = get(handles.MaxTrialsInRowCheckbox,'Value');
set(handles.MaxTrialsInRowCheckbox,'Enable','off');
set(handles.MaxTrialsInRowTag,'String','3'); handles.MaxTrialsInRow = str2double(get(handles.MaxTrialsInRowTag,'String'));
set(handles.MaxTrialsInRowTag,'Enable','off');

%% Set reward parameters
set(handles.ValveOpeningTag,'String','54'); handles.ValveOpening = str2double(get(handles.ValveOpeningTag,'String'));
set(handles.RewardDelayCheckbox,'Value',0); handles.RewardDelayFlag = get(handles.RewardDelayCheckbox,'Value');
set(handles.RewardDelayCheckbox,'Enable','off');
set(handles.RewardDelayTag,'String','50'); handles.RewardDelay = str2double(get(handles.RewardDelayTag,'String'));
set(handles.RewardDelayTag,'Enable','off');
set(handles.PartialRewardCheckbox,'Value',0); handles.PartialRewardFlag = get(handles.PartialRewardCheckbox,'Value');
set(handles.PartialRewardCheckbox,'Enable','off');
set(handles.RewardProbTag,'Enable','off');
set(handles.RewardProbTag,'String','1'); handles.RewardProb = str2double(get(handles.RewardProbTag,'String'));
set(handles.AudRewTag,'Value',1); handles.AudRew = get(handles.AudRewTag,'Value');
set(handles.AudRewTag,'Enable','off');
set(handles.WhRewTag,'Value',1); handles.wh_rew = get(handles.WhRewTag,'Value');%% Behaviour camera settings
set(handles.CameraFrameRateTag,'String','200'); handles.CameraFrameRate = str2double(get(handles.CameraFrameRateTag,'String'));

%% Initialize axes
axes(handles.ProgressBarAxes); set(gca,'XTick',[]); set(gca,'XColor','w'); set(gca,'YTick',[]); set(gca,'YColor','w');set(gca,'Color',[0.4 0.4 0.4]);
axes(handles.CameraAxes); set(gca,'XTick',[]); set(gca,'XColor','w'); set(gca,'YTick',[]); set(gca,'YColor','w');
axes(handles.AudAxes); set(gca,'XTick',[]); set(gca,'XColor','w'); set(gca,'YTick',[]); set(gca,'YColor','w');
axes(handles.LightAxes); set(gca,'XTick',[]); set(gca,'XColor','w'); set(gca,'YTick',[]); set(gca,'YColor','w');
axes(handles.WhAxes); set(gca,'XTick',[]); set(gca,'XColor','w'); set(gca,'YTick',[]); set(gca,'YColor','w');

axes(handles.EarlyLickAxes); set(gca,'XTick',[]); set(gca,'XColor','w'); set(gca,'YTick',[]); set(gca,'YColor','w');
axes(handles.PerformanceAxes); set(gca,'XTick',[]); set(gca,'XColor','w'); set(gca,'YTick',[]); set(gca,'YColor','w');
set(handles.LastRecentTrialsTag,'String','5'); handles.LastRecentTrials = str2double(get(handles.LastRecentTrialsTag,'String'));
axes(handles.LickTraceAxes); set(gca,'XTick',[]); set(gca,'XColor','w'); set(gca,'YTick',[]); set(gca,'YColor','w');
axes(handles.LickTraceAxes2); set(gca,'XTick',[]); set(gca,'XColor','w'); set(gca,'YTick',[]); set(gca,'YColor','w');
set(handles.LickThresholdTag,'String','0.1'); handles.LickThreshold = str2double(get(handles.LickThresholdTag,'String'));

%% Initialize text display
% set(handles.PerformanceText1Tag,'String',''); set(handles.PerformanceText1Tag,'Enable','off');
% set(handles.PerformanceText2Tag,'String',''); set(handles.PerformanceText2Tag,'Enable','off');
% set(handles.PerformanceText3Tag,'String',''); set(handles.PerformanceText3Tag,'Enable','off');
% set(handles.OnlineTextTag,'String',''); set(handles.OnlineTextTag,'Enable','off');
% set(handles.TrialTimeLineTextTag,'String',''); set(handles.TrialTimeLineTextTag,'Enable','off');

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

handles.MinQuietWindow = round(str2double(get(handles.MinQuietWindowTag,'String')));
set(handles.MinQuietWindowTag,'String',handles.MinQuietWindow);
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
handles.ResponseWindow = round(str2double(get(handles.ResponseWindowTag,'String')));
set(handles.ResponseWindowTag,'String',handles.ResponseWindow);


    time_limit = handles.BaselineWindow + handles.ResponseWindow;

if handles.TrialDuration < time_limit
    handles.TrialDuration = time_limit;
    set(handles.TrialDurationTag,'String',num2str(handles.TrialDuration));
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
handles.ArtifactWindow = round(str2double(get(handles.ArtifactWindowTag,'String')));
set(handles.ArtifactWindowTag,'String',handles.ArtifactWindow);

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
handles.MinISI = round(str2double(get(handles.MinISITag,'String')));
set(handles.MinISITag,'String',handles.MinISI);

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
handles.MaxISI = round(str2double(get(handles.MaxISITag,'String')));
set(handles.MaxISITag,'String',handles.MaxISI);

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



% --- Executes on button press in AssociationCheckbox.
function AssociationCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to AssociationCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AssociationCheckbox
global handles2give
handles.AssociationFlag = get(handles.AssociationCheckbox,'Value');

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
handles.EarlyLickPunishmentFlag = get(handles.EarlyLickPunishmentCheckbox,'Value');

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
handles.MouseName = get(handles.MouseNameTag,'String');

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
handles.BehaviorDirectory = get(handles.BehaviorDirectoryTag,'String');

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

handles.ToneDuration = round(str2double(get(handles.ToneDurationTag,'String')));
set(handles.ToneDurationTag,'String',num2str(handles.ToneDuration));

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


function NumStimTag_Callback(hObject, eventdata, handles)
% hObject    handle to NumStimTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumStimTag as text
%        str2double(get(hObject,'String')) returns contents of NumStimTag as a double
global handles2give

handles.NumStim = round(abs(str2double(get(handles.NumStimTag,'String'))));
if handles.NumStim > 6
    handles.NumStim = 6;
elseif handles.NumStim < 1
    handles.NumStim = 1;
end
set(handles.NumStimTag,'String',num2str(handles.NumStim));

switch handles.NumStim
    case 1
        % Stim 2
        set(handles.StimDuration2Tag,'Enable','off');
        set(handles.StimAmp2Tag,'Enable','off');
        set(handles.StimWeight2Tag,'Enable','off');
        % Stim 3
        set(handles.StimDuration3Tag,'Enable','off');
        set(handles.StimAmp3Tag,'Enable','off');
        set(handles.StimWeight3Tag,'Enable','off');
        % Stim 4
        set(handles.StimDuration4Tag,'Enable','off');
        set(handles.StimAmp4Tag,'Enable','off');
        set(handles.StimWeight4Tag,'Enable','off');
        % Stim 5
        set(handles.StimDuration5Tag,'Enable','off');
        set(handles.StimAmp5Tag,'Enable','off');
        set(handles.StimWeight5Tag,'Enable','off');
        % Stim 6
        set(handles.StimDuration6Tag,'Enable','off');
        set(handles.StimAmp6Tag,'Enable','off');
        set(handles.StimWeight6Tag,'Enable','off');
    case 2
        % Stim 2
        set(handles.StimDuration2Tag,'Enable','on');
        set(handles.StimAmp2Tag,'Enable','on');
        set(handles.StimWeight2Tag,'Enable','on');
        % Stim 3
        set(handles.StimDuration3Tag,'Enable','off');
        set(handles.StimAmp3Tag,'Enable','off');
        set(handles.StimWeight3Tag,'Enable','off');
        % Stim 4
        set(handles.StimDuration4Tag,'Enable','off');
        set(handles.StimAmp4Tag,'Enable','off');
        set(handles.StimWeight4Tag,'Enable','off');
        % Stim 5
        set(handles.StimDuration5Tag,'Enable','off');
        set(handles.StimAmp5Tag,'Enable','off');
        set(handles.StimWeight5Tag,'Enable','off');
        % Stim 6
        set(handles.StimDuration6Tag,'Enable','off');
        set(handles.StimAmp6Tag,'Enable','off');
        set(handles.StimWeight6Tag,'Enable','off');
    case 3
        % Stim 2
        set(handles.StimDuration2Tag,'Enable','on');
        set(handles.StimAmp2Tag,'Enable','on');
        set(handles.StimWeight2Tag,'Enable','on');
        % Stim 3
        set(handles.StimDuration3Tag,'Enable','on');
        set(handles.StimAmp3Tag,'Enable','on');
        set(handles.StimWeight3Tag,'Enable','on');
        % Stim 4
        set(handles.StimDuration4Tag,'Enable','off');
        set(handles.StimAmp4Tag,'Enable','off');
        set(handles.StimWeight4Tag,'Enable','off');
        % Stim 5
        set(handles.StimDuration5Tag,'Enable','off');
        set(handles.StimAmp5Tag,'Enable','off');
        set(handles.StimWeight5Tag,'Enable','off');
        % Stim 6
        set(handles.StimDuration6Tag,'Enable','off');
        set(handles.StimAmp6Tag,'Enable','off');
        set(handles.StimWeight6Tag,'Enable','off');
    case 4
        % Stim 2
        set(handles.StimDuration2Tag,'Enable','on');
        set(handles.StimAmp2Tag,'Enable','on');
        set(handles.StimWeight2Tag,'Enable','on');
        % Stim 3
        set(handles.StimDuration3Tag,'Enable','on');
        set(handles.StimAmp3Tag,'Enable','on');
        set(handles.StimWeight3Tag,'Enable','on');
        % Stim 4
        set(handles.StimDuration4Tag,'Enable','on');
        set(handles.StimAmp4Tag,'Enable','on');
        set(handles.StimWeight4Tag,'Enable','on');
        % Stim 5
        set(handles.StimDuration5Tag,'Enable','off');
        set(handles.StimAmp5Tag,'Enable','off');
        set(handles.StimWeight5Tag,'Enable','off');
        % Stim 6
        set(handles.StimDuration6Tag,'Enable','off');
        set(handles.StimAmp6Tag,'Enable','off');
        set(handles.StimWeight6Tag,'Enable','off');
    case 5
        % Stim 2
        set(handles.StimDuration2Tag,'Enable','on');
        set(handles.StimAmp2Tag,'Enable','on');
        set(handles.StimWeight2Tag,'Enable','on');
        % Stim 3
        set(handles.StimDuration3Tag,'Enable','on');
        set(handles.StimAmp3Tag,'Enable','on');
        set(handles.StimWeight3Tag,'Enable','on');
        % Stim 4
        set(handles.StimDuration4Tag,'Enable','on');
        set(handles.StimAmp4Tag,'Enable','on');
        set(handles.StimWeight4Tag,'Enable','on');
        % Stim 5
        set(handles.StimDuration5Tag,'Enable','on');
        set(handles.StimAmp5Tag,'Enable','on');
        set(handles.StimWeight5Tag,'Enable','on');
        % Stim 6
        set(handles.StimDuration6Tag,'Enable','off');
        set(handles.StimAmp6Tag,'Enable','off');
        set(handles.StimWeight6Tag,'Enable','off');
    case 6
        % Stim 2
        set(handles.StimDuration2Tag,'Enable','on');
        set(handles.StimAmp2Tag,'Enable','on');
        set(handles.StimWeight2Tag,'Enable','on');
        % Stim 3
        set(handles.StimDuration3Tag,'Enable','on');
        set(handles.StimAmp3Tag,'Enable','on');
        set(handles.StimWeight3Tag,'Enable','on');
        % Stim 4
        set(handles.StimDuration4Tag,'Enable','on');
        set(handles.StimAmp4Tag,'Enable','on');
        set(handles.StimWeight4Tag,'Enable','on');
        % Stim 5
        set(handles.StimDuration5Tag,'Enable','on');
        set(handles.StimAmp5Tag,'Enable','on');
        set(handles.StimWeight5Tag,'Enable','on');
        % Stim 6
        set(handles.StimDuration6Tag,'Enable','on');
        set(handles.StimAmp6Tag,'Enable','on');
        set(handles.StimWeight6Tag,'Enable','on');
end

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function NumStimTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumStimTag (see GCBO)
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

handles.StimDuration(1) = round(str2double(get(handles.StimDuration1Tag,'String'))*100)/100;
set(handles.StimDuration1Tag,'String',num2str(handles.StimDuration(1)));

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

handles.StimAmp(1) = round(str2double(get(handles.StimAmp1Tag,'String'))*100)/100;
set(handles.StimAmp1Tag,'String',num2str(handles.StimAmp(1)));

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

handles.StimWeight(1) = round(str2double(get(handles.StimWeight1Tag,'String')));
set(handles.StimWeight1Tag,'String',num2str(handles.StimWeight(1)));

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



function StimDuration2Tag_Callback(hObject, eventdata, handles)
% hObject    handle to StimDuration2Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StimDuration2Tag as text
%        str2double(get(hObject,'String')) returns contents of StimDuration2Tag as a double
global handles2give

handles.StimDuration(2) = round(str2double(get(handles.StimDuration2Tag,'String'))*100)/100;
set(handles.StimDuration2Tag,'String',num2str(handles.StimDuration(2)));

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function StimDuration2Tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StimDuration2Tag (see GCBO)
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

handles.StimAmp(2) = round(str2double(get(handles.StimAmp2Tag,'String'))*100)/100;
set(handles.StimAmp2Tag,'String',num2str(handles.StimAmp(2)));

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

handles.StimWeight(2) = round(str2double(get(handles.StimWeight2Tag,'String')));
set(handles.StimWeight2Tag,'String',num2str(handles.StimWeight(2)));

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



function StimDuration3Tag_Callback(hObject, eventdata, handles)
% hObject    handle to StimDuration3Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StimDuration3Tag as text
%        str2double(get(hObject,'String')) returns contents of StimDuration3Tag as a double
global handles2give

handles.StimDuration(3) = round(str2double(get(handles.StimDuration3Tag,'String'))*100)/100;
set(handles.StimDuration3Tag,'String',num2str(handles.StimDuration(3)));

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function StimDuration3Tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StimDuration3Tag (see GCBO)
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

handles.StimAmp(3) = round(str2double(get(handles.StimAmp3Tag,'String'))*100)/100;
set(handles.StimAmp3Tag,'String',num2str(handles.StimAmp(3)));

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

handles.StimWeight(3) = round(str2double(get(handles.StimWeight3Tag,'String')));
set(handles.StimWeight3Tag,'String',num2str(handles.StimWeight(3)));

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



function StimDuration4Tag_Callback(hObject, eventdata, handles)
% hObject    handle to StimDuration4Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StimDuration4Tag as text
%        str2double(get(hObject,'String')) returns contents of StimDuration4Tag as a double
global handles2give

handles.StimDuration(4) = round(str2double(get(handles.StimDuration4Tag,'String'))*100)/100;
set(handles.StimDuration4Tag,'String',num2str(handles.StimDuration(4)));

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function StimDuration4Tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StimDuration4Tag (see GCBO)
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

handles.StimAmp(4) = round(str2double(get(handles.StimAmp4Tag,'String'))*100)/100;
set(handles.StimAmp4Tag,'String',num2str(handles.StimAmp(4)));

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

handles.StimWeight(4) = round(str2double(get(handles.StimWeight4Tag,'String')));
set(handles.StimWeight4Tag,'String',num2str(handles.StimWeight(4)));

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



function StimDuration5Tag_Callback(hObject, eventdata, handles)
% hObject    handle to StimDuration5Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StimDuration5Tag as text
%        str2double(get(hObject,'String')) returns contents of StimDuration5Tag as a double
global handles2give

handles.StimDuration(5) = round(str2double(get(handles.StimDuration5Tag,'String'))*100)/100;
set(handles.StimDuration5Tag,'String',num2str(handles.StimDuration(5)));

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function StimDuration5Tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StimDuration5Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StimAmp5Tag_Callback(hObject, eventdata, handles)
% hObject    handle to StimAmp5Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StimAmp5Tag as text
%        str2double(get(hObject,'String')) returns contents of StimAmp5Tag as a double
global handles2give

handles.StimAmp(5) = round(str2double(get(handles.StimAmp5Tag,'String'))*100)/100;
set(handles.StimAmp5Tag,'String',num2str(handles.StimAmp(5)));

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function StimAmp5Tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StimAmp5Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StimWeight5Tag_Callback(hObject, eventdata, handles)
% hObject    handle to StimWeight5Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StimWeight5Tag as text
%        str2double(get(hObject,'String')) returns contents of StimWeight5Tag as a double
global handles2give

handles.StimWeight(5) = round(str2double(get(handles.StimWeight5Tag,'String')));
set(handles.StimWeight5Tag,'String',num2str(handles.StimWeight(5)));

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function StimWeight5Tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StimWeight5Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StimDuration6Tag_Callback(hObject, eventdata, handles)
% hObject    handle to StimDuration6Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StimDuration6Tag as text
%        str2double(get(hObject,'String')) returns contents of StimDuration6Tag as a double
global handles2give

handles.StimDuration(6) = round(str2double(get(handles.StimDuration6Tag,'String'))*100)/100;
set(handles.StimDuration6Tag,'String',num2str(handles.StimDuration(6)));

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function StimDuration6Tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StimDuration6Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function StimAmp6Tag_Callback(hObject, eventdata, handles)
% hObject    handle to StimAmp6Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StimAmp6Tag as text
%        str2double(get(hObject,'String')) returns contents of StimAmp6Tag as a double
global handles2give

handles.StimAmp(6) = round(str2double(get(handles.StimAmp6Tag,'String'))*100)/100;
set(handles.StimAmp6Tag,'String',num2str(handles.StimAmp(6)));

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function StimAmp6Tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StimAmp6Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function StimWeight6Tag_Callback(hObject, eventdata, handles)
% hObject    handle to StimWeight6Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StimWeight6Tag as text
%        str2double(get(hObject,'String')) returns contents of StimWeight6Tag as a double
global handles2give

handles.StimWeight(6) = round(str2double(get(handles.StimWeight6Tag,'String')));
set(handles.StimWeight6Tag,'String',num2str(handles.StimWeight(6)));

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function StimWeight6Tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StimWeight6Tag (see GCBO)
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


format shortg
c = clock;   % https://ch.mathworks.com/help/matlab/ref/clock.html
handles.FolderName=[num2str(c(4),'%02.f') num2str(c(5),'%02.f') num2str(round(c(6)),'%02.f')];
if ~exist([char(handles.BehaviorDirectory) '\' char(handles.MouseName)],'dir')
    mkdir(handles.BehaviorDirectory,handles.MouseName);
end
if ~exist([char(handles.BehaviorDirectory) '\' char(handles.MouseName) '\'  char(handles.MouseName) '_' char(handles.Date) '_' handles.FolderName],'dir')
    mkdir([char(handles.BehaviorDirectory) '\' char(handles.MouseName)],[char(handles.MouseName) '_' char(handles.Date) '_' handles.FolderName]);
end

cla(handles.ProgressBarAxes);
cla(handles.CameraAxes);
cla(handles.AudAxes);
cla(handles.WhAxes);
cla(handles.LightAxes);
cla(handles.PerformanceAxes);
cla(handles.LickTraceAxes);
cla(handles.LickTraceAxes2);
cla(handles.EarlyLickAxes);

set(handles2give.PerformanceText1Tag,'String',' ');
set(handles2give.PerformanceText2Tag,'String',' ');
set(handles2give.PerformanceText3Tag,'String',' ');
set(handles2give.OnlineTextTag,'String',' ');
set(handles2give.TrialTimeLineTextTag,'String',' ');

handles2give= handles;
DefiningSessions4Gui;

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in StopBehaviourTag.
function StopBehaviourTag_Callback(hObject, eventdata, handles)
% hObject    handle to StopBehaviourTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Stop_Sessions4Gui


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
% handles.NostimWeight = 1 - handles.StimProb;
% set(handles.NostimWeightTag,'String',handles.NostimWeight);

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

handles.NostimWeight = round(str2double(get(handles.NostimWeightTag,'String')));
set(handles.NostimWeightTag,'String',num2str(handles.NostimWeight));

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

handles.ToneAmp = round(str2double(get(handles.ToneAmpTag,'String'))*100)/100;
set(handles.ToneAmpTag,'String',num2str(handles.ToneAmp));

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

handles.ToneFreq = round(str2double(get(handles.ToneFreqTag,'String'))*100)/100;
set(handles.ToneFreqTag,'String',num2str(handles.ToneFreq));

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



% function NolightProbTag_Callback(hObject, eventdata, handles)
% % hObject    handle to NolightProbTag (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: get(hObject,'String') returns contents of NolightProbTag as text
% %        str2double(get(hObject,'String')) returns contents of NolightProbTag as a double
% 
% handles.NolightProb = 1-handles.LightProb;
% set(handles.NolightProbTag,'String',num2str(handles.NolightProb));
% 
% % Update handles structure
% guidata(hObject, handles);
% 
% 
% % --- Executes during object creation, after setting all properties.
% function NolightProbTag_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to NolightProbTag (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: edit controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end



function MaxTrialsInRowTag_Callback(hObject, eventdata, handles)
% hObject    handle to MaxTrialsInRowTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaxTrialsInRowTag as text
%        str2double(get(hObject,'String')) returns contents of MaxTrialsInRowTag as a double
global handles2give

handles.MaxTrialsInRow = round(abs(str2double(get(handles.MaxTrialsInRowTag,'String'))));
if handles.MaxTrialsInRow < 1
    handles.MaxTrialsInRow = 1;
end
set(handles.MaxTrialsInRowTag,'String',num2str(handles.MaxTrialsInRow));

% Update handles structure
handles2give= handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function MaxTrialsInRowTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxTrialsInRowTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in MaxTrialsInRowCheckbox.
function MaxTrialsInRowCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to MaxTrialsInRowCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of MaxTrialsInRowCheckbox
global handles2give

handles.MaxTrialsInRowFlag = get(handles.MaxTrialsInRowCheckbox,'Value');
if handles.MaxTrialsInRowFlag
    set(handles.MaxTrialsInRowTag,'Enable','on');
else
    set(handles.MaxTrialsInRowTag,'Enable','off');
end

% Update handles structure
handles2give= handles;
guidata(hObject, handles);



function ValveOpeningTag_Callback(hObject, eventdata, handles)
% hObject    handle to ValveOpeningTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ValveOpeningTag as text
%        str2double(get(hObject,'String')) returns contents of ValveOpeningTag as a double
global handles2give

handles.ValveOpening = round(str2double(get(handles.ValveOpeningTag,'String')));
set(handles.ValveOpeningTag,'String',num2str(handles.ValveOpening));

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

handles.RewardDelay = round(str2double(get(handles.RewardDelayTag,'String')));
set(handles.RewardDelayTag,'String',num2str(handles.RewardDelay));

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

handles.RewardDelayFlag = get(handles.RewardDelayCheckbox,'Value');
if handles.RewardDelayFlag
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

handles.LickThreshold = round(str2double(get(handles.LickThresholdTag,'String'))*1000)/1000;
set(handles.LickThresholdTag,'String',num2str(handles.LickThreshold));

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



function EarlyLickTimeOutTag_Callback(hObject, eventdata, handles)
% hObject    handle to EarlyLickTimeOutTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EarlyLickTimeOutTag as text
%        str2double(get(hObject,'String')) returns contents of EarlyLickTimeOutTag as a double
global handles2give

handles.EarlyLickTimeOut = round(str2double(get(handles.EarlyLickTimeOutTag,'String')));
set(handles.EarlyLickTimeOutTag,'String',num2str(handles.EarlyLickTimeOut));

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

handles.LastRecentTrials = round(abs(str2double(get(handles.LastRecentTrialsTag,'String'))));
if handles.LastRecentTrials < 1
    handles.LastRecentTrials = 1;
end
set(handles.LastRecentTrialsTag,'String',num2str(handles.LastRecentTrials));

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

handles.BehaviorDirectory=uigetdir;
set(handles.BehaviorDirectoryTag,'String',handles.BehaviorDirectory);

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
handles.BaselineWindow = round(str2double(get(handles.BaselineWindowTag,'String')));
set(handles.BaselineWindowTag,'String',handles.BaselineWindow);

time_limit = handles.BaselineWindow + handles.ResponseWindow;

if handles.TrialDuration < time_limit
    handles.TrialDuration = time_limit;
    set(handles.TrialDurationTag,'String',num2str(handles.TrialDuration));
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

handles.TrialDuration = round(str2double(get(handles.TrialDurationTag,'String')));
set(handles.TrialDurationTag,'String',num2str(handles.TrialDuration));

time_limit = handles.BaselineWindow + handles.ResponseWindow;

if handles.TrialDuration < time_limit
    handles.TrialDuration = time_limit;
    set(handles.TrialDurationTag,'String',num2str(handles.TrialDuration));
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

handles.CameraFrameRate = round(str2double(get(handles.CameraFrameRateTag,'String')));
set(handles.CameraFrameRateTag,'String',num2str(handles.CameraFrameRate));

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

handles.FalseAlarmPunishmentFlag = get(handles.FalseAlarmPunishmentCheckbox,'Value');

% Update handles structure
handles2give=handles;
guidata(hObject, handles);


% --- Executes on button press in ManualRewardButton.
function ManualRewardButton_Callback(hObject, eventdata, handles)
% hObject    handle to ManualRewardButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ManualRewardDelivery



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

handles.RewardProb = round(str2double(get(handles.RewardProbTag,'String'))*10)/10;
set(handles.RewardProbTag,'String',num2str(handles.RewardProb));

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

handles.PartialRewardFlag = get(handles.PartialRewardCheckbox,'Value');
if handles.PartialRewardFlag
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

handles.MaxQuietWindow = round(str2double(get(handles.MaxQuietWindowTag,'String')));
set(handles.MaxQuietWindowTag,'String',handles.MaxQuietWindow);
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

handles.AStimWeight = round(str2double(get(handles.AStimWeightTag,'String')));
set(handles.AStimWeightTag,'String',num2str(handles.AStimWeight));


if handles.AStimWeight > 0
    
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
handles.AudRew = get(handles.AudRewTag,'Value');
handles2give=handles;
guidata(hObject, handles)


% --- Executes on button press in WhRewTag.
function WhRewTag_Callback(hObject, eventdata, handles)
% hObject    handle to WhRewTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of WhRewTag
global handles2give
handles.wh_rew = get(handles.WhRewTag,'Value');
handles2give=handles;
guidata(hObject, handles)


% --- Executes on button press in CameraTagCheck.
function CameraTagCheck_Callback(hObject, eventdata, handles)
% hObject    handle to CameraTagCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CameraTagCheck
global handles2give
handles.CameraFlag= get(handles.CameraTagCheck,'Value');
handles2give=handles;
guidata(hObject, handles)


function LightDurationTag_Callback(hObject, eventdata, handles)
% hObject    handle to LightDurationTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LightDurationTag as text
%        str2double(get(hObject,'String')) returns contents of LightDurationTag as a double

global handles2give

handles.LightDuration = round(str2double(get(handles.LightDurationTag,'String')));
set(handles.LightDurationTag,'String',num2str(handles.LightDuration));

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

handles.LightPrestimDelay = round(str2double(get(handles.LightPrestimDelayTag,'String')));
set(handles.LightPrestimDelayTag,'String',num2str(handles.LightPrestimDelay));

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

handles.LightAmp = round(str2double(get(handles.LightAmpTag,'String'))*100)/100;
set(handles.LightAmpTag,'String',num2str(handles.LightAmp));

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

handles.LightFreq = round(str2double(get(handles.LightFreqTag,'String'))*100)/100;
set(handles.LightFreqTag,'String',num2str(handles.LightFreq));

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

handles.LightDuty = round(str2double(get(handles.LightDutyTag,'String'))*100)/100;
set(handles.LightDutyTag,'String',num2str(handles.LightDuty));

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



function LightProbAudTag_Callback(hObject, eventdata, handles)
% hObject    handle to LightProbAudTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LightProbAudTag as text
%        str2double(get(hObject,'String')) returns contents of LightProbAudTag as a double
global handles2give

handles.LightProbAud = round(str2double(get(handles.LightProbAudTag,'String'))*100)/100;
handles.LightProbAud
if handles.LightProbAud > 1
    handles.LightProbAud = 1;
elseif handles.LightProbAud < 0
    handles.LightProbAud = 0;
end
set(handles.LightProbAudTag,'String',handles.LightProbAud);
% handles.NolightProb = 1 - handles.LightProb;
% set(handles.NolightProbTag,'String',handles.NolightProb);

% Update handles structure
handles2give= handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function LightProbAudTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LightProbAudTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in OptoLightCheckbox.
function OptoLightCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to OptoLightCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OptoLightCheckbox

global handles2give

handles.LightFlag = get(handles.OptoLightCheckbox,'Value');
if handles.LightFlag
    set(handles.LightDurationTag,'Enable','on');
    set(handles.LightPrestimDelayTag,'Enable','on');
    set(handles.LightAmpTag,'Enable','on');
    set(handles.LightFreqTag,'Enable','on');
    set(handles.LightDutyTag,'Enable','on');
    set(handles.LightProbAudTag,'Enable','on');
    set(handles.LightProbWhTag,'Enable','on');
    set(handles.LightProbNoStimTag,'Enable','on');
else
    set(handles.LightDurationTag,'Enable','off');
    set(handles.LightPrestimDelayTag,'Enable','off');
    set(handles.LightAmpTag,'Enable','off');
    set(handles.LightFreqTag,'Enable','off');
    set(handles.LightDutyTag,'Enable','off');
    set(handles.LightProbAudTag,'Enable','off');
    set(handles.LightProbWhTag,'Enable','off');
    set(handles.LightProbNoStimTag,'Enable','off');
end

% Update handles structure
handles2give=handles;
guidata(hObject, handles);



function LightProbWhTag_Callback(hObject, eventdata, handles)
% hObject    handle to LightProbWhTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LightProbWhTag as text
%        str2double(get(hObject,'String')) returns contents of LightProbWhTag as a double

global handles2give

handles.LightProbWh = round(str2double(get(handles.LightProbWhTag,'String'))*100)/100;
if handles.LightProbWh > 1
    handles.LightProbWh = 1;
elseif handles.LightProbWh < 0
    handles.LightProbWh = 0;
end
set(handles.LightProbWhTag,'String',handles.LightProbWh);
% handles.NolightProb = 1 - handles.LightProb;
% set(handles.NolightProbTag,'String',handles.NolightProb);

% Update handles structure
handles2give= handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function LightProbWhTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LightProbWhTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function LightProbNoStimTag_Callback(hObject, eventdata, handles)
% hObject    handle to LightProbNoStimTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LightProbNoStimTag as text
%        str2double(get(hObject,'String')) returns contents of LightProbNoStimTag as a double
global handles2give

handles.LightProb = round(str2double(get(handles.LightProbNoStimTag,'String'))*100)/100;
if handles.LightProb > 1
    handles.LightProb = 1;
elseif handles.LightProb < 0
    handles.LightProb = 0;
end
handles.LightProb
set(handles.LightProbNoStimTag,'String',handles.LightProb);
% handles.NolightProb = 1 - handles.LightProb;
% set(handles.NolightProbTag,'String',handles.NolightProb);

% Update handles structure
handles2give= handles;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function LightProbNoStimTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LightProbNoStimTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
