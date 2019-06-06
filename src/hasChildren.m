function c = hasChildren(node)
% HASCHILDREN Determine if the node has children.
%
%   Inputs:
%       node    xmlcomp.Node object.
%
%   Outputs:
%       c       Whether the node has children(1) or not(0).

    try
        c = ~isempty(node.Children);
    catch
        c = false;
    end
end