function added = isAdded(node, root)
% ISADDED Determine if the node has been added. An added node is one that 
%   is in the right branch, without a corresponding element in the left branch.
%
%   Inputs:
%       node    xmlcomp.Node object.
%       root    xmlcomp.Edits object.
%
%   Outputs:
%       added	Whether the node has been added(1) or not(0).

    % Validate inputs
    try
        assert(isa(node, 'xmlcomp.Node'))
    catch
        message = 'Node argument must be an xmlcomp.Node object.';
        error(message)
    end
 
    try
        assert(isa(root, 'xmlcomp.Edits'))
    catch
        message = 'Root argument must be an xmlcomp.Edits object.';
        error(message)
    end

    % Note: Added nodes are are flagged as Edited, but so are deleted
    % nodes, so this is not a reliable way of determining if the node is added.
    
    added = false;
    
    if ~isempty(node.Partner)
        return
    end

    % If in the right branch only
    if (getBranch(node, root) == 1)
        added = true;
    end  
end