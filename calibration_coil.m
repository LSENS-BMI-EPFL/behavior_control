%% Define data acquisition session.

session = daq.createSession('ni');
session_sampling_rate = 100000;
session.Rate = session_sampling_rate;

% Send coil impulse to amplifier. (This can be like your behaviour sessions.)
addAnalogOutputChannel(session,'Dev2','ao0', 'Voltage');
% channel_coil = addAnalogOutputChannel(session,'PXI1Slot2','ao0', 'Voltage');

% Read teslameter or displacement sensor output.
addAnalogInputChannel(session,'Dev2','ai1', 'Voltage');

sr = session_sampling_rate/1000;  % Sampling rate in ms.
baseline_dur = 2000;
trial_dur = 4000;


%% Specify saving information and create folder

dest_path = 'C:\Users\bisi\Desktop\Calibration';
mouse_name = 'ABXXX';
date = datetime('today', 'Format', 'yyyyMMdd');

% Create mouse and calibration directory 
if ~exist([char(dest_path) '\' char(mouse_name)], 'dir')
    mkdir(dest_path,mouse_name);
end



%% Choose stimulus name and define impulse parameters
%  The variable stim_name must match one of the cases below.

% stim_name = 'biphasic_square_1ms';
% stim_name = 'biphasic_square_3ms';
% stim_name = 'biphasic_hann';
stim_name = 'biphasic_hann_3ms';
% stim_name = 'blank';


if strcmp(stim_name,'blank')

    % Blank stimulus.
    blank = zeros(1,trial_dur*sr);

elseif strcmp(stim_name,'biphasic_square_1ms')

    % Biphasic SQUARE pulse 1 ms.
    
    stim_amp_volt = 3.3;
    stim_duration = 1;
    scale_factor = .95;
    
    stim_duration_up = stim_duration/2*sr+6;
    stim_duration_down = stim_duration/2*sr+1;
    
    biphasic_square_1ms = stim_amp_volt*[zeros(1,baseline_dur*sr) ones(1,stim_duration_up) -ones(1,stim_duration_down)*scale_factor];
    stim = [biphasic_square_1ms zeros(1,trial_dur*sr-numel(biphasic_square_1ms))];

elseif strcmp(stim_name,'biphasic_square_3ms')

    % Biphasic square pulse 3 ms.
    
    stim_amp_volt = 3.3;
    stim_duration = 3;
    scale_factor = .95;
    
    stim_duration_up = stim_duration/2*sr+6;
    stim_duration_down = stim_duration/2*sr+1;
    
    biphasic_square_3ms = stim_amp_volt*[zeros(1,baseline_dur*sr) ones(1,stim_duration_up) -ones(1,stim_duration_down)*scale_factor];
    stim = [biphasic_square_3ms zeros(1,trial_dur*sr-numel(biphasic_square_3ms))];


elseif strcmp(stim_name,'biphasic_hann')
    % Biphasic Hann (raised cosine) window 1.6 ms.

    stim_amp_volt = 4;
    stim_duration_up = 1;
    stim_duration_down = .6;
    scale_factor = 1.85;
    
    stim_duration_up = stim_duration_up*sr;
    stim_duration_down = stim_duration_down*sr;
    
    impulse_up = tukeywin(stim_duration_up,1);
    impulse_up = impulse_up(1:end-1);
    impulse_down = -tukeywin(stim_duration_down,1);
    impulse_down = impulse_down(2:end);
    impulse = [impulse_up' scale_factor*impulse_down'];
    
    biphasic_hann = stim_amp_volt * [zeros(1,baseline_dur*sr) impulse];
    stim = [biphasic_hann zeros(1,trial_dur*sr - numel(biphasic_hann))];

elseif strcmp(stim_name,'biphasic_hann_3ms')

    % Biphasic Hann (raised cosine) window 3 ms.
    
    stim_amp_volt = 2.8;
    stim_duration_up = 1.5;
    stim_duration_down = 1.5;
    scale_factor = 0.9;
    
    stim_duration_up = stim_duration_up*sr;
    stim_duration_down = stim_duration_down*sr-5;
    
    impulse_up = tukeywin(stim_duration_up,1);
    impulse_up = impulse_up(1:end-1);
    impulse_down = -tukeywin(stim_duration_down,1);
    impulse_down = impulse_down(2:end);
    impulse = [impulse_up' scale_factor*impulse_down'];
    
    biphasic_hann_3ms = stim_amp_volt * [zeros(1,baseline_dur*sr) impulse];
    stim = [biphasic_hann_3ms zeros(1,trial_dur*sr - numel(biphasic_hann_3ms))];

end


%% Test stimulus, plot and save calibration data.


ntrials = 3;
len = numel(stim);
flux_data = zeros(ntrials,len);


disp(['Starting calibration: ' stim_name]);

for itrial=1:ntrials
   disp(['Stim ' int2str(itrial)]);
   queueOutputData(session, stim');
   prepare(session);
   d = startForeground(session);
   flux_data(itrial,:) = d(:,1);
   pause(.5);
end

session.stop();

session.release();
disp('Calibration done.')

% Find mean amplitude maximum of magnetic flux in mT findpeaks
min_prominence = 0.1; %in mT
trial_peaks_val = zeros(0,ntrials);
trial_peaks_loc = zeros(0,ntrials);

for itrial=1:ntrials
    [pks,locs] = findpeaks(flux_data(itrial,:),'Npeaks',1,'MinPeakProminence',0.1);
    trial_peaks_val(itrial) = pks;
    trial_peaks_loc(itrial) = locs;
end

stim_amp_millitesla = mean(trial_peaks_val) * 100;  % teslameter scale 

% Plot stimulus vector and magnetic flux %TODO: save figure
time = linspace(0,trial_dur,numel(stim));

figure;

plot(time);


figure;
ax1 = subplot(2,1,1);
plot(time, stim)
ax2 = subplot(2,1,2);
plot(time,flux_data')
linkaxes([ax1,ax2],'x');

%% Save figure and calibration data in file
%figure_file = [mouse_name '_' int2str(yyyymmdd(date)) '_stim_coil_calibration'];
%figure_file = fullfile([char(dest_path) '\' char(mouse_name)], figure_file);
%saveas(gcf, figure_file, 'png')
%
%data_file = [mouse_name '_' int2str(yyyymmdd(date)) '_stim_coil_calibration.m'];
%data_file = fullfile([char(dest_path) '\' char(mouse_name)], data_file);
%save(data_file,'mouse_name','stim_name', 'ntrials','flux_data','stim','stim_amp_volt','stim_amp_millitesla', 'stim_duration_up','stim_duration_down','scale_factor','sr')
%disp(['Calibration data saved in: ' data_file])







