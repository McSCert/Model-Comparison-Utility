function type = getNodeChangeType(node, root)
% GETNODECHANGETYPE Determine the type of change that the node represents in
%   the tree: added, deleted, renamed, modified, or none. For more information
%   on what each of these mean, see the isAdded, isDeleted, isRenamed, or 
%   isModified functions.
%
%   Inputs:
%       node    xmlcomp.Node object.
%       root    xmlcomp.Edits object.
%
%   Outputs:
%       type	The type of change.

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

    if isRenamed(node) && ~isModified(node)
        type = 'renamed';
    elseif isRenamed(node) && isModified(node)
        type = {'renamed', 'modified'};
    elseif isModified(node)
        type = 'modified';
    elseif isAdded(node, root)
        type = 'added';
    elseif isDeleted(node, root)
        type = 'deleted';
    else
        type = 'none';
    end
end