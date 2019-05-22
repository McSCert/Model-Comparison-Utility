function num = getNumRenamed(root)
% GETNUMRENAMED Count the number of elements renamed, starting at the root.
%
%   Inputs:
%       root    xmlcomp.Edits object.
%
%   Outputs:
%       num     Total elements renamed.

    num = numRenamed(root.RightRoot); % Doesn't matter which branch
end

function num = numRenamed(node)
% NUMRENAMED Count the number of elements renamed.

    if isRenamed(node)
        num = 1;
    else
        num = 0;
    end
    
    if ~hasChildren(node)
        return;
    end
    
    for i = 1:length(node.Children)
        num = num + numRenamed(node.Children(i));
    end
end