function update_parameters

    global    Association ResponseWindow Trial_Duration Quietwindow Lick_Threshold...
        ArtifactWindow ITI CameraFlag Stim_NoStim Aud_NoAud Wh_NoWh Light_NoLight ...
        Cue RewardValue CueDuration  Aud_Rew Wh_Rew Wh_vec Aud_vec Light_vec Cue_vec ...
        Light_PreStim Cue_PreStim StimBoolian Punishment PLAYNOISE LickEarlyAlreadyDetected...
        TimeOutEarlyLick RewardSound_vec RewardSound Fs_Reward Stimcounter ...
        NoStimcounter Stim_S StimDuration  AStimDuration  AStimAmp  AStimFreq  Stim_S_SR ScansTobeAcquired ...
        Reward_S Reward_S_SR  Trigger_S fid3 AnimalLicked ReactionTime ...
        TrialStarted  trial_number LightProbOld folder_name handles2give StimPool...
        LightPool StimProbOld StimProbOldAud StimProbOldWh LightProbOldAud LightProbOldWh Light BaselineWindow Camera_vec...
        RewardShouldBeDelivered FalseAlarmPunishment EarlylickCounter CueProbOld...
        CuePool StimAmp Cue_NoCue ResponseWindowStart ResponseWindowEnd cameraClk...
        PerformanceAndSaveBoolian lh3 RewardDelivered UpdateParametersBoolean...
        Reward_NoReward RewardPool PartialReward RewardProbOld FA_Timeout LastTrialFA...
        StimIndexPool PoolSize Light_Duration Light_Freq Light_Amp Camera_freq SITrigger_vec Main_Pool TrialLickData...
        cameraStartTime

    outputSingleScan(Trigger_S,[0 0 0])
    pause(.5)
    outputSingleScan(Trigger_S,[0 0 0])

    % Light parameters
    ramp_down_duration=100; % in miliseconds
    Light_Amp = handles2give.LightAmp;
    Light_PreStim = handles2give.LightPrestimDelay;
    LightDurations=[Light_Amp]+ramp_down_duration;
    LightPreStims=[Light_PreStim];
    Light_Duration = handles2give.LightDuration;

    % Trial pool
    N_pool=10; % Making the Stim/NoStim, Light/NoLight, TrialStartCue/NoCue and Durations pool
    Block_Duration = 300; % in seconds (added for continuous filming)

    trial_number = trial_number+1;


    %% Update Video Parameters and Arm the Camera

    CameraFlag = handles2give.CameraFlag;

    % SAVING CAMERA FRAMES
    % if CameraFlag && (trial_number==1 || toc(cameraStartTime)>Block_Duration)
    if CameraFlag
        disp('ok')
        Camera_freq=handles2give.CameraFrameRate; % Hz

        VideoFileInfo.trial_number=trial_number;

        % TODO: remove hard coded basename
        VideoFileInfo.directory=['D:\AR\' char(handles2give.MouseName)...
            '\' [char(handles2give.MouseName) '_' char(handles2give.Date) '_' char(handles2give.FolderName) '\']];

        % Define number of frames to save in block
        VideoFileInfo.nOfFramesToGrab = Trial_Duration*Camera_freq/1000;

        save('D:\Behavior\TemplateConfigFile\VideoFileInfo','VideoFileInfo');
        ArmCameraNew()

    %     if trial_number~=1
    %         cameraClk.stop()
    %         pause(0.05)
    %         cameraClk.release()
    %     end
    %
    %     outputSingleScan(Trigger_S,[0 0 1])
    %     pause(5)
    %     outputSingleScan(Trigger_S,[0 0 0])
    %
    %     cameraClk.startBackground()
    %     pause(3)
    %     cameraStartTime=tic;


    % NOT SAVING CAMERA FRAMES
    % else
    %     outputSingleScan(Trigger_S,[0 0 0])
    end

    %% GENERAL SETTINGS

    FA_Timeout=10000; %in ms
    N_pool=10; % Making the wh_trials/AStim/NoStim and Durations pool

    % GET PARAMETERS FROM GUI
    Association=handles2give.AssociationFlag; % 0 detection 1 assosiation
    % Cue=handles2give.CueFlag;
    Light=handles2give.LightFlag;
    PLAYNOISE=handles2give.EarlyLickPunishmentFlag;
    % RewardSound=handles2give.RewardSoundFlag;
    % FalseAlarmPunishment=handles2give.FalseAlarmPunishmentFlag;
    % Camera settings
    Camera_freq=handles2give.CameraFrameRate; % Hz
    Camera_DutyCycle=0.5;
    Trial_Duration=handles2give.TrialDuration; % ms

    % Lick Sensor Sensitivity
    Lick_Threshold=handles2give.LickThreshold; %in volts

    % Trial Timeline Settings
    QuietwindowMin = handles2give.MinQuietWindow; % in miliseconds
    QuietwindowMax = handles2give.MaxQuietWindow; % in miliseconds
    Quietwindow=randsample(QuietwindowMin:.1:QuietwindowMax,1);

    % Quietwindow = handles2give.QuietWindow; % in miliseconds
    ResponseWindow=handles2give.ResponseWindow; % in miliseconds
    ArtifactWindow=handles2give.ArtifactWindow; % in miliseconds
    BaselineWindow=handles2give.BaselineWindow; % in miliseconds

    ITImin=handles2give.MinISI; % InterStimInterval in miliseconds (min)
    ITImax=handles2give.MaxISI; % InterStimInterval in miliseconds (max)

    % Limiting number of similar trials (stim/nostim) in raw
    LimitiTrialsinRow=handles2give.MaxTrialsInRowFlag; % 0 totaly random, 1 the limit will apply
    MaxNumRepetition=handles2give.MaxTrialsInRow;

    TimeOutEarlyLick=handles2give.EarlyLickTimeOut; % in milliseconds in case of early lick

    % Whisker and Auditory Stim parameters
    StimAmps= handles2give.StimAmp(1:handles2give.NumStim); % in volts
    Stim_Weights= handles2give.StimWeight(1:handles2give.NumStim);
    Astim_Amp =  handles2give.ToneAmp;
    Astim_Dur = handles2give.ToneDuration;
    Astim_Freq = handles2give.ToneFreq;
    AStim_Weight = handles2give.AStimWeight;
    WhStim_Weight = handles2give.StimWeight(1);
    AStimDuration = Astim_Dur;
    AStimAmp = Astim_Amp;
    AStimFreq = Astim_Freq;
    Nostim_Weight=handles2give.NostimWeight;
    StimDurations= handles2give.StimDuration(1:handles2give.NumStim);  % in miliseconds

    % Stim_Probability=handles2give.StimProb; % proportion of stimulus trials
    % if trial_number == 1
    %     StimProbOld = Stim_Probability;
    % end

    %% Compute stimulus probability
    Stim_Probability = (AStim_Weight + WhStim_Weight)/(AStim_Weight + WhStim_Weight + Nostim_Weight);
    if trial_number == 1
        StimProbOld = Stim_Probability;
    end

    Stim_Probability_Aud = (AStim_Weight)/(AStim_Weight + WhStim_Weight + Nostim_Weight);
    if trial_number == 1
        StimProbOldAud = Stim_Probability_Aud;
    end

    Stim_Probability_Wh = (WhStim_Weight)/(AStim_Weight + WhStim_Weight + Nostim_Weight);
    if trial_number == 1
        StimProbOldWh = Stim_Probability_Wh;
    end


    %% Light probability and light parameters
    Light_Probability=handles2give.LightProb; % proportion of light trials
    if isempty(LightProbOld)
        LightProbOld = Light_Probability;
    end

    Light_Probability_Aud=handles2give.LightProbAud; % proportion of light trials
    if isempty(LightProbOldAud)
        LightProbOldAud = Light_Probability_Aud;
    end
    Light_Probability_Wh=handles2give.LightProbWh; % proportion of light trials
    if isempty(LightProbOldWh)
        LightProbOldWh = Light_Probability_Wh;
    end

    Light_Shape='rect'; % "rect" or "sin" %%% for now only use 'rect'
    Light_Amp=handles2give.LightAmp;
    Light_Freq=handles2give.LightFreq; % frequency of the pulse train
    Light_Duty=handles2give.LightDuty; % duty cycle (0-1)


    if trial_number>1
        Results=importdata([folder_name '\Results.txt']);
        NCompletedTrials=sum(Results.data(:,10)~=6);
    else
        NCompletedTrials=1;
    end

    % Size of pool (i.e. trial block) to get trials from
    Hlaf_Main_Pool_Size=80;

    Stim_Light=[900,901,902,903,904,905]; % code for each stimuli

    LightProbOldAud =Light_Probability_Aud;
    LightProbOld =Light_Probability;
    LightProbOldWh = Light_Probability_Wh;

    StimProbOldAud = Stim_Probability_Aud;
    StimProbOldWh = Stim_Probability_Wh;

    % CREATE NEW TRIAL POOL WHEN CURRENT POOL FINISHED

    if mod(NCompletedTrials, Hlaf_Main_Pool_Size)==1 || LightProbOld ~= Light_Probability || LightProbOldAud ~= Light_Probability_Aud ||  LightProbOldWh ~= Light_Probability_Wh ||StimProbOld ~= Stim_Probability || StimProbOldAud ~= Stim_Probability_Aud|| StimProbOldWh ~= Stim_Probability_Wh
        % Stim. probability and trial pool when light stimulus
        if Light

            NoStimLightProb =(1-Stim_Probability)*Light_Probability;
            NoStimNoLightProb = (1-Stim_Probability)*(1-Light_Probability);
            StimNoLight = Stim_Probability*(1-Light_Probability);
            AudStimLight = Stim_Probability_Aud*Light_Probability_Aud;
            AudStimNoLight = Stim_Probability_Aud*(1-Light_Probability_Aud);
            WhStimLight = Stim_Probability_Wh*Light_Probability_Wh;
            WhStimNoLight = Stim_Probability_Wh*(1-Light_Probability_Wh);

            Main_Pool=[Stim_Light(1)*ones(1,round(round(NoStimNoLightProb*Hlaf_Main_Pool_Size*100))/100) ,...
                Stim_Light(2)*ones(1,round(round(AudStimNoLight*Hlaf_Main_Pool_Size*100)/100)) ,...
                Stim_Light(3)*ones(1,round(round(WhStimNoLight*Hlaf_Main_Pool_Size*100)/100)) ,...
                Stim_Light(4)*ones(1,round(round(NoStimLightProb*Hlaf_Main_Pool_Size*100)/100)) ,...
                Stim_Light(5)*ones(1,round(round(AudStimLight*Hlaf_Main_Pool_Size*100)/100)) ,...
                Stim_Light(6)*ones(1,round(round(WhStimLight*Hlaf_Main_Pool_Size*100)/100)) ,...
                ];

        % Stim. probability and trial pool when no light stimulus
        else
            Main_Pool=[Stim_Light(1)*ones(1,round(round(((1-Stim_Probability)*Hlaf_Main_Pool_Size)*100)/100)) ,...
                Stim_Light(2)*ones(1,round(round(Stim_Probability_Aud*Hlaf_Main_Pool_Size*100)/100)),...
                Stim_Light(3)*ones(1,round(round(Stim_Probability_Wh*Hlaf_Main_Pool_Size*100)/100)),...
                ];
        end

        %Randomize occurence of pool trials
        Main_Pool=Main_Pool(randperm(numel(Main_Pool)));

    end

    % Create auditory detection block
    Block_Size = 30;
    Block_Probability=0.5;
    Auditory_Block = [Stim_Light(1)*ones(1,round(round(((1-Block_Probability)*Block_Size)*100)/100)) ,...
            Stim_Light(2)*ones(1,round(round(Block_Probability*Block_Size*100)/100))];
    Auditory_Block = Auditory_Block(randperm(numel(Auditory_Block)));

    % % Select next trial from pool
    % if trial_number < Block_Size
    %     Trial_Type = Auditory_Block(mod(NCompletedTrials,Hlaf_Main_Pool_Size)+1); % select from auditory detection block first
    % else
    %     Trial_Type = Main_Pool(mod(NCompletedTrials,Hlaf_Main_Pool_Size)+1); %0 noLight 1 Light
    % end

    Trial_Type = Main_Pool(mod(NCompletedTrials,Hlaf_Main_Pool_Size)+1); %0 noLight 1 Light

    switch Trial_Type
        case Stim_Light(1) % CATCH TRIAL
            Stim_NoStim=0;
            Light_NoLight=0;
            Aud_NoAud = 0;
            Wh_NoWh =0;
        case Stim_Light(2) % AUDITORY TRIAL
            Stim_NoStim=1;
            Light_NoLight=0;
            Aud_NoAud = 1;
            Wh_NoWh =0;
        case Stim_Light(3) % WHISKER TRIAL
            Stim_NoStim=1;
            Light_NoLight=0;
            Aud_NoAud = 0;
            Wh_NoWh =1;
        case Stim_Light(4) % LIGHT ONLY TRIAL
            Stim_NoStim=0;
            Light_NoLight=1;
            Aud_NoAud = 0;
            Wh_NoWh =0;
        case Stim_Light(5) % LIGHT AUDITORY TRIAL
            Stim_NoStim=1;
            Light_NoLight=1;
            Aud_NoAud = 1;
            Wh_NoWh =0;
        case Stim_Light(6)  % LIGHT WHISKER TRIAL
            Stim_NoStim=1;
            Light_NoLight=1;
            Aud_NoAud = 0;
            Wh_NoWh =1;
    end

    % Set light parameters to zero if not a light trial
    if ~Light_NoLight || ~Light
        Light_NoLight=0;
        Light_PreStim=0;
        Light_Amp=0;
        Light_Duration=0;
        Light_Freq=0;
    end

    %% Reward Settings
    RewardValue=handles2give.ValveOpening; % duration valve open in milliseconds
    DelayedReward=handles2give.RewardDelay;% delay in milisecond for delivering reward after stim (if Association=1)
    PartialReward=handles2give.PartialRewardFlag;
    Aud_Rew = handles2give.AudRew;
    Wh_Rew = handles2give.wh_rew;

    if PartialReward
        Reward_Probability=handles2give.RewardProb; % proportion of rewarded hits
        if isempty('RewardProbOld')
            RewardProbOld = Reward_Probability;
        end
        if mod(trial_number,N_pool)==1 || RewardProbOld ~= Reward_Probability
            RewardProbOld = Reward_Probability;
            RewardPool=[zeros(1,round((1-Reward_Probability)*N_pool)) ones(1,round(Reward_Probability*N_pool))]; % zero for no stim, one for Reward
            RewardPool=RewardPool(randperm(numel(RewardPool)));
        end
        Reward_NoReward=RewardPool(mod(trial_number,N_pool)+1); % select the next trial from the pool,  0 noReward 1 Reward
    else
        Reward_NoReward=1;
    end

    DelayedReward=0;

    % Define reward vector
    Reward_vec=[zeros(1,DelayedReward) 5*ones(1,RewardValue*Reward_S_SR/1000) zeros(1,Reward_S_SR/2)];
    if ~Reward_NoReward
        Reward_vec=zeros(1,numel(Reward_vec));
    end

    %% Performance Measures
    perf_win_size=handles2give.LastRecentTrials;

    % Inter trial interval
    if ITImin>ITImax
        set(handles2give.OnlineTextTag,'String','ITImin should be smaller than ITImax');
    elseif ITImin==ITImax
        ITI=ITImin;
    else
        ITI=randsample(ITImin:.1:ITImax,1);
    end

    if LastTrialFA
        ITI=ITI+FA_Timeout;
    end

    %% Get trial duration
    Trial_Duration = max(Trial_Duration, (Light_PreStim + ArtifactWindow+BaselineWindow + max(ResponseWindow,(Light_Duration-Light_PreStim))) /1000);

    %% Stimuli
    N_stimpool=2;
    if  trial_number==1
        PoolSize=1;
    end

    if trial_number==1 || mod(trial_number,PoolSize)==1
        StimIndexPool=[];
        for i=1:handles2give.NumStim %Different whisker stimuli
            StimIndexPool=[StimIndexPool i*ones(1,Stim_Weights(i)*N_stimpool)];
        end

        StimIndexPool=[zeros(1,Nostim_Weight*N_stimpool) StimIndexPool 7*ones(1,AStim_Weight*N_stimpool)];
        PoolSize=numel(StimIndexPool); %number of elements in array
        StimPool=randsample(StimIndexPool,PoolSize); %random sampling without replacement: shuffling
    end

    if mod(trial_number,PoolSize)>0
        StimIndex=StimPool(mod(trial_number,PoolSize));
    else
        StimIndex=StimPool(end);
    end

    % if ~StimIndex
    %     Stim_NoStim=0;
    %     Aud_NoAud = 0;
    %     Wh_NoWh = 0;
    % else
    %     if StimIndex == 7
    %     Stim_NoStim=1;
    %     Aud_NoAud = 1;
    %     Wh_NoWh = 0;
    %     else
    %     Stim_NoStim=1;
    %     Aud_NoAud = 0;
    %     Wh_NoWh = 1;
    %     end
    % end
    %
    % Stim_NoStim


    %% Limit Stim/NoStim Trials in a row
    if Stim_NoStim==1 && LimitiTrialsinRow==1 %applies if 1
        Stimcounter=Stimcounter+1;
    elseif Stim_NoStim==0 && LimitiTrialsinRow==1
        NoStimcounter=NoStimcounter+1;
    end

    if Stimcounter>MaxNumRepetition
        Stim_NoStim=1-Stim_NoStim;
        Stimcounter=0;
        NoStimcounter=1;
    elseif NoStimcounter>MaxNumRepetition
        Stim_NoStim=1-Stim_NoStim;

        if Aud_Weight
            StimIndex=randsample([1:length(Stim_Weights),7],1); %??what's 7??
        else
            StimIndex=randsample(1:length(Stim_Weights),1);
        end
        %
        NoStimcounter=0;
        Stimcounter=1;
    end

    %% Define stimulus parameters and vectors
    % Catch trials, set stimulus vectors to 0
    if ~Stim_NoStim
        AStimDuration = 0;
        AStimAmp = 0;
        AStimFreq = 0;
        StimDuration = 0;
        StimAmp = 0;
        Wh_vec = zeros(1,(Trial_Duration)*(Stim_S_SR/1000));
        Aud_vec = zeros(1,(Trial_Duration)*(Stim_S_SR/1000));

    % Stimulus trial
    else
        % AUDITORY STIMULUS SELECTED - PARAMETERS
        if Aud_NoAud

            AStimDuration = Astim_Dur;
            AStimAmp = Astim_Amp;
            AStimFreq = Astim_Freq;
            StimDuration = 0;
            StimAmp=0;

        % WHISKER STIMULUS SELECTED - PARAMETERS
        else

            AStimDuration = 0;
            AStimAmp = 0;
            AStimFreq = 0;

            StimDuration=StimDurations(1);
            StimAmp=StimAmps(1);

            % CALIBRATE WHISKER STIMULUS SHAPE BASED ON GUI AMPLITUDE PARAM
                switch StimAmp
                    case 0.5
                        ScaleFactor=1.1;
                        StimDurationRise = StimDuration*Stim_S_SR/2000;
                        StimDurationDecrease = StimDuration*Stim_S_SR/2000;

                    case 1
                        ScaleFactor=1.15;
                        StimDurationRise = StimDuration*Stim_S_SR/2000;
                        StimDurationDecrease = StimDuration*Stim_S_SR/2000;
                    case 1.6
                        ScaleFactor=1.16;
                        StimDurationRise = StimDuration*Stim_S_SR/2000;
                        StimDurationDecrease = StimDuration*Stim_S_SR/2000;
                    case 1.8
                        ScaleFactor=1.165;
                        StimDurationRise = StimDuration*Stim_S_SR/2000;
                        StimDurationDecrease = StimDuration*Stim_S_SR/2000;
                    case 2.2
                        ScaleFactor=1.165;
                        StimDurationRise = StimDuration*Stim_S_SR/2000;
                        StimDurationDecrease = StimDuration*Stim_S_SR/2000;
                    case 2.6
                        ScaleFactor=1.167;
                        StimDurationRise = StimDuration*Stim_S_SR/2000;
                        StimDurationDecrease = StimDuration*Stim_S_SR/2000;
                    case 2.8
                        ScaleFactor=1.167;
                        StimDurationRise = StimDuration*Stim_S_SR/2000;
                        StimDurationDecrease = StimDuration*Stim_S_SR/2000;
                    case 3
                        ScaleFactor=1.17;
                        StimDurationRise = StimDuration*Stim_S_SR/2000;
                        StimDurationDecrease = StimDuration*Stim_S_SR/2000;
                    case 3.4
                        ScaleFactor=1.19;
                        StimDurationRise = StimDuration*Stim_S_SR/2000;
                        StimDurationDecrease = StimDuration*Stim_S_SR/2000;
                    case 4
                        ScaleFactor=0.75;
                        StimDurationRise = StimDuration*Stim_S_SR/2000+1;
                        StimDurationDecrease = StimDuration*Stim_S_SR/2000;
                    case 4.2
                        ScaleFactor=1;
                        StimDurationRise = StimDuration*Stim_S_SR/2000+1;
                        StimDurationDecrease = StimDuration*Stim_S_SR/2000;
                    case 5
                        ScaleFactor=0.9;
                        StimDurationRise = StimDuration*Stim_S_SR/2000+6;
                        StimDurationDecrease = StimDuration*Stim_S_SR/2000+1;
                    otherwise
                        ScaleFactor=0.9;
                        StimDurationRise = StimDuration*Stim_S_SR/2000+15;
                        StimDurationDecrease = StimDuration*Stim_S_SR/2000+1;
                end
        end

        % AUDITORY STIMULUS SELECTED - DEFINE VECTOR
        if Aud_NoAud

            Aud_vec = AStimAmp*[zeros(1,(BaselineWindow)*Stim_S_SR/1000)...
                sin(linspace(0, AStimDuration* AStimFreq*2*pi/1000, round(AStimDuration*Stim_S_SR/1000))) 0];

            Aud_vec=[Aud_vec zeros(1,Trial_Duration*Stim_S_SR/1000-length(Aud_vec))];

            Wh_vec=zeros(1,(Trial_Duration)*(Stim_S_SR/1000));

        % WHISKER STIMULUS SELECTED - DEFINE VECTOR
        else
            % Biphasic stimulus
            stim_amp = 2.3;
            stim_duration_up = 1.5;
            stim_duration_down = 1.5;
            scale_factor = .6;

            stim_duration_up = stim_duration_up*Stim_S_SR/1000;
            stim_duration_down = stim_duration_down*Stim_S_SR/1000;

            impulse_up = tukeywin(stim_duration_up,1);
            impulse_up = impulse_up(1:end-1);
            impulse_down = -tukeywin(stim_duration_down,1);
            impulse_down = impulse_down(2:end);
            impulse = [impulse_up' scale_factor*impulse_down'];

            Wh_vec = stim_amp * [zeros(1,BaselineWindow*Stim_S_SR/1000) impulse];
            Wh_vec = [Wh_vec zeros(1,Trial_Duration*Stim_S_SR/1000 - numel(Wh_vec))];

    %         Wh_vec=StimAmp*[zeros(1,(BaselineWindow)*Stim_S_SR/1000)...
    %                 ones(1,StimDurationRise) -ones(1,StimDurationDecrease)/ScaleFactor]; % biphasic stim
        % Monophasic stimulus
    %         Wh_vec=StimAmp*[zeros(1,(BaselineWindow)*Stim_S_SR/1000)...
    %                 ones(1,2*StimDurationRise)]; % monophasic stim
    %       % Raised cosine biphasic stimulus
    %         cos_frac = 0.6; % Two-sided fraction of rectangle replaced by cosine
    %         Whisk_rise = tukeywin(StimDurationRise, cos_frac);
    %         Whisk_decrease = -tukeywin(StimDurationDecrease, cos_frac);
    %         disp(size(zeros(1,(BaselineWindow)*Stim_S_SR/1000)));
    %         disp(size(transpose(Whisk_rise)));
    %         disp(size(transpose(Whisk_decrease)));
    %         Wh_vec=StimAmp*[zeros(1,(BaselineWindow)*Stim_S_SR/1000)...
    %                 transpose(Whisk_rise) transpose(Whisk_decrease)/ScaleFactor];

                % When there is light
                % Wh_vec=StimAmp*[zeros(1,(BaselineWindow+max(Cue_PreStim,Light_PreStim))*Stim_S_SR/1000)...
                % ones(1,StimDuration*Stim_S_SR/1000)];


            %%% added from Vahid's code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Piezo stimulus vector
    %         StimDuration=StimDurations(1);
    %         StimAmp=StimAmps(1);
    %         StimFreq=100; % whisker stimulus frequency

    %         Wh_vec=[zeros(1,(BaselineWindow)*Stim_S_SR/1000)...
    %             StimAmp/2+StimAmp/2*cos(2*pi*StimFreq*(0:1/Stim_S_SR:StimDuration/1000)-pi)];
    %         Wh_vec=[Wh_vec zeros(1,(10000)*(Stim_S_SR/1000)) Wh_vec]; % to be removed later

    %         Wh_vec=[Wh_vec zeros(1,(Trial_Duration)*(Stim_S_SR/1000)-numel(Wh_vec))];
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            Aud_vec=zeros(1,(Trial_Duration)*(Stim_S_SR/1000));

        end

    end

    % if mod(trial_number,N_pool)==1
    % %     StimProbOld = Stim_Probability;
    %     StimPool=[zeros(1,round((1-Stim_Probability)*N_pool)) ones(1,round(Stim_Probability*N_pool))]; % zero for no stim, one for stim
    %     StimPool=StimPool(randperm(numel(StimPool)));
    % end
    % Stim_NoStim=StimPool(mod(trial_number,N_pool)+1); % select the next trial from the pool, 0 noStim 1 Stim



    %% Making Cue
    % toneFreq = 10000;  %# Tone frequency, in Hertz
    % Cue_Amp=.1;
    %
    % if Cue_NoCue
    %     Cue_vec = Cue_Amp*[zeros(1,BaselineWindow*Stim_S_SR/1000) zeros(1,(Light_PreStim-Cue_PreStim)*Stim_S_SR/1000)...
    %         sin(linspace(0, CueDuration*toneFreq*2*pi/1000, round(CueDuration*Stim_S_SR/1000)))...
    %         zeros(1,((Cue_PreStim-CueDuration+max(StimDuration,Light_Duration-Light_PreStim))*Stim_S_SR/1000)) 0]  ;
    %     Cue_vec=[Cue_vec zeros(1,Trial_Duration*Stim_S_SR/1000-length(Cue_vec))];
    % else
    %     Cue_vec=zeros(1,numel(Wh_vec));
    % end

    %% Light - opto define vector
    if Light_NoLight

        disp(['Light' num2str(Light_NoLight)])
        t = 1/Stim_S_SR : 1/Stim_S_SR : (Light_Duration/1000);
        %     w=Light_Duty/Light_Freq;
        %     d = w/2 : 1/Light_Freq : (Light_Duration/1000);
        %     switch Light_Shape
        %         case 'rect'
        %             Light_PulsTrain=pulstran(t,d,'rectpuls',w);
        %
        %         case 'gaus'
        %             Light_PulsTrain=pulstran(t,d,'gauspuls');
        %         case 'tri'
        %             Light_PulsTrain=pulstran(t,d,'tripuls');
        %     end
        Light_PulsTrain=[ones(1,round(Stim_S_SR*(Light_Duty/Light_Freq))) zeros(1,round(Stim_S_SR*((1-Light_Duty)/Light_Freq)))];
        Light_PulsTrain=repmat(Light_PulsTrain,1,Light_Duration*Light_Freq/1000);

        switch Light_Shape
            case 'sin'
                Light_vec=Light_Amp/2+Light_Amp/2*[-ones(1,BaselineWindow*Stim_S_SR/1000) -ones(1,(Light_PreStim)*Stim_S_SR/1000) -cos(2*pi*Light_Freq*t)];
                Light_vec=[Light_vec zeros(1,(Trial_Duration)*(Stim_S_SR/1000)-numel(Light_vec))];

                Light_vec_shadow= [zeros(1,BaselineWindow*Stim_S_SR/1000) zeros(1,(Light_PreStim)*Stim_S_SR/1000) [ones(1,1*length(Light_PulsTrain)-ramp_down_duration*Stim_S_SR/1000) fliplr(linspace(0,1,ramp_down_duration*Stim_S_SR/1000))]];
                Light_vec_shadow =[Light_vec_shadow zeros(1,(Trial_Duration)*(Stim_S_SR/1000)-numel(Light_vec_shadow))];

                Light_vec=Light_vec.*Light_vec_shadow;

            otherwise
                Light_vec=Light_Amp*[(zeros(1,(BaselineWindow - Light_PreStim)*Stim_S_SR/1000)) Light_PulsTrain];
                Light_vec=[Light_vec zeros(1,(Trial_Duration)*(Stim_S_SR/1000)-numel(Light_vec))];
                %
                Light_vec_shadow= [zeros(1,(BaselineWindow-Light_PreStim)*Stim_S_SR/1000) [ones(1,1*length(Light_PulsTrain)-ramp_down_duration*Stim_S_SR/1000) fliplr(linspace(0,1,ramp_down_duration*Stim_S_SR/1000))]];
                Light_vec_shadow =[Light_vec_shadow zeros(1,(Trial_Duration)*(Stim_S_SR/1000)-numel(Light_vec_shadow))];

                Light_vec=Light_vec.*Light_vec_shadow;

        end

    else
        Light_vec=zeros(1,(Trial_Duration)*(Stim_S_SR/1000));
    end

    %% Making Pulse train to Trigger_S Camera
    Camera_vec = [ones(1, Stim_S_SR*(Camera_DutyCycle/Camera_freq)) zeros(1,Stim_S_SR*((1-Camera_DutyCycle)/Camera_freq))];
    Camera_vec = repmat(Camera_vec, 1, Trial_Duration*Camera_freq/1000);


    %% Plotting the Whisker/Auditory Stim and Camera Signals
    timevec=linspace(0, Trial_Duration/1000,(Trial_Duration)*Stim_S_SR/1000);

    TrialTime=max(timevec);

    plot(handles2give.CameraAxes,timevec(1:10:end),Camera_vec(1:10:end),'k')
    set(handles2give.CameraAxes,'XTick',[])
    xlim(handles2give.CameraAxes,[0 TrialTime])
    ylabel(handles2give.CameraAxes,'Camera')
    % ylim(handles2give.CameraAxes,[-Cue_Amp Cue_Amp])

    % plot(handles2give.CueAxes,timevec(1:10:end),Cue_vec(1:10:end),'k')
    % set(handles2give.CueAxes,'XTick',[])
    % xlim(handles2give.CueAxes,[0 TrialTime])
    % ylabel(handles2give.CueAxes,'Cue')
    % ylim(handles2give.CueAxes,[-Cue_Amp Cue_Amp])

    plot(handles2give.AudAxes,timevec(1:1:end),Aud_vec(1:1:end),'Color', 'b')
    set(handles2give.AudAxes,'XTick',[])
    xlim(handles2give.AudAxes,[0 TrialTime])
    ylabel(handles2give.AudAxes,'AStim')
    ylim(handles2give.AudAxes,[-10 10])

    plot(handles2give.WhAxes,timevec(1:10:end),Wh_vec(1:10:end),'Color', 'gr')
    xlim(handles2give.WhAxes,[0 TrialTime])
    xlabel(handles2give.WhAxes,'time(s)')
    ylabel(handles2give.WhAxes,'WStim')
    ylim(handles2give.WhAxes,[-5 5])

    % plot(handles2give.LightAxes,timevec(1:10:end),Light_vec(1:10:end),'b')
    % set(handles2give.LightAxes,'XTick',[])
    % xlim(handles2give.LightAxes,[0 TrialTime])
    % ylabel(handles2give.LightAxes,'Light')

    %% Creating Punishment and reward sounds
    % Punishment = 4*wgn(5000,1,0);

    RewardSound_Amp=5;
    RewardSound_Duration=10*RewardValue/1000;
    Fs_Reward=200000;
    Reward_part=RewardSound_Amp*ones(1,round(RewardSound_Duration*Fs_Reward/10));
    RewardSound_vec=[Reward_part zeros(1,length(Reward_part))...
        Reward_part zeros(1,length(Reward_part))...
        Reward_part zeros(1,length(Reward_part))...
        Reward_part zeros(1,length(Reward_part))...
        Reward_part zeros(1,length(Reward_part))];



    %% Online performance for plotting
    if trial_number>1
        % Load Results data
        %EarlyLicks=importdata([folder_name '\EarlyLicks.txt']);
        Results=importdata([folder_name '\Results.txt']);

        perf = Results.data(Results.data(:,10) ~= 6,10);
        aud_trials = Results.data(Results.data(:,10) ~= 6,8);
        wh_trials = Results.data(Results.data(:,10) ~= 6,7);
        stim_trials = Results.data(Results.data(:,10) ~= 6,6);
        LightP = Results.data(Results.data(:,10) ~= 6,11);

        % Compute performance and metrics
        WHitRate=round(sum(perf==2)/sum(wh_trials==1)*100)/100;
        AHitRate=round(sum(perf==3)/sum(aud_trials==1)*100)/100;
        FalseAlarm=round(sum(perf==5)/sum(stim_trials==0)*100)/100;
        StimTrial_num=sum(stim_trials==1);
        LA= sum((aud_trials==1).*(LightP == 1));
        LW = sum((wh_trials==1).*(LightP == 1));
        LStim = sum((stim_trials==1).*(LightP == 1));
        LNoStim = sum((stim_trials==0).*(LightP == 1));
        LAH = round(sum((perf==3).*(LightP == 1))/LA*100)/100;
        LWH = round(sum((perf==2).*(LightP == 1))/LW*100)/100;
        WStim = sum(wh_trials==1);
        AStim = sum(aud_trials==1);

        % Display trial counts on GUI (no light)
        set(handles2give.PerformanceText1Tag,'String',['AH =' num2str(AHitRate) '  WH=' num2str(WHitRate)...
            '  FA=' num2str(FalseAlarm) '  Stim='  num2str(StimTrial_num) '  WS=' num2str(WStim) '  AS=' num2str(AStim)  '  EL='  num2str(EarlylickCounter) ]);
        set(handles2give.PerformanceText1Tag, 'FontWeight', 'Bold');

    %     % Display trial counts on GUI (light)
    %     set(handles2give.PerformanceText2Tag,'String',['LAH =' num2str(LAH) '  LWH=' num2str(LWH)...
    %         '  LStim='  num2str(LStim) '  LNoStim=' num2str(LNoStim) '  LA=' num2str(LA)  '  LW='  num2str(LW) ]);
    %     set(handles2give.PerformanceText2Tag, 'FontWeight', 'Bold');

        % Make performance plot
        plot_performance(Results, perf_win_size);
    end

    %% Checking if Pause is requested (???)


    %% Printing out the next trial specs
    TrialTitles={'NoStim',['WS Amp=' num2str(StimAmp) ', ''WS Dur=' num2str(StimDuration)],['AS Amp=' num2str(AStimAmp) ', ' 'AS Dur=' num2str(AStimDuration) ', '...
        'AS Freq=' num2str(AStimFreq)]};
    RewardTitles={'Not Rewarded','Rewarded'};
    LightTitles={'Light:Off','Light:On'};
    AssociationTitles={'','Association'};


    if Stim_NoStim

        if Aud_NoAud

            set(handles2give.TrialTimeLineTextTag,'String',['Next Trial:   "' char(TrialTitles(Stim_NoStim+2)) '" '...
                char(AssociationTitles(Association+1)) '     ' char(RewardTitles(Aud_Rew+1)) '       ' char(LightTitles(Light_NoLight+1))],'ForegroundColor','b');

        else

            set(handles2give.TrialTimeLineTextTag,'String',['Next Trial:   "' char(TrialTitles(Stim_NoStim+1)) '" '...
                char(AssociationTitles(Association+1)) '     ' char(RewardTitles(Wh_Rew+1)) '       ' char(LightTitles(Light_NoLight+1))],'ForegroundColor','green');

        end

    else
        set(handles2give.TrialTimeLineTextTag,'String',['Next Trial:   "' char(TrialTitles(Stim_NoStim+1)) '" '...
            char(AssociationTitles(Association+1))  '       ' char(LightTitles(Light_NoLight+1))],'ForegroundColor','k');
    end

    if trial_number~=1
        fclose(fid3);
        delete(lh3)
    end
    fid3=fopen([folder_name '\LickTrace' num2str(trial_number) '.bin'],'w');
    lh3 = addlistener(Stim_S,'DataAvailable',@(src, event)log_lick_data(src, event,Trial_Duration) );

    TrialLickData=[];

    % queueOutputData(Stim_S,[Wh_vec; Aud_vec]')
    SITrigger_vec=[ones(1,numel(Wh_vec)-2) 0 0];

    % queueOutputData(Stim_S,[Wh_vec; Aud_vec;Light_vec;Camera_vec;SITrigger_vec]')
    queueOutputData(Stim_S,[Wh_vec; Aud_vec;Camera_vec;SITrigger_vec]')

    while Stim_S.IsRunning
        disp('I am at line 332 of UpdateParams')
    end
    Stim_S.startBackground()
    ScansTobeAcquired=Stim_S.ScansQueued;

    outputSingleScan(Trigger_S,[0 0 0])


    if ~Reward_S.ScansQueued
        queueOutputData(Reward_S,Reward_vec')
        while Reward_S.IsRunning
            disp('I am at line 342 of UpdateParams') %sthg? not real line because update
        end
        Reward_S.startBackground();
    end

    % Define response window bounds
    ResponseWindowStart=(ArtifactWindow+BaselineWindow)/1000;
    ResponseWindowEnd=(ArtifactWindow+BaselineWindow+ResponseWindow)/1000 ;

    handles2give.ReportPause=1; %?

    TrialStarted=0;
    StimBoolian=1;
    LickEarlyAlreadyDetected=1;
    RewardShouldBeDelivered=0;
    PerformanceAndSaveBoolian=0;

    ReactionTime=0;
    AnimalLicked=0;

    RewardDelivered=0;
    UpdateParametersBoolean=0;

end