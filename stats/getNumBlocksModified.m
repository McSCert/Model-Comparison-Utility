function num = getNumBlocksModified(root)
% GETNUMBLOCKSMODIFIED Count the number of blocks modified, starting at the root.
%
%   Inputs:
%       root    xmlcomp.Edits object.
%
%   Outputs:
%       num     Total blocks modified.

    num = numBlocksModified(root.RightRoot);
end

function num = numBlocksModified(node)
% NUMBLOCKSMODIFIED Count the number of blocks modified.

    if isModified(node) && isBlock(node)
        num = 1;
    else
        num = 0;
    end
    
    if ~hasChildren(node)
        return;
    end
    
    for i = 1:length(node.Children)
        num = num + numBlocksModified(node.Children(i));
    end
end