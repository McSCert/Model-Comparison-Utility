function path = getPathTree(node)
% GETPATHTREE Get the path of the node in the comparison tree.
%   Note: Cannot go back past 'Comparison Root' because these is no Parent
%   link between 'Comparison Root' and the Edits object.
%
%   Whereas the getPath function gets the path in the model, this function 
%   gets the path in tree, and shows the tree-specific nodes (e.g.
%   Comparison Root)
% 
%   Inputs:
%       node    xmlcomp.Node object for which to find the path.
%
%   Outputs:
%       path    Path of node in the comparison tree.

    % Validate inputs
    try
        assert(isa(node, 'xmlcomp.Node'))
    catch
        message = 'Node argument must be an xmlcomp.Node object.';
        error(message)
    end
    
    % Go up through the parents
    node_i = node;
    path = strrep(node.Name, '/', '//');
    while ~isempty(node_i.Parent)
        parentNameInSimPath = strrep(node_i.Parent.Name, '/', '//');
        path = [parentNameInSimPath '/' path]; % Add to path
        node_i = node_i.Parent; % Goto next
    end
end