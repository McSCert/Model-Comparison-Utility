function [nodes, path] = find_node(root, varargin)
% FIND_NODE Search the comparison tree for nodes.
%   Note1: LeftRootFile and RightRootFile must be loaded/opened.
%   Note2: Does not return the xmlcomp.Edits objects itself.
%
%   Inputs:
%       root        xmlcomp.Edits object.
%       varargin    Search constraint as a 'Name', 'Value' pair. See below.
%
%   Outputs:
%       nodes       Node array of xmlcomp.Node objects.
%       path        Cell array of node paths in the comparison tree (not
%                   model paths).
%
%   Usage:
%       nodes = FIND_NODE(ROOT, 'CONSTRAINT1', 'VALUE1', ...)
%       constrains the search of FIND_NODES to the specified constraint/value
%       pairs (not case-sensitive, except for NodeName). The following describes 
%       the available constraint/value pairs:
%
%       NodeType	['block' | 'line' | 'port' | 'annotation' | 'mask' | 'block_diagram' | ...]
%       ChangeType	['added' | 'deleted' | 'modified' | 'renamed' | 'none']
%       BlockType	['SubSystem' | 'Inport' | 'Outport' | ...]
%       NodeName    <Node.Name>
%       FirstOnly   [('off'), 'on']     For changes with 2 nodes (e.g., none, modified), 
%                                       returns the first 'before' node. This is
%                                       useful for counting nodes.
%
%       Multiple values for a single constraint can be provided via a cell array.
%
%   Example:
%       >> allNodes = find_node(Edits)
%
%           allNodes = 
%
%               27×1 Node array with properties:
%
%                   Children
%                   Edited
%                   Name
%                   Parameters
%                   Parent
%                   Partner

    % Validate inputs
    try
        assert(isa(root, 'xmlcomp.Edits'))
    catch
        message = 'Node argument must be an xmlcomp.Edits object.';
        error(message)
    end

    % Parse varargin
    changeType = lower(getInput('ChangeType', varargin));
    firstOnly = lower(getInput('FirstOnly', varargin, 'off'));

    % Find the nodes
    % Don't have to check both branches, depending on the ChangeType:
    % 1) Check RIGHT branch for Added, Modified, Renamed
    % 2) Check LEFT branch for Deleted, Modified, Renamed
    % 3) Check BOTH if no ChangeTypes or None
    nodesFoundLeft = [];
    nodesFoundRight = [];
    if isempty(changeType) || any(ismember(changeType, {'none', 'added', 'modified', 'renamed'}))
        nodesFoundRight = findNode(root.RightRoot, root, root.RightFileName, varargin);
    end
    
    if strcmp(firstOnly, 'off')
        if isempty(changeType) || any(ismember(changeType, {'none', 'deleted', 'modified', 'renamed'}))
           nodesFoundLeft = findNode(root.LeftRoot, root, root.LeftFileName, varargin);
        end
    else
        if isempty(changeType) || any(ismember(changeType, {'none', 'deleted'}))
            varargin{2} = {'added', 'deleted'};
            nodesFoundLeft = findNode(root.LeftRoot, root, root.LeftFileName, varargin);
        end
    end
    nodes = [nodesFoundLeft; nodesFoundRight]; % Combine node lists in case both sides were checked

    % Get paths of the found nodes
    if nargout > 1
        path = cell(length(nodes),1);
        for i = 1:length(nodes)
            try
                path{i} = getPathTree(nodes(i));
            catch
                path{i} = '';
            end
        end
    end
end

function out = findNode(node, root, file, varargin)
% FINDNODE Recurse through the tree to find the node.
%
%   Inputs:
%       node      xmlcomp.Node object at which to start the search.
%       root      xmlcomp.Edits object.
%       file      RightFileName or LeftFileName to search in.
%       varargin  Search constraints.
%
%   Outputs:
%       out       xmlcomp.Node objects that are found to satisfy the constraints.

    % Parse varargin
    varargin   = varargin{:}; % Remove nesting cells from passing varargin in
	nodeType   = lower(getInput('NodeType', varargin));
    changeType = lower(getInput('ChangeType', varargin));
    blockType  = lower(getInput('BlockType', varargin));
    nameValue  = getInput('NodeName', varargin);

    % Check against varargin constraints
    meetsConstraints = true;

    if ~isempty(nodeType)
        if iscell(nodeType)
            isNodeType = ismember(nodeType, lower(getNodeType(node, file)));
        else
            isNodeType = strcmpi(nodeType, getNodeType(node, file));
        end
        
        if ~any(isNodeType)
            meetsConstraints = false;
        end
    end

    if ~isempty(changeType) && meetsConstraints
        if iscell(changeType)
            isChangeType = ismember(changeType, lower(getNodeChangeType(node, root)));
        else
            isChangeType = strcmpi(changeType, getNodeChangeType(node, root));
        end
        
        if ~any(isChangeType)
            meetsConstraints = false;
        end
    end

    if ~isempty(blockType) && meetsConstraints
        if iscell(blockType)
            isBlockType = ismember(blockType, lower(getNodeBlockType(node, file)));
        else
            isBlockType = strcmpi(blockType, getNodeBlockType(node, file));
        end
        
        if ~any(isBlockType)
            meetsConstraints = false;
        end
    end
    
    if ~isempty(nameValue) && meetsConstraints
        if iscell(nameValue)
            isMatchedName = ismember(nameValue, node.Name);
        else
            isMatchedName = strcmp(nameValue, node.Name);
        end
        
        if ~any(isMatchedName)
            meetsConstraints = false;
        end
    end

    if meetsConstraints
        out = node;
    else
        out = {};
    end

    if ~hasChildren(node)
        return;
    end

    for i = 1:length(node.Children)
        out = [out; findNode(node.Children(i), root, file, varargin)];
    end
end