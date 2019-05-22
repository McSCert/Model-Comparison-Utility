function num = getNumInportsDeleted(root)
% GETNUMINPORTSDELETED Count the number of inports deleted, starting at the root.
%
%   Inputs:
%       root    xmlcomp.Edits object.
%
%   Outputs:
%       num     Total inputs deleted.

    num = numInportsDeleted(root.LeftRoot);
end

function num = numInportsDeleted(node)
% NUMINPORTSDELETED Count the number of inports deleted.

    isDeleted = isempty(node.Partner);

    if isDeleted && isInport(node)
        num = 1;
    else
        num = 0;
    end
    
    if ~hasChildren(node)
        return;
    end
    
    for i = 1:length(node.Children)
        num = num + numInportsDeleted(node.Children(i));
    end
end