function num = getNumOutportsAdded(root)
% GETNUMOUTPORTSADDED Count the number of inports added, starting at the root.
%
%   Inputs:
%       root    xmlcomp.Edits object.
%
%   Outputs:
%       num     Total outputs added.

    num = numOutportsAdded(root.RightRoot);
end

function num = numOutportsAdded(node)
% NUMOUTPORTSADDED Count the number of outports added.

    isAdded = isempty(node.Partner);

    if isAdded && isOutport(node)
        num = 1;
    else
        num = 0;
    end
    
    if ~hasChildren(node)
        return;
    end
    
    for i = 1:length(node.Children)
        num = num + numOutportsAdded(node.Children(i));
    end
end