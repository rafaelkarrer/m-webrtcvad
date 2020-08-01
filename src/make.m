function make(varargin)
% MAKE Build mex-webrtcvad project
%   MAKE without arguments builds the mex-webrtcvad project
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Rafael Karrer, rafael.karrer.mail@gmail.com
% Copyright 2020, 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of mex-webrtcvad.
%
% mex-webrtcvad is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version. 
%
% mex-webrtcvad is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with mex-webrtcvad. If not, see <http://www.gnu.org/licenses/>.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
output = 'mexwebrtcvad';       

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
             'mexwebrtcvad.cpp'
           };

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
