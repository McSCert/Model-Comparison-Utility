function num = getNumSubsystemsAdded(root)
% GETNUMSUBSYSTEMSADDED Count the number of subsystems added, starting at the root.
%
%   Inputs:
%       root    xmlcomp.Edits object.
%
%   Outputs:
%       num     Total subsystems added.

    num = numSubsystemsAdded(root.RightRoot);
end

function num = numSubsystemsAdded(node)
% NUMSUBSYSTEMSADDED Count the number of subsystems added.

    isAdded = isempty(node.Partner);

    if isAdded && isSubsystem(node)
        num = 1;
    else
        num = 0;
    end
    
    if ~hasChildren(node)
        return;
    end
    
    for i = 1:length(node.Children)
        num = num + numSubsystemsAdded(node.Children(i));
    end
end