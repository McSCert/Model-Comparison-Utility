function out = isChildrenModified(node, root)
% ISCHILDRENMODIFIED Check if the subsystem contains
%   added/deleted/modified/renamed direct child elements. Does not 
%   recursively check a subsystem's children's children, etc.
%
%   Inputs:
%       node    xmlcomp.Node object.
%       root    xmlcomp.Edits object.
%
%   Outputs:
%       out     Whether the contents have been modified(1) or not(0).

    out = false;
    
    for i = 1:length(node.Children)
        child = node.Children(i);
        
        if isPort(child) % Skip ports because they aren't useful
            continue
        end
        
        if isModified(child)
            out = true;
            %fprintf('Modified: %s (Child %i)\n', child.Name, i)
            return
        elseif isRenamed(child)
            out = true;
            %fprintf('Renamed: %s (Child %i)\n', child.Name, i)
            return
        elseif isAdded(child, root) 
            out = true;
            %fprintf('Added: %s (Child %i)\n', child.Name, i)
            return
        elseif isDeleted(child, root)
            out = true;
            %fprintf('Deleted: %s (Child %i)\n', child.Name, i)
            return
        end
    end
end