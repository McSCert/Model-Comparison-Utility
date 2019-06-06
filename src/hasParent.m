function p = hasParent(node)
% HASPARENT Determine if the node has a parent.
%
%   Inputs:
%       node    xmlcomp.Node object.
%
%   Outputs:
%       c       Whether the node has a parent(1) or not(0).

    try
        p = ~isempty(node.Parent);
    catch
        p = false;
    end
end