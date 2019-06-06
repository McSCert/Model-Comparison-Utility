function num = getNumBlocksAdded(root)
% GETNUMBLOCKSADDED Count the number of blocks added, starting at the root.
%
%   Inputs:
%       root    xmlcomp.Edits object.
%
%   Outputs:
%       num     Total blocks added.

    num = numBlocksAdded(root.RightRoot);
end

function num = numBlocksAdded(node)
% NUMBLOCKSADDED Count the number of blocks added.

    isAdded = isempty(node.Partner);
    
    if isAdded && isBlock(node)
        num = 1;
    else
        num = 0;
    end
    
    if ~hasChildren(node)
        return;
    end
    
    for i = 1:length(node.Children)
        num = num + numBlocksAdded(node.Children(i));
    end
end