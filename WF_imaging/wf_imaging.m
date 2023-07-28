function wf_imaging

    global WF_S Stim_S_SR handles2give trial_duration trial_number Cam_vec LED1_vec LED2_vec WF_FileInfo

    WF_FileInfo.CameraPathConfig         = '\\SV-07-091\Experiment\WideFieldImaging\config.txt';
    WF_FileInfo.CameraPathTemplateConfig = '\\SV-07-091\Experiment\WideFieldImaging\Template\config.txt';

    WF_FileInfo.n_frames_to_grab         = trial_duration*WF_FileInfo.CameraFrameRate/1000;

    date = datestr(datenum(num2str(handles2give.date, '%d'), 'yyyymmdd'), 'yyyy_mm_dd');
    time = [handles2give.session_time(1:2) 'h' handles2give.session_time(3:4)];        
    
    WF_FileInfo.savedir                    = [WF_FileInfo.CameraRoot handles2give.mouse_name '\' handles2give.date '\'...
                                             [char(handles2give.mouse_name) '_' char(date) '_' char(time) '\']];

    WF_FileInfo.file_name                  = [char(handles2give.mouse_name) '_' char(date) '_' char(time) '_trial' num2str(trial_number, '%04.0f')];

    if trial_number == 1
        
        DutyCycle=0.25;
        FrameRate= WF_FileInfo.CameraFrameRate; % frame rate

        t = 1/Stim_S_SR : 1/Stim_S_SR : ((trial_duration-2)/1000); % Time vector
        w = DutyCycle/FrameRate; % Pulse width
        d = w/2 : 1/FrameRate : (trial_duration/1000); % Delay vector
        Cam_pulses = pulstran(t,d,'rectpuls',w);

        Cam_vec = [zeros(1,(2)*Stim_S_SR/1000)...
            5*Cam_pulses ...
            zeros(1,(4)*Stim_S_SR/1000)]; %TTL trigger pulses of 5V

        if WF_FileInfo.LED488
            t = 1/Stim_S_SR : 1/Stim_S_SR : ((trial_duration-2)/1000); % Time vector
            w = 0.008; % Pulse width (s)
            d = w/2 : 1/(FrameRate/2) : (trial_duration/1000); % Delay vector
            LED1_pulses = pulstran(t,d,'rectpuls',w);
    
            LED1_vec = [zeros(1,(2)*Stim_S_SR/1000)...
                        5*LED1_pulses ...
                        5*ones(1,(4)*Stim_S_SR/1000)];
        else
            LED1_vec = zeros(1, length(Cam_vec));
        end

        if WF_FileInfo.LED405
            t = 1/Stim_S_SR : 1/Stim_S_SR : ((trial_duration-2-1000*1/WF_FileInfo.CameraFrameRate)/1000); % Time vector
            w = 0.008; % Pulse width (s)
            d = w/2 : 1/(FrameRate/2) : (trial_duration/1000); % Delay vector, shift LED2_vec by one frame
            LED2_pulses = pulstran(t,d,'rectpuls',w);
    
            LED2_vec = [zeros(1,(2+1000/FrameRate)*Stim_S_SR/1000)...
                        5*LED2_pulses ...
                        5*ones(1,((4*Stim_S_SR/1000)))]; %TTL trigger pulses of 5V
        else
            LED2_vec = zeros(1, length(Cam_vec));
        end
    
    end

    WriteConfigCtxCam(WF_FileInfo);
    
    WF_S.start()
    WF_S.write([Cam_vec; LED1_vec; LED2_vec;]')

    
end