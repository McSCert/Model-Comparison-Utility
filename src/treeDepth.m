function d = treeDepth(node)
% TREEDEPTH Get the depth of the comparison tree.
%
%   Inputs:
%       node    xmlcomp.Node object at which to start the depth finding.
%
%   Outputs:
%       d       Depth.
    
    d = 0;
    if ~hasChildren(node)
        return;
    end
    
    for i = 1:length(node.Children)
        d = max(d, treeDepth(node.Children(i)));
    end
    
    if ~strcmp(node.Name, 'Comparison Root')
        d = d + 1;
    end
end