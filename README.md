[![View Google WebRTC Voice Activity Detection (VAD) module on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://ch.mathworks.com/matlabcentral/fileexchange/78895-google-webrtc-voice-activity-detection-vad-module)

# mex-webrtcvad
This is a MATLAB executable (mex) wrapper for [Google's WebRTC](https://webrtc.org/) Voice Activity Detection (VAD) module.

## Get the latest release
* Download from [here](https://github.com/rafaelkarrer/mex-webrtcvad/releases)

## (Or compile from code) 
* Run `make.m`

## How to use
```
% Init
mexwebrtcvad('Init');

% Set VAD aggressiveness
vadAggr = 2;
mexwebrtcvad('SetMode', vadAggr);

% set 30ms frame length at 8kHz
frameLen = 240;
sampleRate = 8000;

% Create dummy audio signal (16bit)
numFrames = 100;
audioSignal = int16( (rand(numFrames * frameLen, 1) - 0.5) * (2^15-1) );

% Process frames in loop
for i=1:numFrames
    % Process one frame
    mvadOut(i) = mexwebrtcvad('Process', sampleRate, audioSignal((i-1)*frameLen+1:i*frameLen), frameLen);
end

% Free VAD
mexwebrtcvad('Free');
```
## Links
Wiseman's [Python Interface for WebRTC VAD](https://github.com/wiseman/py-webrtcvad)
