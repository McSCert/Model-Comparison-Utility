function [nodes, path] = find_node(root, varargin)
% FIND_NODE Search the comparison tree for nodes.
%   Note1: LeftRootFile and RightRootFile must be loaded/opened.
%   Note2: Does not return the xmlcomp.Edits objects itself.
%
%   Inputs:
%       root        xmlcomp.Edits object.
%       varargin    Search constraint as a 'Name', 'Value' pair.
%
%   Outputs:
%       nodes       Node array of xmlcomp.Node objects.
%       path        Cell array of node paths in the comparison tree (not
%                   model paths).
%
%   Usage:
%       nodes = FIND_NODE(ROOT, 'CONSTRAINT1', 'VALUE1', ...)
%       constrains the search of FIND_NODES to the specified constraint/value
%       pairs (not case-sensitive). The following describes the available
%       constraint/value pairs:
%
%       NodeType	['block' | 'line' | 'port' | 'annotation' | 'mask' | 'block_diagram' ...]
%       ChangeType	['added' | 'deleted' | 'modified' | 'renamed']
%       BlockType	['SubSystem' | 'Inport' | 'Outport' | ...]
%       NodeName    

    % Validate inputs
    try
        assert(isa(root, 'xmlcomp.Edits'))
    catch
        message = 'Node argument must be an xmlcomp.Edits object.';
        error(message)
    end

    % Parse varargin
    changeType = getInput('ChangeType', varargin);

    % Find the nodes
    % Don't have to check both branches, depending on the ChangeType:
    % 1) Check RIGHT branch for Added, Modified, Renamed (i.e., not Deleted)
    % 2) Check LEFT branch for Deleted, Modified, Renamed (i.e., not Added)
    % 3) Check BOTH if no ChangeTypes
    nodesFoundLeft = [];
    nodesFoundRight = [];
    if isempty(changeType) || ~strcmpi(changeType, 'Deleted')
        nodesFoundRight = findNode(root.RightRoot, root, root.RightFileName, varargin);
    end
    if isempty(changeType) || ~strcmpi(changeType, 'Added')
        nodesFoundLeft = findNode(root.LeftRoot, root, root.LeftFileName, varargin);
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
	nodeType   = getInput('NodeType', varargin);
    changeType = getInput('ChangeType', varargin);
    blockType  = getInput('BlockType', varargin);
    nameValue  = getInput('NodeName', varargin);

    % Check against varargin constraints
    meetsConstraints = true;

    if ~isempty(nodeType)
        isNodeType = strcmpi(nodeType, getNodeType(node, file));
        if ~any(isNodeType)
            meetsConstraints = false;
        end
    end

    if ~isempty(changeType) && meetsConstraints
        isChangeType = strcmpi(changeType, getNodeChangeType(node, root));
        if ~any(isChangeType)
            meetsConstraints = false;
        end
    end

    if ~isempty(blockType) && meetsConstraints
        isBlockType = strcmpi(blockType, getNodeBlockType(node, file));
        if ~any(isBlockType)
            meetsConstraints = false;
        end
    end
    
    if ~isempty(nameValue) && meetsConstraints
        isMatchedName = strcmpi(nameValue, node.Name);
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