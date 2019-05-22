function num = getNumSubsystemsDeleted(root)
% GETNUMSUBSYSTEMSDELETED Count the number of subsystems deleted, starting at the root.
%
%   Inputs:
%       root    xmlcomp.Edits object.
%
%   Outputs:
%       num     Total subsystems deleted.

    num = numSubsystemsDeleted(root.LeftRoot);
end

function num = numSubsystemsDeleted(node)
% NUMSUBSYSTEMSDELETED Count the number of subsystems deleted.

    isDeleted = isempty(node.Partner);

    if isDeleted && isSubsystem(node)
        num = 1;
    else
        num = 0;
    end
    
    if ~hasChildren(node)
        return;
    end
    
    for i = 1:length(node.Children)
        num = num + numSubsystemsDeleted(node.Children(i));
    end
end