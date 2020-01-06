function [nodes, changetype, nodetype, blocktype] = classifyChanges(root)
    
    % Validate inputs
    try
        assert(isa(root, 'xmlcomp.Edits'))
    catch
        message = 'Node argument must be an xmlcomp.Edits object.';
        error(message)
    end
    
    % Find all nodes that are actual changes
    nodes = find_node(root, 'ChangeType', {'added', 'deleted', 'modified', 'renamed'});
    
    % Initialize outputs
    changetype = cell(size(nodes));
    nodetype   = cell(size(nodes));
    blocktype  = cell(size(nodes));
    
    % For each change
    for i = 1:length(nodes)
        changetype{i} = getNodeChangeType(nodes(i), root);
        
        % Get handle in model
        hdl = getHandle(nodes(i), root.LeftFileName);
        if isempty(hdl)
            hdl = getHandle(nodes(i), root.RightFileName);
        end
        
        % Get node type
        nodetype{i} = get_param(hdl, 'Type');
                
        % Get block type
        if strcmp(nodetype{i}, 'block')
            blocktype{i} = get_param(hdl, 'BlockType');
        else
            blocktype{i} = '';
        end
    end
end