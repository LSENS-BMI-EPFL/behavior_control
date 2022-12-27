# Behaviour Control

MATLAB code to control data acquisition and behavioural sessions of sensory detection task(s) at Laboratory of Sensory Processing, EPFL. :mouse:	:desktop_computer:
This code currently supports  (uncued, undelayed) simple sensory (auditory, whisker) detection tasks. This page briefly explains how to use the software and GUI for behavioural sessions.

**Note**: parameters and features related to video filming are currently not supported and setup-dependent. Therefore no documentation related to video filming is provided yet.

### Requirements
 - Git
 - MATLAB, with the add-ons:
    - Data Acquisition Toolbox Support Package for National Instrument NI-DAQmx Devices
    - Data Acquisition Toolbox
    - Signal Processing Toolbox (`downsample`)
    - Statistics and Machine Learning Toolbox (`randsample`)
 - An audio player (e.g. VLC) for white noise

### Installation
- Clone or download the repository `git clone ...` in the computer from which you wish to run the behaviour on.


### How to use
#### Setting up 
- In `defining_sessions.m`: for each `daq.Session` instance, modify input and output channels so that it matches your NIDQ devices, hardware wiring setup connections on NI boards.

- In `Detection_GUI.m`: set default parameters tags to have them ready at GUI initiliazation: general settings, timeline parameters, auditory parmeters, etc. You may still change these parameters before the start of the session, or even during the session, if the `Enable` parameter if set to `on` for each "Tag" variable: `on` makes the GUI feature active and responsive to user changes. 

- Whisker stimulus calibration using electromagnetic coil-based whisker deflection:
  - Before any whisker stimulus experiments, one must calibrate whisker stimulation to make sure it is strong enough and reliable.
  - Use `calibration_coil.m` file using the teslameter connected to a NI board to measure the volt-tesla (V-mT) relationship.
  - Based on in-lab measurements, whisker deflection is sufficiently strong when the peak of the magnetic flux intensity reaches at least 30mT.


#### Default usage
- Run `DetectionGUI.m` to open GUI.
- Untick the Video filming checkbox (unsupported feature). 
- Control desired choice GUI text input, general settings and task parameters.
- Press START/PAUSE/RESUME/STOP to control the session. Careful: if you press STOP, all output files will be generated and upon pressing START again will create a new session folder. 

TODO - Describe GUI FEATURES

### Outputs
During and at the end of the behavioural session, the software outputs several files:
- `session_config.json`: text file containing default parameters used at GUI initialization, saving session-wide parameters.
- `results.txt`: trial-based file, appended after each trial, with trial information.
- `results.csv`: same as `results.txt`, converted after stopping the session.
- `LickTraceX.bin`: binary file containing downsampled lick piezo sensor data and timestamps of trial X, of duration specified by the `trial_duration` parameter.
