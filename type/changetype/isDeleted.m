function deleted = isDeleted(node, root)
% ISDELETED Determine if the node has been deleted. A removed node is one that 
%   is in the left branch, without a corresponding element in the right branch.
%
%   Inputs:
%       node    xmlcomp.Node object.
%       root    xmlcomp.Edits object.
%
%   Outputs:
%       deleted     Whether the node has been deleted(1) or not(0).

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

    % Note: Deleted nodes are are flagged as Edited, but so are added
    % nodes, so this is not a reliable way of determining if the node is added.
    
    deleted = false;
    
    if ~isempty(node.Partner)
        return
    end

    % If in the left branch only
    if (getBranch(node, root) == 0)
        deleted = true;
    end  
end