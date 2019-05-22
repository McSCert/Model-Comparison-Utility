function num = getNumOutportsDeleted(root)
% GETNUMOUTPORTSDELETED Count the number of outports deleted, starting at the root.
%
%   Inputs:
%       root    xmlcomp.Edits object.
%
%   Outputs:
%       num     Total outputs deleted.

    num = numOutportsDeleted(root.RightRoot);
end

function num = numOutportsDeleted(node)
% NUMOUTPORTSDELETED Count the number of outports deleted.

    isDeleted = isempty(node.Partner);

    if isDeleted && isOutport(node)
        num = 1;
    else
        num = 0;
    end
    
    if ~hasChildren(node)
        return;
    end
    
    for i = 1:length(node.Children)
        num = num + numOutportsDeleted(node.Children(i));
    end
end