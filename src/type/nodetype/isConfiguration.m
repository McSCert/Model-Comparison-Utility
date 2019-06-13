function out = isConfiguration(node)
% ISCONFIGURATION Determine if the node represents a model configuration parameter,
%   based on the tree only (i.e. does not check the model).
%
%   See: getNodeType.m
%
%   Inputs:
%       node    xmlcomp.Node object.
%
%   Outputs:
%       out     Whether the node represents a configuration(1) or not(0).

    % Validate inputs
    try
        assert(isa(node, 'xmlcomp.Node'))
    catch
        message = 'Node argument must be an xmlcomp.Node object.';
        error(message)
    end
    
    % Can be identified if any ancestor is
    path = getPathTree(node);
    parent = strfind(path, '/Model Configuration Sets/');
    if ~isempty(parent)
    	out = true;
    else
        out = false;
    end
end