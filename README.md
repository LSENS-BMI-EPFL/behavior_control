# Behaviour Control

MATLAB code to control data acquisition and behavioural sessions of sensory detection task(s) at Laboratory of Sensory Processing, EPFL.
This code currently supports (uncued, undelayed) simple sensory (auditory, whisker) detection tasks. :mouse:	:desktop_computer:

**Note**: parameters and features related to video filming are currently not supported and setup-dependent. Therefore no documentation related to video filming is provided yet.

**Note about development**:
- Adding columns to results data files mean change in column indexing. Subsequent changes must be made when indexing the `results` variables e.g. calcultion of performance, reward consumed and more!


### Requirements
 - Git
 - MATLAB > 2022, with the add-ons:
    - Data Acquisition Toolbox.
    - Data Acquisition Toolbox Support Package for National Instrument NI-DAQmx Devices (**Note**: this takes a bit of time).
    - Statistics and Machine Learning Toolbox (for the `randsample` function).
 - An audio player (e.g. VLC) for playing white noise.

### Installation
- Clone the repository `git clone ...`, or download as zip in the computer from which you wish to run the behaviour.


### How to use
#### Setting up 
- In `defining_sessions.m`: for each `daq.Session` instance, modify input and output channels so that it matches your NI DAQ device setup connections.

- In `Detection_GUI.m`, set default session and task parameters to have them ready at GUI initialization. You can change these parameters in the GUI before and even during the session.

- Whisker stimulus calibration using electromagnetic coil-based whisker deflection:
  - Use `calibration_coil.m` file using the teslameter connected to a NI board to measure the volt-tesla (V-mT) relationship.

#### Default usage
- Run `DetectionGUI.m` to open GUI.
- Make sure Camera tickbox is unticked (unsupported), otherwise it won't execute.
- Control desired choice GUI text input, general settings and task parameters.
- Press START/PAUSE/RESUME/STOP to control the session. A new session is created upon pressing START.

### Outputs
During and at the end of the behavioural session, the software outputs several files:
1. **Session information:** `session_config.json`: text file containing default parameters used at GUI initialization, saving session-wide parameters, such as:
- `date`, `time`, `mouse_name`, `behaviour_directory`
- `twophoton_session` : a boolean to specifiy if sessios was a two-photon experiment
- `ephys_session`: idem for electrophysiolgy session
- `opto_session`, `chemo_session`, etc.
- `behaviour_type`: string, which type of behaviour was run e.g. "auditory"/"whisker" for auditory/whisker detection tasks; entered by user (this field _can_ be more task-specific, e.g. summarized by a set of task parameters)
- `min_iti`, `max_iti`: lower and upper bounds for inter-trial intervals (ITIs)
- `response_window`: duration of response window
- `wh_reward`: boolean if whisker trials were rewarded by default
- `aud_reward`: idem for auditory trials
- etc.
2. **Trial information:** `results.txt`: trial-based file, appended after each trial during the session. This file is converted into a `result.csv` after stopping the session. These files contain trial-wide parameters, such as:
- `trial_number`: index of trial
- `trial_time`: time of trial, relative to session start, in seconds (MATLAB tic/toc)
- `is_stim`: boolean, if trial is a stimulus trial
- `is_whisker`: boolean, if trial is a whisker stimulus trial
- `wh_stim_duration`: duration of whisker stimulus
- `lick_flag`: boolean, if mouse has licked in response window
- `reaction_time`: lick reaction time, in seconds
- `iti`: inter-trial interval that preceded trial onset, in milliseconds
- `perf`: performance code for trial outcome
- etc.
3. **Lick piezosensor information:** `LickTraceX.bin`: binary files containing 10x downsampled lick piezo sensor data and timestamps of trial X, of duration specified by the `trial_duration` parameter.
