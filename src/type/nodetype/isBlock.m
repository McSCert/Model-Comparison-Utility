function out = isBlock(node)
% ISBLOCK Determine if the node represents a block, based on the tree
%   only (i.e. does not check the model).
%
%   See: getNodeType.m
%
%   Inputs:
%       node    xmlcomp.Node object.
%
%   Outputs:
%       out     Whether the node represents a block(1) or not(0).

    % Validate inputs
    try
        assert(isa(node, 'xmlcomp.Node'))
    catch
        message = 'Node argument must be an xmlcomp.Node object.';
        error(message)
    end
    
    % Nodes representing blocks have their name set to the Name parameter of
    % the block, so we have to do some deduction
    
    % If it has a BlockType parameter, then it's a block.
    % Note: Only useful if the node is Edited. If it is not edited, the node will
    % not have a BlockType parameter. This is an issue for Subsystems that are
    % included for maintaining the hierarchy.
    hasBlockType = false;
    if ~isempty(node.Parameters)
        hasBlockType = any(strcmp({node.Parameters.Name}, 'BlockType'));
    end

    isOther = (isLine(node) || isPort(node) || isMask(node) || isAnnotation(node) || isBlockDiagram(node) || isConfiguration(node));
    out = hasBlockType || ~(isOther);
end