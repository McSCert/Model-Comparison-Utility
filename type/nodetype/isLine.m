function out = isLine(node)
% ISLINE Determine if the node represents a line, based on the tree
%   only (i.e. does not check the model).
%
%   See: getNodeType.m
%
%   Inputs:
%       node    xmlcomp.Node object.
%
%   Outputs:
%       l       Whether the node represents a line(1) or not(0).

    % Validate inputs
    try
        assert(isa(node, 'xmlcomp.Node'))
    catch
        message = 'Node argument must be an xmlcomp.Node object.';
        error(message)
    end
    
    % Can be identified simply by its name
    out = contains(node.Name, '->');
end