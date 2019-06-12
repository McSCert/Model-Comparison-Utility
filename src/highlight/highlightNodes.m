function highlightNodes(nodes, sys, varargin)
% HIGHLIGHTNODES Remove colors in a model and color only the specificed
%   model elements corresponding to nodes from the comparison tree.
%
%   Inputs:
%       nodes       xmlcomp.Edits objects or handles. 
%       sys         Path or name of the model.
%       varargin:
%           fg      Matlab color for foreground.
%           bg      Matlab color for background.
%           param   Use block parameter to color blocks(1) instead of
%                   built-in Simulink hilite(0). Setting the parameter allows
%                   the coloring to be saved.
%
%   Outputs:
%       N/A

    try
        assert(strcmp(get_param(bdroot(sys), 'Lock'), 'off'));
    catch ME
        if strcmp(ME.identifier, 'MATLAB:assert:failed') || ...
                strcmp(ME.identifier, 'MATLAB:assertion:failed')
            error('Library is locked.')
        end
    end
    
    % Validate inputs
    fgColor = getInput('fg', varargin);
    bgColor = getInput('bg', varargin);
    useParam = getInput('param', varargin);
    
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
    if (nargin > 4) && useParam
        hilite_regular(nodes, bgColor);
    else
        set_param(0,'HiliteAncestorsData',... 
                    struct('HiliteType','user1',... 
                           'ForegroundColor', fgColor, 'BackgroundColor', bgColor)); 
       hilite_system_notopen(nodes, 'user1')
    end
end

function hilite_regular(hdl, color)
% HILITE_REGULAR Highlight model objects by setting their BackgroundsColor
%   parameter.

    for i = 1:length(hdl)
        try
            set_param(hdl(i), 'BackgroundColor', color);
        catch
            % hdl is not valid
        end
    end
end