function make(varargin)
% MAKE Build roomsim project
%   MAKE without arguments builds the roomsim project and updates the
%   ROOMSIM function in MATLAB.
%
%   MAKE TEST builds the unit tests of the roomsim project and updates the
%   ROOMSIMTEST function in MATLAB.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Steven Schimmel, stevenmschimmel@gmail.com
% Copyright 2009, University of Zurich
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of ROOMSIM.
%
% ROOMSIM is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version. 
%
% ROOMSIM is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with ROOMSIM. If not, see <http://www.gnu.org/licenses/>.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% version = '1.00a';
% buildnr = '2731';
% date = '20090423';

% Set default switches
switches = { '-DMEX'
             '-DLOGLEVEL=0'
             '-DMEXP=19937'
             '-I.\'
             '-Iwebrtc\rtc_base\numerics'
           };
options = { ''
            ''
          };
output = 'mwebrtcvad';       

mexfiles = { 'webrtc\common_audio\vad\webrtc_vad.c'
             'webrtc\common_audio\vad\vad_core.c'
             'webrtc\common_audio\vad\vad_filterbank.c'
             'webrtc\common_audio\vad\vad_gmm.c'
             'webrtc\common_audio\vad\vad_sp.c'
             'webrtc\common_audio\signal_processing\spl_init.c'
             'webrtc\common_audio\signal_processing\spl_inl.c'
             'webrtc\common_audio\signal_processing\division_operations.c'
             'webrtc\common_audio\signal_processing\resample_48khz.c'
             'webrtc\common_audio\signal_processing\min_max_operations.c'
             'webrtc\common_audio\signal_processing\cross_correlation.c'
             'webrtc\common_audio\signal_processing\resample_by_2_internal.c'
             'webrtc\common_audio\signal_processing\downsample_fast.c'
             'webrtc\common_audio\signal_processing\get_scaling_square.c'
             'webrtc\common_audio\signal_processing\resample_fractional.c'
             'webrtc\common_audio\signal_processing\complex_bit_reverse.c'
             'webrtc\common_audio\signal_processing\energy.c'
             'webrtc\common_audio\signal_processing\vector_scaling_operations.c'
             'webrtc\common_audio\signal_processing\complex_fft.c'
             'webrtc\common_audio\signal_processing\complex_fft.c'
             'webrtc\common_audio\signal_processing\complex_fft.c'
             'mwebrtcvad.cpp'
           };
       
% distribfiles = { 'roomsim.mexw32'
%                  'roomsim.exe'
%                  'libfftw3-3.dll'
%                  'roomsim.m'
%                  'sampleroomsetup.m'
%                  'example.m'
%                  'editabsorption.m'
%                  'estimateroombreakfreq.m'
%                  'estimateRT60.m'
%                  'loadsurface.m'
%                  'mit2hrtf.m'
%                  'near.m'
%                  'placesensor.m'
%                  'plotabsorption.m'
%                  'plotbinsignal.m'
%                  'plotbrir.m'
%                  'plotbrtf.m'
%                  'plotcoordsystem.m'
%                  'plotroom.m'
%                  'plotRT60.m'
%                  'plotsignal.m'
%                  'readbrir.m'
%                  'readsetup.m'
%                  'roomsim_sd.m'
%                  'rsound.m'
%                  'schroederplot.m'
%                  'selectabsorption.m'
%                  'setcomplexity.m'
%                  'spec.m'
%                  'yprTs2r.m'
%                  'yprTr2s.m'
%                  'data\testsignal.mat'
%                  'data\materials.mat'
%                  'data\MIT\KEMARsmall.hrtf'
%                };
           
% % handle single 'distrib' argument
% if nargin==1 && ischar(varargin{1}) && strcmpi(varargin{1},'distrib')==1,
%     addpath('source\Release');
%     zip(['roomsim_v' version '_build' buildnr '_' date '.zip'],distribfiles);
%     return;
% end;

% Process optional arguments
for i = 1:nargin,
    switch varargin{i}
        case 'test'
            switches{end+1} = '-DUNIT_TEST';
            output = 'roomsimtest';
        case 'debug'
            switches{end+1} = '-g';
        otherwise
            switches{end+1} = varargin{i};
    end;
end;

% remove roomsim from memory, if loaded
clear roomsim;

% Echo command to be executed
fprintf('mex '); 
fprintf('%s ', switches{:});
fprintf('-output %s ', output);
fprintf('%s ', mexfiles{:});
fprintf('%s ', options{:});
fprintf('\n');

% Run MEX to build the desired target
err = 0;
mex(switches{:},'-output',output,mexfiles{:},options{:});

% Continue making the build 
% if ~err && makebuild,
% end;
