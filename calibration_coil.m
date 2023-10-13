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

% Create mouse directory and calibration subdirectories 
if ~exist([char(dest_path) '\' char(mouse_name)], 'dir')
    mkdir(dest_path,mouse_name);
end
if ~exist([char(dest_path) '\' char(mouse_name) '\'  char(mouse_name) '_' char(date)],'dir')
    mkdir([char(dest_path) '\' char(mouse_name)], [char(mouse_name) '_' char(date)]);
end


%% Choose stimulus name and define impulse parameters
%  The variable stim_name must match one of the cases below.

%stim_name = 'biphasic_hann_3ms';
stim_name = 'biphasic_hann_3ms_psy';
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


elseif strcmp(stim_name, 'biphasic_hann_3ms_psy')

    stim_amp_volt_max = 2.8;

    % Define voltages to test
    stim_amp_volt_list = [
        stim_amp_volt_max;
        stim_amp_volt_max * 0.8;
        stim_amp_volt_max * 0.6;
        stim_amp_volt_max * 0.4;
        ];

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


    stim_array = zeros(length(stim_amp_volt_list), sr*trial_dur);
    for istim=1:length(stim_amp_volt_list)
        stim_amp = stim_amp_volt_list(istim);
        biphasic_hann_3ms = stim_amp * [zeros(1,baseline_dur*sr) impulse];
        stim = [biphasic_hann_3ms zeros(1,trial_dur*sr - numel(biphasic_hann_3ms))];
        stim_array(istim,:) = stim';
    end
end


%% Test stimulus, plot and save calibration data.

n_trials = 3; % number of trials to test, per stimulus
len = numel(stim); % number of data points in stimulus

if strcmp(stim_name,'biphasic_hann_3ms_psy')

    % Tile different stimulus amplitudes, and stimuli

    trials_stim_amp_volt = [ ...
    repmat(stim_amp_volt_list(1),n_trials,1); ...    
    repmat(stim_amp_volt_list(2),n_trials,1); ...    
    repmat(stim_amp_volt_list(3),n_trials,1); ...    
    repmat(stim_amp_volt_list(4),n_trials,1); ...    
    ];

    stim_array = [ ...
    repmat(stim_array(1,:),n_trials,1); ...
    repmat(stim_array(2,:),n_trials,1); ...
    repmat(stim_array(3,:),n_trials,1); ...
    repmat(stim_array(4,:),n_trials,1); ...
    ];

    % Update number of trials to send; init. data storage
    n_stim_amp = height(stim_amp_volt_list);
    n_trials = n_trials * n_stim_amp;
    flux_data = zeros(n_trials,len);
else

    flux_data = zeros(n_trials,len);
    trials_stim_amp_volt = repmat(stim_amp_volt, n_trials, 1);

end
    
    
disp(['Starting calibration: ' stim_name]);

for itrial=1:n_trials
   disp(['Stim ' int2str(itrial)]);

   if strcmp(stim_name,'biphasic_hann_3ms_psy')
        stim = stim_array(itrial,:);
   end

   queueOutputData(session, stim');
   prepare(session);
   d = startForeground(session);
   flux_data(itrial,:) = d(:,1); % keep data
   pause(.5);

end

session.stop();

session.release();
disp('Calibration done.')


% Find maximum amplitude of magnetic flux in mT 

min_prominence = 0.05; % teslameter scale: 5 mT
trials_stim_amp_millitesla = zeros(n_trials,0);
trials_stim_amp_index = zeros(n_trials,0);

for itrial=1:n_trials
    [pks,locs] = findpeaks(flux_data(itrial,:),'Npeaks',1,'MinPeakProminence',min_prominence);
    trials_stim_amp_millitesla(itrial) = pks * 100; % teslameter scale
    trials_stim_amp_index(itrial) = locs;
end

% Get mean amplitude across trials (for single-amplitude stimuli)

mean_amp_millitesla = mean(trials_stim_amp_millitesla) * 100;  % teslameter scale 

% Plot stimulus vector and magnetic flux 

time = linspace(0,trial_dur,numel(stim));

figure;
ax1 = subplot(2,1,1);
if strcmp(stim_name,'biphasic_hann_3ms_psy')
    plot(time, stim_array');
else
    plot(time, stim)
end

ax2 = subplot(2,1,2);
plot(time, 100 *flux_data') % converting to mT
ylabel(ax2, 'Magnetic flux [mT]');

linkaxes([ax1,ax2],'x');

xlim([1995 2015])
xlabel('Time [ms]')
ylabel(ax1, 'Impulse [V]');
ylabel(ax2, 'Magnetic flux [mT]');


% Save figure and calibration data in file
save_folder = [char(dest_path) '\' char(mouse_name) '\'  char(mouse_name) '_' char(date)];
figure_file = [mouse_name '_' int2str(yyyymmdd(date)) '_stim_coil_calibration'];
figure_file = fullfile(save_folder, figure_file);
saveas(gcf, figure_file, 'png')


if strcmp(stim_name,'biphasic_hann_3ms_psy')
    stim = stim_array;
end

data_file = [mouse_name '_' int2str(yyyymmdd(date)) '_stim_coil_calibration.m'];
data_file = fullfile(save_folder, data_file);
save(data_file,'mouse_name','stim_name','n_trials','flux_data','stim','trials_stim_amp_volt','trials_stim_amp_millitesla','mean_amp_millitesla','stim_duration_up','stim_duration_down','scale_factor','session_sampling_rate')
disp(['Calibration data saved in: ' data_file])

