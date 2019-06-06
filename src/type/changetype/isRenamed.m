function out = isRenamed(node)
% ISRENAMED Determine if the node has been renamed. A renamed node is one 
%   with a corresponding element in the model against which it is being
%   compared, but does not have the same name.
%
%   Inputs:
%       node    xmlcomp.Node object.
%
%   Outputs:
%       out     Whether the node has been renamed(1) or not(0).

    % Validate inputs
    try
        assert(isa(node, 'xmlcomp.Node'))
    catch
        message = 'Node argument must be an xmlcomp.Node object.';
        error(message)
    end

    % Note: Renamed nodes are not necessarily flagged as Edited. They are
    % treated as two different nodes.
    
    out = false;
    if ~isempty(node.Partner) && ~strcmp(node.Name, node.Partner.Name)
        out = true;
    end
end