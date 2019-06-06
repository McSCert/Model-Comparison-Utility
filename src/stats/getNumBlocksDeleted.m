function num = getNumBlocksDeleted(root)
% GETNUMBLOCKSDELETED Count the number of blocks deleted, starting at the root.
%
%   Inputs:
%       root    xmlcomp.Edits object.
%
%   Outputs:
%       num     Total blocks deleted.

    num = numBlocksDeleted(root.LeftRoot);
end

function num = numBlocksDeleted(node)
% NUMBLOCKSDELETED Count the number of blocks deleted.

    isDeleted = isempty(node.Partner);
    
    if isDeleted && isBlock(node)
        num = 1;
    else
        num = 0;
    end
    
    if ~hasChildren(node)
        return;
    end
    
    for i = 1:length(node.Children)
        num = num + numBlocksDeleted(node.Children(i));
    end
end