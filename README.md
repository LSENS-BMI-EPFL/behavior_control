# Behaviour Control
**Work in progress.**

MATLAB code to control data acquisition and behavioural sessions of sensory detection task(s) at Laboratory of Sensory Processing, EPFL.
This code currently supports (uncued, undelayed) simple sensory (auditory, whisker) detection tasks. :mouse:	:desktop_computer:

**Contributing - important information**: :warning:	
- The LSENS datajoint depends on the output of **behaviour_control**. Therefore, changes made on the output of this code (i.e. `results.csv`, `session_config.json`) must be repercuted in the LSENS datajoint.
- Example: adding/removing a variable in either of these two files mean that the corresponding table (BehaviourTrial, Session) in datajoint may be wrongly defined. This table must be updated with this variable (using the same name) and include a default variable (`null`) for all previously generated files that did not include this information. 
- In datajoint, redefinition of tables require to "drop" the tables and repopulate them (see [lsens_datajoint](https://github.com/LSENS-BMI-EPFL/lsens_datajoint)). **This takes some time, the goal is to change these output as rarely as possible, and make use of the available boolean variables as much as possible.**


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
- Control desired choice GUI text input, general settings and task parameters. <- These together design a sensory detection task.

Description of the main action buttons: 
- **START**: a new session is created. After a START, one can stop and pause. Resume has no effect.
- **STOP**: the running session is stopped. After a STOP, one can only start a new session. **Note**: a stop will interrupt the session and generate output, which cannot be continued again.
- **PAUSE**: pauses the running session. After a PAUSE, one can resume or stop the session.
- **RESUME**: continues the running session again after pressing PAUSE. After a RESUME, one can start, pause and stop the session.
- **UPDATE CONFIG**: update and overrides the `session_config.json` file (see below) with the current state of the GUI parameters.

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


3. **Continuous behavioural events and epochs:** `log_continuous.bin`: binary file containing 5000Hz sampled analog data acquired during the entire sesion.



**Other notes**: parameters and features related to video filming are currently not supported and setup-dependent. Therefore no documentation related to video filming is provided yet.
