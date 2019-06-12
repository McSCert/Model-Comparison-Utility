function highlightNodes(nodes, sys, varargin)
% HIGHLIGHTNODES Color model elements corresponding to nodes from the comparison tree.
%
%   Inputs:
%       nodes       xmlcomp.Edits objects or handles. 
%       sys         Path or name of the model.
%       varargin:
%           fg      Matlab color for foreground. Default is red.
%           bg      Matlab color for background. Default is yellow.
%           method  Use built-in Simulink hilite(1) instead of setting ForegroundColor
%                   and BackgroundColor  parameters(0). Note that hilite(1) will 
%                   color subsystems if their CONTENTS are changed, not necessarily 
%                   when the subsystem itself is changed.  For this reason, the 
%                   default(0) method is more accurate.
%                   See comparison below.
%
%   Outputs:
%       N/A
%
%   HIGHLIGHTING METHOD COMPARISON
%   --------------------------------
%   0. Parameter Setting (Default)
%       - Only highlights SubSystem blocks when they are listed in the nodes argument 
%       - Can be saved in the model
%       - Overwrites previous coloring without the ability to undo
%           * To revert to previous highlighting, do not save, and then close and 
%             reopen the model
%       	* To revert to no highlighting, run: 
%               highlightNodes(nodes, sys, 'fg', 'black', 'bg', 'white')
%       - Can do highlighting on an opened model only
%  
%   1. Hilite
%       - Highlights SubSystem blocks when they are not modified themselves
%       - Disappears upon model close
%       - Does not overwrite existing coloring
%           * To undo, right-click in the model and select 'Remove Highlighting'
%       - Can do highlighting on a loaded model as well as an opened model

    try
        assert(strcmp(get_param(bdroot(sys), 'Lock'), 'off'));
    catch ME
        if strcmp(ME.identifier, 'MATLAB:assert:failed') || ...
                strcmp(ME.identifier, 'MATLAB:assertion:failed')
            error('Library is locked.')
        end
    end
    
    % Get inputs
    fgColor = getInput('fg', varargin);
    bgColor = getInput('bg', varargin);
    method  = getInput('method', varargin);
        
    if method
        assert(bdIsLoaded(sys), 'Model is not loaded.');
    else        
        assert(bdIsLoaded(sys) && strcmp(get_param(sys, 'Shown'), 'on'), 'Model is not opened.');
    end

    if isempty(fgColor)
        fgColor = 'red';
    end
    if isempty(bgColor)
        bgColor = 'yellow';
    end
      
    % If given Nodes instead of handles, get the handles
    if isa(nodes, 'xmlcomp.Node')
        hdls = zeros(1, length(nodes));
        for i = 1:length(nodes)
            try
                hdls(i) = getHandle(nodes(i), sys);
            catch
                hdls(i) = NaN;
            end
        end
        nodes = hdls(isfinite(hdls(:))); % Remove invalid hdls
    end
    
    % Highlight
    if method
        set_param(0, 'HiliteAncestorsData', ... 
                    struct('HiliteType', 'user2', ... 
                           'ForegroundColor', fgColor, ...
                           'BackgroundColor', bgColor)); 
       hilite_system_notopen(nodes, 'user2');
    else
        colorRegular(nodes, fgColor, bgColor);
    end
end

function colorRegular(hdls, fg, bg)
% COLORREGULAR Color model objects by setting their BackgroundColor
%   and ForegroundColor parameters.
%
%   Inputs:
%       hdls    Handle of model element.
%       fg      Matlab color for foreground.
%       bg      Matlab color for background.
%
%   Outputs:
%       N/A

    for i = 1:length(hdls)
        try
            set_param(hdls(i), 'BackgroundColor', bg);
        catch
            % hdl is not valid or does not have this parameter
        end
%         try
%             set_param(hdls(i), 'ForegroundColor', fg);
%         catch
%             % hdl is not valid of does not have this parameter
%         end
%         if strcmp(get_param(hdls(i), 'Type'), 'line')
%             set_param(hdls(i), 'HiliteAncestors', 'on')
%         end
    end
end