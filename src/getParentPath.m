function path = getParentPath(node, sys)
% GETPARENTPATH Get the path of the parent element containing the node 
%   in a model (usually a subsystem, or the root system). This is non-trivial for
%   nodes representing lines, hence this function. Note: The parent of a port is the source block.
% 
%   Inputs:
%       node    xmlcomp.Node object.
%       sys     Path or name of the model.
%
%   Outputs:
%       path    Path of the parent.

    % Validate inputs
    try
        assert(isa(node, 'xmlcomp.Node'))
    catch
        message = 'Node argument must be an xmlcomp.Node object.';
        error(message)
    end
    
    if isLine(node)
        % Line segments have the tree trunk as parents, so trace through them
        % all until we hit a block
        parent = node.Parent;
        while isLine(parent)
            parent = parent.Parent;
        end
    else
        parent = node.Parent;
    end
     
    path = getPath(parent, char(sys));
    
    % Deal with duplicated elements in earlier versions
    if strcmp(version('-release'), '2016b') && isempty(path)
        if strcmp(parent.Name, parent.Parent.Name)
            path = getPath(parent.Parent, char(sys));
        end
    end
end