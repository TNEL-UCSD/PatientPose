function [result, status] = python(varargin)
%python Execute python command and return the result.
%   python(PERLFILE) calls python script specified by the file PERLFILE
%   using appropriate python executable.
%
%   python(PERLFILE,ARG1,ARG2,...) passes the arguments ARG1,ARG2,...
%   to the python script file PERLFILE, and calls it by using appropriate
%   python executable.
%
%   RESULT=python(...) outputs the result of attempted python call.  If the
%   exit status of python is not zero, an error will be returned.
%
%   [RESULT,STATUS] = python(...) outputs the result of the python call, and
%   also saves its exit status into variable STATUS.
%
%   If the python executable is not available, it can be downloaded from:
%     http://www.cpan.org
%
%   See also SYSTEM, JAVA, MEX.

%   Copyright 1990-2012 The MathWorks, Inc.
    
cmdString = '';

% Add input to arguments to operating system command to be executed.
% (If an argument refers to a file on the MATLAB path, use full file path.)
for i = 1:nargin
    thisArg = varargin{i};
    if ~ischar(thisArg)
        error(message('MATLAB:python:InputsMustBeStrings'));
    end
    if i==1
        if exist(thisArg, 'file')==2
            % This is a valid file on the MATLAB path
            if isempty(dir(thisArg))
                % Not complete file specification
                % - file is not in current directory
                % - OR filename specified without extension
                % ==> get full file path
                thisArg = which(thisArg);
            end
        else
            % First input argument is PerlFile - it must be a valid file
            error(message('MATLAB:python:FileNotFound', thisArg));
        end
    end

    % Wrap thisArg in double quotes if it contains spaces
    if isempty(thisArg) || any(thisArg == ' ')
        thisArg = ['"', thisArg, '"']; %#ok<AGROW>
    end

    % Add argument to command string
    cmdString = [cmdString, ' ', thisArg]; %#ok<AGROW>
end

% Execute python script
if isempty(cmdString)
    error(message('MATLAB:python:NoPerlCommand'));
elseif ispc
    % PC
    if(isdeployed)
        % Check to see if python is on the path. 
        % If it isn't, this will return a non 0 status
        [status, ~] = dos('python -v');
        if(status ~=0)
            error(message('MATLAB:python:NoExecutable'));
        end 
    end
    perlCmd = fullfile(matlabroot, 'sys\python\win32\bin\');
    cmdString = ['python' cmdString];
    perlCmd = ['set PATH=',perlCmd, ';%PATH%&' cmdString];
    [status, result] = dos(perlCmd);
else
    % UNIX
    [status, ~] = unix('which python');
    if (status == 0)
        cmdString = ['python', cmdString];
        [status, result] = unix(cmdString);
    else
        error(message('MATLAB:python:NoExecutable'));
    end
end

% Check for errors in shell command
if nargout < 2 && status~=0
    error(message('MATLAB:python:ExecutionError', result, cmdString));
end

