function [path, name] = getNameFromPath(pathname)
% GETNAMEFROMPATH Speparate the name and path of a model element's pathname. 
% When using the fileparts function, forwardslashes cause the name of the
% element to be incorrect. This function gets the correct name of the
% element, if the forwardspash is escaped.
%
%   Inputs:
%       pathname    Char array.
%
%   Outputs:
%       path        Path as a char array.
%       name        Name of the element as a char array.
%
%   Example:
%       [path_bad, name_bad] = fileparts('Comparison Root/Simulink/Subsystem/Reset 1//z blocks')
%       path_bad =
%           'Comparison Root/Simulink/Subsystem/Reset 1/'
%
%       name_bad =
%           '/z blocks'
%
%       [path_correct, name_correct] = getNameFromPath('Comparison Root/Simulink/Subsystem/Reset 1//z blocks')
%       path_correct =
%           'Comparison Root/Simulink/Subsystem'
%
%       name_correct =
%           'Reset 1/z blocks'

    name = '';
    i = length(pathname);
    while i > 1
        thischar = pathname(i);
        nextchar = pathname(i-1);

        if strcmp(thischar, '/') && ~strcmp(nextchar, '/') % Regular / encountered
            break;
        elseif strcmp(thischar, '/') && strcmp(nextchar, '/') % Escaped / encountered
            name = [thischar name]; % Add to front
            i = i - 2; % Skip the second /
        else % Regular character
            name = [thischar name]; % Add to front
            i = i - 1;
        end
    end
    path = pathname(1:i-1);
end