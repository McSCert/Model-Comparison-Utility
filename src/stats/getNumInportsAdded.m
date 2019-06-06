function num = getNumInportsAdded(root)
% GETNUMINPORTSADDED Count the number of inports added, starting at the root.
%
%   Inputs:
%       root    xmlcomp.Edits object.
%
%   Outputs:
%       num     Total inputs added.

    num = numInportsAdded(root.RightRoot);
end

function num = numInportsAdded(node)
% NUMINPORTSADDED Count the number of inputs added.

    isAdded = isempty(node.Partner);

    if isAdded && isInport(node)
        num = 1;
    else
        num = 0;
    end
    
    if ~hasChildren(node)
        return;
    end
    
    for i = 1:length(node.Children)
        num = num + numInportsAdded(node.Children(i));
    end
end