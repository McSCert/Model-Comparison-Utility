function out = isOutport(node)
% ISINPORT Determine if the node represents an outport block.
%
%   Inputs:
%       node    xmlcomp.Node object.
%
%   Outputs:
%       out     Whether the node represents an outport block(1) or not(0).

    % Validate inputs
    try
        assert(isa(node, 'xmlcomp.Node'))
    catch
        message = 'Node argument must be an xmlcomp.Node object.';
        error(message)
    end
    
    % Nodes representing blocks have their name set to the Name parameter of
    % the block, so we have to do some deduction
   
    hasBlockType = false;
    if ~isempty(node.Parameters)
        hasBlockType = any(strcmp({node.Parameters.Name}, 'BlockType'));
    end
    
    isOut = false;
    if hasBlockType
        idx = strcmp({node.Parameters.Name}, 'BlockType');
        idx = find(idx);
        values = {node.Parameters.Value};
        
        isOut = strcmp(char(values(idx)), 'Outport');
    end
    
    out = isOut && ~(isLine(node) || isPort(node) || isMask(node) || isAnnotation(node));
end