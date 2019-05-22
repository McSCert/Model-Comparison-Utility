function out = getSubTree(node)
% GETSUBTREE Get the nodes of the subtree starting at some root node.
%
%   Inputs:
%       node    xmlcomp.Node object.
%
%   Outputs:
%       out     Node array.

    out = node;
    
    if ~hasChildren(node)
        return;
    end

    for i = 1:length(node.Children)
        out = [out; getSubTree(node.Children(i))];
    end 
end