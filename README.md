# Behaviour Control

MATLAB code to control data acquisition and behavioural sessions of sensory detection task(s).


**How to use**
- Change `Detection_GUI.m`s default parameters tags (mouse name, task parameters, directory paths, etc.) to have them ready at GUI start.
- Run `DetectionGUI.m` to open GUI.
- Control choice of task parameters then START/STOP session.


**Outputs** 
- `session_config.json`: text file containing default parameters used at GUI initialization, saving session-wide parameters.
- `results.txt`: trial-based file, appended after each trial, with trial information.
- `results.csv`: same as `results.txt`, converted after stopping the session.
- 'LickTraceX.bin`: binary file containing lick piezo sensor data and timestamps of trial X, of duration specified by the `trial_duration` parameter.
