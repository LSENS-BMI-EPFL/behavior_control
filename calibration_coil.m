%% Define data acquisition session.

session = daq.createSession('ni');
session_sampling_rate = 100000;
session.Rate = session_sampling_rate;

% Send coil impulse to amplifier. (This can be like your behaviour sessions.)
addAnalogOutputChannel(session,'Dev2','ao0', 'Voltage');
% channel_coil = addAnalogOutputChannel(session,'PXI1Slot2','ao0', 'Voltage');

% Read teslameter or displacement sensor output.
addAnalogInputChannel(session,'Dev2','ai1', 'Voltage');

%% Define coil impulses as stimuli.

sr = session_sampling_rate/1000;  % Sampling rate in ms.
baseline_dur = 2000;
trial_dur = 4000;

% Blank stimulus.
blank = zeros(1,trial_dur*sr);

% Biphasic square pulse 1 ms 35 mT.

stim_amp = 3.3;
stim_duration = 1;
scale_factor = .95;

stim_duration_up = stim_duration/2*sr+6;
stim_duration_down = stim_duration/2*sr+1;

biphasic_square_35 = stim_amp*[zeros(1,baseline_dur*sr) ones(1,stim_duration_up) -ones(1,stim_duration_down)*scale_factor];
biphasic_square_35 = [biphasic_square_35 zeros(1,trial_dur*sr-numel(biphasic_square_35))];

% Biphasic square pulse 3 ms 35 mT.

stim_amp = 3.3;
stim_duration = 3;
scale_factor = .95;

stim_duration_up = stim_duration/2*sr+6;
stim_duration_down = stim_duration/2*sr+1;

biphasic_square_3ms_35 = stim_amp*[zeros(1,baseline_dur*sr) ones(1,stim_duration_up) -ones(1,stim_duration_down)*scale_factor];
biphasic_square_3ms_35 = [biphasic_square_3ms_35 zeros(1,trial_dur*sr-numel(biphasic_square_3ms_35))];


% Biphasic square pulse 1 ms 30 mT.

stim_amp = 2.8;
stim_duration = 1;
scale_factor = .95;

stim_duration_up = stim_duration/2*sr+6;
stim_duration_down = stim_duration/2*sr+1;

biphasic_square_30 = stim_amp*[zeros(1,baseline_dur*sr) ones(1,stim_duration_up) -ones(1,stim_duration_down)*scale_factor];
biphasic_square_30 = [biphasic_square_30 zeros(1,trial_dur*sr-numel(biphasic_square_30))];

% Biphasic Hann window 1.6 ms 35 mT.

stim_amp = 4;
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

biphasic_hann_35 = stim_amp * [zeros(1,baseline_dur*sr) impulse];
biphasic_hann_35 = [biphasic_hann_35 zeros(1,trial_dur*sr - numel(biphasic_hann_35))];


% Biphasic Hann window 1.6 ms 30 mT.

stim_amp = 3.2;
stim_duration_up = 1;
stim_duration_down = .6;
scale_factor = 1.6;

stim_duration_up = stim_duration_up*sr;
stim_duration_down = stim_duration_down*sr;

impulse_up = tukeywin(stim_duration_up,1);
impulse_up = impulse_up(1:end-1);
impulse_down = -tukeywin(stim_duration_down,1);
impulse_down = impulse_down(2:end);
impulse = [impulse_up' scale_factor*impulse_down'];

biphasic_hann_30 = stim_amp * [zeros(1,baseline_dur*sr) impulse];
biphasic_hann_30 = [biphasic_hann_30 zeros(1,trial_dur*sr - numel(biphasic_hann_30))];

% Biphasic Hann window 1.6 ms 25 mT.

stim_amp = 2.4;
stim_duration_up = 1;
stim_duration_down = .6;
scale_factor = 1.3;

stim_duration_up = stim_duration_up*sr;
stim_duration_down = stim_duration_down*sr;

impulse_up = tukeywin(stim_duration_up,1);
impulse_up = impulse_up(1:end-1);
impulse_down = -tukeywin(stim_duration_down,1);
impulse_down = impulse_down(2:end);
impulse = [impulse_up' scale_factor*impulse_down'];

biphasic_hann_25 = stim_amp * [zeros(1,baseline_dur*sr) impulse];
biphasic_hann_25 = [biphasic_hann_25 zeros(1,trial_dur*sr - numel(biphasic_hann_25))];


% Biphasic Hann window 1.6 ms 20 mT.

stim_amp = 2.2;
stim_duration_up = 1;
stim_duration_down = .6;
scale_factor = 1.3;

stim_duration_up = stim_duration_up*sr;
stim_duration_down = stim_duration_down*sr;

impulse_up = tukeywin(stim_duration_up,1);
impulse_up = impulse_up(1:end-1);
impulse_down = -tukeywin(stim_duration_down,1);
impulse_down = impulse_down(2:end);
impulse = [impulse_up' scale_factor*impulse_down'];

biphasic_hann_20 = stim_amp * [zeros(1,baseline_dur*sr) impulse];
biphasic_hann_20 = [biphasic_hann_20 zeros(1,trial_dur*sr - numel(biphasic_hann_20))];

% Biphasic Hann window 1.6 ms 15 mT.

stim_amp = 1.7;
stim_duration_up = 1;
stim_duration_down = .6;
scale_factor = 1.25;

stim_duration_up = stim_duration_up*sr;
stim_duration_down = stim_duration_down*sr;

impulse_up = tukeywin(stim_duration_up,1);
impulse_up = impulse_up(1:end-1);
impulse_down = -tukeywin(stim_duration_down,1);
impulse_down = impulse_down(2:end);
impulse = [impulse_up' scale_factor*impulse_down'];

biphasic_hann_15 = stim_amp * [zeros(1,baseline_dur*sr) impulse];
biphasic_hann_15 = [biphasic_hann_15 zeros(1,trial_dur*sr - numel(biphasic_hann_15))];


% Biphasic Hann window 3 ms 40 mT.

stim_amp = 3.2;
stim_duration_up = 1.5;
stim_duration_down = 1.5;
scale_factor = .9;

stim_duration_up = stim_duration_up*sr;
stim_duration_down = stim_duration_down*sr-5;

impulse_up = tukeywin(stim_duration_up,1);
impulse_up = impulse_up(1:end-1);
impulse_down = -tukeywin(stim_duration_down,1);
impulse_down = impulse_down(2:end);
impulse = [impulse_up' scale_factor*impulse_down'];

biphasic_hann_3ms_40 = stim_amp * [zeros(1,baseline_dur*sr) impulse];
biphasic_hann_3ms_40 = [biphasic_hann_3ms_40 zeros(1,trial_dur*sr - numel(biphasic_hann_3ms_40))];

% Biphasic Hann window 3 ms 35 mT.

stim_amp = 2.85;
stim_duration_up = 1.5;
stim_duration_down = 1.5;
scale_factor = .6;

stim_duration_up = stim_duration_up*sr;
stim_duration_down = stim_duration_down*sr-5;

impulse_up = tukeywin(stim_duration_up,1);
impulse_up = impulse_up(1:end-1);
impulse_down = -tukeywin(stim_duration_down,1);
impulse_down = impulse_down(2:end);
impulse = [impulse_up' scale_factor*impulse_down'];

biphasic_hann_3ms_35 = stim_amp * [zeros(1,baseline_dur*sr) impulse];
biphasic_hann_3ms_35 = [biphasic_hann_3ms_35 zeros(1,trial_dur*sr - numel(biphasic_hann_3ms_35))];

% Biphasic Hann window 3 ms 30 mT.

stim_amp = 2.3;
stim_duration_up = 1.5;
stim_duration_down = 1.5;
scale_factor = .6;

stim_duration_up = stim_duration_up*sr;
stim_duration_down = stim_duration_down*sr;

impulse_up = tukeywin(stim_duration_up,1);
impulse_up = impulse_up(1:end-1);
impulse_down = -tukeywin(stim_duration_down,1);
impulse_down = impulse_down(2:end);
impulse = [impulse_up' scale_factor*impulse_down'];

biphasic_hann_3ms_30 = stim_amp * [zeros(1,baseline_dur*sr) impulse];
biphasic_hann_3ms_30 = [biphasic_hann_3ms_30 zeros(1,trial_dur*sr - numel(biphasic_hann_3ms_30))];


% Biphasic Hann window 3 ms 25 mT.

stim_amp = 1.95;
stim_duration_up = 1.5;
stim_duration_down = 1.5;
scale_factor = .6;

stim_duration_up = stim_duration_up*sr;
stim_duration_down = stim_duration_down*sr;

impulse_up = tukeywin(stim_duration_up,1);
impulse_up = impulse_up(1:end-1);
impulse_down = -tukeywin(stim_duration_down,1);
impulse_down = impulse_down(2:end);
impulse = [impulse_up' scale_factor*impulse_down'];

biphasic_hann_3ms_25 = stim_amp * [zeros(1,baseline_dur*sr) impulse];
biphasic_hann_3ms_25 = [biphasic_hann_3ms_25 zeros(1,trial_dur*sr - numel(biphasic_hann_3ms_25))];



% Biphasic Hann window 3 ms 20 mT.

stim_amp = 1.5;
stim_duration_up = 1.5;
stim_duration_down = 1.5;
scale_factor = .6;

stim_duration_up = stim_duration_up*sr;
stim_duration_down = stim_duration_down*sr;

impulse_up = tukeywin(stim_duration_up,1);
impulse_up = impulse_up(1:end-1);
impulse_down = -tukeywin(stim_duration_down,1);
impulse_down = impulse_down(2:end);
impulse = [impulse_up' scale_factor*impulse_down'];

biphasic_hann_3ms_20 = stim_amp * [zeros(1,baseline_dur*sr) impulse];
biphasic_hann_3ms_20 = [biphasic_hann_3ms_20 zeros(1,trial_dur*sr - numel(biphasic_hann_3ms_20))];


% Biphasic Hann window 3 ms 15 mT.

stim_amp = 1.2;
stim_duration_up = 1.5;
stim_duration_down = 1.5;
scale_factor = .6;

stim_duration_up = stim_duration_up*sr;
stim_duration_down = stim_duration_down*sr;

impulse_up = tukeywin(stim_duration_up,1);
impulse_up = impulse_up(1:end-1);
impulse_down = -tukeywin(stim_duration_down,1);
impulse_down = impulse_down(2:end);
impulse = [impulse_up' scale_factor*impulse_down'];

biphasic_hann_3ms_15 = stim_amp * [zeros(1,baseline_dur*sr) impulse];
biphasic_hann_3ms_15 = [biphasic_hann_3ms_15 zeros(1,trial_dur*sr - numel(biphasic_hann_3ms_15))];


%%%%

% Monophasic Hann window 1 ms 35 mT.

stim_amp = 4;
stim_duration_up = 1;
stim_duration_down = 0;

stim_duration_up = stim_duration_up*sr;
stim_duration_down = stim_duration_down*sr;

impulse_up = tukeywin(stim_duration_up,1);
impulse_up = impulse_up(1:end-1);
impulse_down = -tukeywin(stim_duration_down,1);
impulse_down = impulse_down(2:end);
impulse = [impulse_up' scale_factor*impulse_down'];

monophasic_hann_1ms_35 = stim_amp * [zeros(1,baseline_dur*sr) impulse];
monophasic_hann_1ms_35 = [monophasic_hann_1ms_35 zeros(1,trial_dur*sr - numel(monophasic_hann_1ms_35))];


% Monophasic Hann window 1 ms 30 mT.

stim_amp = 3.2;
stim_duration_up = 1;
stim_duration_down = 0;

stim_duration_up = stim_duration_up*sr;
stim_duration_down = stim_duration_down*sr;

impulse_up = tukeywin(stim_duration_up,1);
impulse_up = impulse_up(1:end-1);
impulse_down = -tukeywin(stim_duration_down,1);
impulse_down = impulse_down(2:end);
impulse = [impulse_up' scale_factor*impulse_down'];

monophasic_hann_1ms_30 = stim_amp * [zeros(1,baseline_dur*sr) impulse];
monophasic_hann_1ms_30 = [monophasic_hann_1ms_30 zeros(1,trial_dur*sr - numel(monophasic_hann_1ms_30))];

% Monophasic Hann window 1 ms 25 mT.

stim_amp = 2.6;
stim_duration_up = 1;
stim_duration_down = 0;

stim_duration_up = stim_duration_up*sr;
stim_duration_down = stim_duration_down*sr;

impulse_up = tukeywin(stim_duration_up,1);
impulse_up = impulse_up(1:end-1);
impulse_down = -tukeywin(stim_duration_down,1);
impulse_down = impulse_down(2:end);
impulse = [impulse_up' scale_factor*impulse_down'];

monophasic_hann_1ms_25 = stim_amp * [zeros(1,baseline_dur*sr) impulse];
monophasic_hann_1ms_25 = [monophasic_hann_1ms_25 zeros(1,trial_dur*sr - numel(monophasic_hann_1ms_25))];


% Monophasic Hann window 1 ms 20 mT.

stim_amp = 2;
stim_duration_up = 1;
stim_duration_down = 0;

stim_duration_up = stim_duration_up*sr;
stim_duration_down = stim_duration_down*sr;

impulse_up = tukeywin(stim_duration_up,1);
impulse_up = impulse_up(1:end-1);
impulse_down = -tukeywin(stim_duration_down,1);
impulse_down = impulse_down(2:end);
impulse = [impulse_up' scale_factor*impulse_down'];

monophasic_hann_1ms_20 = stim_amp * [zeros(1,baseline_dur*sr) impulse];
monophasic_hann_1ms_20 = [monophasic_hann_1ms_20 zeros(1,trial_dur*sr - numel(monophasic_hann_1ms_20))];


% Monophasic Hann window 1 ms 15 mT.

stim_amp = 1.45;
stim_duration_up = 1;
stim_duration_down = 0;

stim_duration_up = stim_duration_up*sr;
stim_duration_down = stim_duration_down*sr;

impulse_up = tukeywin(stim_duration_up,1);
impulse_up = impulse_up(1:end-1);
impulse_down = -tukeywin(stim_duration_down,1);
impulse_down = impulse_down(2:end);
impulse = [impulse_up' scale_factor*impulse_down'];

monophasic_hann_1ms_15 = stim_amp * [zeros(1,baseline_dur*sr) impulse];
monophasic_hann_1ms_15 = [monophasic_hann_1ms_15 zeros(1,trial_dur*sr - numel(monophasic_hann_1ms_15))];


%%%%

% Monophasic Hann window 3 ms 35 mT.

stim_amp = 1.6;
stim_duration_up = 3;
stim_duration_down = 0;

stim_duration_up = stim_duration_up*sr;
stim_duration_down = stim_duration_down*sr;

impulse_up = tukeywin(stim_duration_up,1);
impulse_up = impulse_up(1:end-1);
impulse_down = -tukeywin(stim_duration_down,1);
impulse_down = impulse_down(2:end);
impulse = [impulse_up' scale_factor*impulse_down'];

monophasic_hann_3ms_35 = stim_amp * [zeros(1,baseline_dur*sr) impulse];
monophasic_hann_3ms_35 = [monophasic_hann_3ms_35 zeros(1,trial_dur*sr - numel(monophasic_hann_3ms_35))];


% Monophasic Hann window 3 ms 30 mT.

stim_amp = 1.4;
stim_duration_up = 3;
stim_duration_down = 0;

stim_duration_up = stim_duration_up*sr;
stim_duration_down = stim_duration_down*sr;

impulse_up = tukeywin(stim_duration_up,1);
impulse_up = impulse_up(1:end-1);
impulse_down = -tukeywin(stim_duration_down,1);
impulse_down = impulse_down(2:end);
impulse = [impulse_up' scale_factor*impulse_down'];

monophasic_hann_3ms_30 = stim_amp * [zeros(1,baseline_dur*sr) impulse];
monophasic_hann_3ms_30 = [monophasic_hann_3ms_30 zeros(1,trial_dur*sr - numel(monophasic_hann_3ms_30))];

% Monophasic Hann window 3 ms 25 mT.

stim_amp = 1.1;
stim_duration_up = 3;
stim_duration_down = 0;

stim_duration_up = stim_duration_up*sr;
stim_duration_down = stim_duration_down*sr;

impulse_up = tukeywin(stim_duration_up,1);
impulse_up = impulse_up(1:end-1);
impulse_down = -tukeywin(stim_duration_down,1);
impulse_down = impulse_down(2:end);
impulse = [impulse_up' scale_factor*impulse_down'];

monophasic_hann_3ms_25 = stim_amp * [zeros(1,baseline_dur*sr) impulse];
monophasic_hann_3ms_25 = [monophasic_hann_3ms_25 zeros(1,trial_dur*sr - numel(monophasic_hann_3ms_25))];


% Monophasic Hann window 3 ms 20 mT.

stim_amp = .85;
stim_duration_up = 3;
stim_duration_down = 0;

stim_duration_up = stim_duration_up*sr;
stim_duration_down = stim_duration_down*sr;

impulse_up = tukeywin(stim_duration_up,1);
impulse_up = impulse_up(1:end-1);
impulse_down = -tukeywin(stim_duration_down,1);
impulse_down = impulse_down(2:end);
impulse = [impulse_up' scale_factor*impulse_down'];

monophasic_hann_3ms_20 = stim_amp * [zeros(1,baseline_dur*sr) impulse];
monophasic_hann_3ms_20 = [monophasic_hann_3ms_20 zeros(1,trial_dur*sr - numel(monophasic_hann_3ms_20))];


% Monophasic Hann window 3 ms 15 mT.

stim_amp = 0.6;
stim_duration_up = 3;
stim_duration_down = 0;

stim_duration_up = stim_duration_up*sr;
stim_duration_down = stim_duration_down*sr;

impulse_up = tukeywin(stim_duration_up,1);
impulse_up = impulse_up(1:end-1);
impulse_down = -tukeywin(stim_duration_down,1);
impulse_down = impulse_down(2:end);
impulse = [impulse_up' scale_factor*impulse_down'];

monophasic_hann_3ms_15 = stim_amp * [zeros(1,baseline_dur*sr) impulse];
monophasic_hann_3ms_15 = [monophasic_hann_3ms_15 zeros(1,trial_dur*sr - numel(monophasic_hann_3ms_15))];


%% Test stimulus and plot.

% Choose stim and run
% stim = biphasic_square_35;
% stim = biphasic_square_3ms_35;
stim = biphasic_hann_3ms_40;
% stim = biphasic_hann_35;
% stim = biphasic_hann_3ms_30;
% stim = monophasic_hann_1ms_35;
% stim = monophasic_hann_3ms_35;
% stim = blank;


ntrials = 5;
len = numel(stim);

flux_data = zeros(ntrials,len);

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
disp('Done.')

time = linspace(0,trial_dur,numel(stim));

% Plot
figure
ax1 = subplot(2,1,1);
plot(time, stim)
ax2 = subplot(2,1,2);
plot(time,flux_data')
linkaxes([ax1,ax2],'x')


%% Save calibration data.

path_write = 'K:\BehaviourCode\Calibration';

date = datetime('today', 'Format', 'yyyymmdd');
file = [int2str(yyyymmdd(date)) '_calibration_stim_magnetic_flux_biphasic_hann_3ms_40.m'];

file = fullfile(path_write, file);
save(file,'ntrials','flux_data','stim','stim_amp','stim_duration_up','stim_duration_down','scale_factor', 'session_sampling_rate')
disp('Calibration data saved.')





