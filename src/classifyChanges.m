function [nodes, path, changeType, nodeType, blockType] = classifyChanges(root)
    
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
    changeType = cell(size(nodes));
    path       = cell(size(nodes));
    nodeType   = cell(size(nodes));
    blockType  = cell(size(nodes));
    
    % For each change
    for i = 1:length(nodes)
        changeType{i} = getNodeChangeType(nodes(i), root);
        
        % Get handle in model
        hdl = getHandle(nodes(i), root.LeftFileName);
        if isempty(hdl)
            hdl = getHandle(nodes(i), root.RightFileName);
        end
        
        % Get path in model
        path{i} = getfullname(hdl);
        if isempty(path{i})
            path{i} = '';
        end
        
        % Get node type
        nodeType{i} = get_param(hdl, 'Type');
        if isempty(nodeType{i})
            nodeType{i} = getNodeType(nodes(i), root.LeftFileName);
        end
        if isempty(nodeType{i})
            nodeType{i} = getNodeType(nodes(i), root.RightFileName);
        end
        if isempty(nodeType(i))
            nodeType{i} = '';
        end
        
        % Get block type
        if strcmp(nodeType{i}, 'block')
            blockType{i} = get_param(hdl, 'BlockType');
        else
            blockType{i} = '';
        end
    end
end