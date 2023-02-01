# Behaviour Control

MATLAB code to control data acquisition and behavioural sessions of sensory detection task(s) at Laboratory of Sensory Processing, EPFL. :mouse:	:desktop_computer:
This code currently supports  (uncued, undelayed) simple sensory (auditory, whisker) detection tasks.

**Note**: parameters and features related to video filming are currently not supported and setup-dependent. Therefore no documentation related to video filming is provided yet.

### Requirements
 - Git
 - MATLAB, with the add-ons:
    - Data Acquisition Toolbox.
    - Data Acquisition Toolbox Support Package for National Instrument NI-DAQmx Devices.
    - Statistics and Machine Learning Toolbox (`randsample`).
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
- `session_config.json`: text file containing default parameters used at GUI initialization, saving session-wide parameters.
- `results.txt`: trial-based file, appended after each trial, with trial information.
- `results.csv`: same as `results.txt`, converted after stopping the session.
- `LickTraceX.bin`: binary file containing downsampled lick piezo sensor data and timestamps of trial X, of duration specified by the `trial_duration` parameter.
