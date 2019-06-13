function branch = getBranch(node, root)
% GETBRANCH Find which branch of the tree the node is located in.
%
%   Inputs:
%       node    xmlcomp.Node object or xmlcomp.Node array.
%       root    xmlcomp.Edits object.
%
%   Outputs:
%       branch  Branch the node is in: left(0), right(1), both(2),
%               or not found (-1).
%
%   Example:
%       >> getBranch(Edits.LeftRoot.Children.Children.Children.Children(1), Edits)
%
%       ans =
%
%            1

    % Validate inputs
    try
        assert(isa(node, 'xmlcomp.Node'))
    catch
        message = 'Node argument must be an xmlcomp.Node object.';
        error(message)
    end

    try
        assert(isa(root, 'xmlcomp.Edits'))
    catch
        message = 'Root argument must be an xmlcomp.Edits object.';
        error(message)
    end

    branch = Branch.NotFound * ones(size(node)); % Default is 'not found'

    for i = 1:length(node)
        % Search in both branches
        inLeft = existsNode(node(i), root.LeftRoot);
        inRight = existsNode(node(i), root.RightRoot);

        if inLeft && inRight
            branch(i) = Branch.Both;
        elseif inRight
            branch(i) = Branch.Right;
        elseif inLeft
            branch(i) = Branch.Left;
        else
            branch(i) = Branch.NotFound;
        end
    end
end

function found = existsNode(node, branchNode)
% EXISTSNODE Determine the existence of the node in the tree branch.
%
%   Inputs:
%       node        xmlcomp.Node object.
%       branchNode  LeftRoot or RightRoot of xmlcomp.Edits object.
%
%   Outputs:
%       found	    Whether the node is found(1) or not(0).

    % Exact match
    found = (node == branchNode);
    if found
        return
    end

    % Non-exact match for modified elements
    found = nodecmp(node, branchNode);
    if found
        return
    end

    % Base case
    if ~hasChildren(branchNode)
        return
    end

    % Recursive case
    for i = 1:length(branchNode.Children)
        found = existsNode(node, branchNode.Children(i));
        if found
            return
        end
    end
end