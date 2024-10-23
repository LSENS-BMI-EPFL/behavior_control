# Behaviour Control

MATLAB code to control data acquisition and behavioural sessions of sensory detection task(s) at Laboratory of Sensory Processing, EPFL.
This code currently supports (uncued, undelayed) sensory (auditory, whisker) detection tasks. :mouse:	:desktop_computer:

Documentation for this code is in this [repo's wiki](https://github.com/LSENS-BMI-EPFL/behavior_control/wiki) & [GUI overview](https://github.com/LSENS-BMI-EPFL/behavior_control/wiki/How-does-the-GUI-work%3F#user-interface-overview).

### Requirements
 - Git
 - MATLAB > 2022, with the add-ons:
    - Data Acquisition Toolbox.
    - Data Acquisition Toolbox Support Package for National Instrument NI-DAQmx Devices (**Note**: this takes a bit of time).
    - Statistics and Machine Learning Toolbox (for the `randsample` function).
 - An audio player (e.g. VLC) for playing white noise.

### Installation
- Clone the repository `git clone ...`, (or download as zip) in the computer from which you wish to run the behaviour.
- Regularly check for updates, then `git pull` (or re-download)

### How to use - quick version
#### Setting up 
- In `defining_sessions.m`: for each `daq.Session` instance, modify input and output channels so that it matches your NI DAQ device setup connections.

- In `Detection_GUI.m`, set default session and task parameters to have them ready at GUI initialization. You can change these parameters in the GUI before and even during the session.

- Whisker stimulus calibration using electromagnetic coil-based whisker deflection:
  - Use `calibration_coil.m` file using the teslameter connected to a NI board to measure the volt-tesla (V-mT) relationship.

#### Start a session
- Run `DetectionGUI.m` to open GUI.
- Control desired choice GUI text input, general settings and task parameters. <- These together design a behavioural task.
- **Video filming**:
    - Make sure the parameters specified in the camera settings match that in IC Capture (frame rate, exposure time).
    - The start delay imposes a wait time before triggering frame acquisition.

Description of the main action buttons: 
- **START**: a new session is created. After a START, one can stop and pause. Resume has no effect.
- **STOP**: the running session is stopped. After a STOP, one can only start a new session. **Note**: a stop will interrupt the session and generate output, which cannot be continued again.
- **PAUSE**: pauses the running session. After a PAUSE, one can resume or stop the session.
- **RESUME**: continues the running session again after pressing PAUSE. After a RESUME, one can start, pause and stop the session.
- **UPDATE CONFIG**: update and overrides the `session_config.json` file (see below) with the current state of the GUI parameters.

#### Outputs
During and at the end of the behavioural session, the software outputs several files:
- `session_config.json`: text file containing default parameters used at GUI initialization, saving session-wide parameters.
- `results.csv`: trial-based file, appended after each trial during the session. This file contains trial-wide parameters.
- `log_continuous.bin`: binary file containing 5000Hz sampled analog data acquired during the entire session.



Happy training! 🐁
