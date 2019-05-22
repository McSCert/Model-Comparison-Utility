function printChildren(node)
% PRINTCHILDREN Print to the command window the names of all children.
%
%   Inputs:
%       node    xmlcomp.Node object for which to print children.
%
%   Outputs:
%       N/A

    try
        assert(isa(node, 'xmlcomp.Node'))
    catch
        message = 'Node argument must be an xmlcomp.Node object.';
        error(message)
    end
    
    for i = 1:length(node.Children)
        fprintf('%d %s\n', i, node.Children(i).Name)
    end
end