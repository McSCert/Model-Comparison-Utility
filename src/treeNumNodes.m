function n = treeNumNodes(node)
% TREENUMNODES Get the number of nodes in the comparison tree. This includes
%   all nodes (e.g. Comparison Root, etc.) but not xmlcomp.Edits.
%
%   Inputs:
%       node    xmlcomp.Edits or xmlcomp.Node object.
%
%   Outputs:
%       n       Number of nodes.
    
    if isa(node, 'xmlcomp.Node')
        %fprintf("%s\n", strrep(node.Name, newline, ' ')); % Print name
        n = 1;
        if ~hasChildren(node)
            return
        end

        for i = 1:numel(node.Children)
            n = n + treeNumNodes(node.Children(i));
        end
    elseif isa(node, 'xmlcomp.Edits')
        %fprintf("xmlcomp.Edits\n"); % Print name
        n = 0;
        n = n + treeNumNodes(node.LeftRoot);
        n = n + treeNumNodes(node.RightRoot);
    else
        message = 'Node argument must be an xmlcomp.Edits or xmlcomp.Node object.';
        error(message)
    end
end