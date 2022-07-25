%% Define daq session.

session = daq.createSession('ni');
session_sampling_rate = 100000;
session.Rate = session_sampling_rate;

% Send coil impulse to coil amplifier.
channel_coil = addAnalogOutputChannel(session,'PXI1Slot2','ao0', 'Voltage');

% Read teslameter output.
channel_tesla = addAnalogInputChannel(session,'PXI1Slot2','ai2', 'Voltage');

%% Define coil impulse.

stim_amp = 3.5;
stim_duration = 1.1;
scale_factor = 1.6;
baseline_dur = 2000;
trial_dur = 4000;

stim_duration_up = round(stim_duration*session_sampling_rate/2000);
stim_duration_down = round(stim_duration*session_sampling_rate/2000);

biphasic_square = stim_amp*[zeros(1,baseline_dur*session_sampling_rate/1000) ones(1,stim_duration_up) -ones(1,stim_duration_down)*scale_factor];
biphasic_square = [biphasic_square zeros(1,(trial_dur)*(session_sampling_rate/1000)-numel(biphasic_square))];

stim_duration_up = round(stim_duration*session_sampling_rate/1000);

impulse_up = sin(linspace(0,1*pi,stim_duration_up));
impulse_down = sin(linspace(1*pi,2*pi,stim_duration_up/2));
impulse_down = impulse_down(2:end);
impulse = [impulse_up scale_factor*impulse_down];
biphasic_sine = stim_amp * [zeros(1,(baseline_dur)*session_sampling_rate/1000) impulse];
biphasic_sine = [biphasic_sine zeros(1,(trial_dur)*(session_sampling_rate/1000)-numel(biphasic_sine))];

impulse_up = tukeywin(stim_duration_up,1);
impulse_down = -tukeywin(stim_duration_up/2,1);
impulse = [impulse_up' scale_factor*impulse_down'];
% impulse = smoothdata(impulse, 'g', 50, 2);
biphasic_hann = stim_amp * [zeros(1,(baseline_dur)*session_sampling_rate/1000) impulse];
biphasic_hann = [biphasic_hann zeros(1,(trial_dur)*(session_sampling_rate/1000)-numel(biphasic_hann))];

% plot(biphasic_hann);
%%
stim = biphasic_hann;
% stim = biphasic_square;

ntrial = 1;
len = numel(stim);

data = zeros(ntrial,len);

for itrial=1:ntrial
   disp(itrial)
   queueOutputData(session, stim');
   prepare(session);
   d = startForeground(session);
   data(itrial,:) = d(:,1);
   pause(1);
end

session.stop();
session.release();

%%

time = linspace(0,trial_dur,numel(stim));
figure
ax1 = subplot(2,1,1);
plot(time, stim)
ax2 = subplot(2,1,2);
plot(time,data')
linkaxes([ax1,ax2],'x')

% for itrial=1:ntrial
%     plot(data(itrial,:))
% end

%% Save calibration data.

path_write = 'D:\calibration';
file = 'calibration_coil_220628_biphasic_sin_2,1ms_sc1,4.m';
file = fullfile(path_write, file);
save(file,'data','stim','stim_amp','stim_duration','scale_factor')

