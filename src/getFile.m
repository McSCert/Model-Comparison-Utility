function files = getFile(node, root)
% GETFILE Find which file the node is located in.
%
%   Inputs:
%       node    xmlcomp.Node object or xmlcomp.Node array.
%       root    xmlcomp.Edits object.
%
%   Outputs:
%       files   One or more file paths.

    branch = getBranch(node, root);

    if branch == Branch.Left
        files = root.LeftFileName;
    elseif branch == Branch.Right
        files = root.RightFileName;
    elseif branch == Branch.Both
        files = {root.LeftFileName; root.RightFileName};
    else
        files = [];
    end
end 