function node = getNode(hdl, root)
% GETNODE Determine the node(s) associated with a model element, such as a block,
%   line, or annotation, etc. If a node has been modified, or is in the tree to
%   retain hierarchy, two nodes will be returned.
%
%   Inputs:
%       hdl     Handle of a model element.
%       root    xmlcomp.Edits object.
%
%   Outputs:
%       node    xmlcomp.Node object.
%
%   Example:
%       >> getNode(gcls, Edits)
%           ans = 
%
%           Node with properties:
%               Children: []
%                 Edited: 1
%                   Name: 'Integrator:1 -> Out2:1'
%             Parameters: [1×6 struct]
%                 Parent: [1×1 xmlcomp.Node]
%                Partner: []
    
    model1 = root.LeftFileName;
    model2 = root.RightFileName;
    allnodes = find_node(root);
    node = [];
    for i = 1:length(allnodes)
        handle1_node = getHandle(allnodes(i), model1);
        handle2_node = getHandle(allnodes(i), model2);
        if handle1_node == hdl
            node(1) = allnodes(i);
        end
        if handle2_node == hdl
            node = [node; allnodes(i)];
        end
    end
end