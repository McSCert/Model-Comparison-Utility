function out = isPort(node)
% ISPORT Determine if the node represents a port to a block, based on the tree
%   only (i.e. does not check the model).
%
%   See: getNodeType.m
%
%   Inputs:
%       node    xmlcomp.Node object.
%
%   Outputs:
%       out     Whether the node represents a port(1) or not(0).

    % Validate inputs
    try
        assert(isa(node, 'xmlcomp.Node'))
    catch
        message = 'Node argument must be an xmlcomp.Node object.';
        error(message)
    end
    
    % Can be identified simply by its name if the user does not specify one
    hasPortName = strcmp(node.Name, 'Port');
    
    % Named signals result in ports that don't have the generic Port name, but they have a port number
    hasPortNumber = any(strcmp({node.Parameters.Name}, 'PortNumber'));
    
    out = hasPortName || hasPortNumber;
end