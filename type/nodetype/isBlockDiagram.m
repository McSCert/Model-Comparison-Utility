function out = isBlockDiagram(node)
% ISBLOCKDIAGRAM Determine if the node presents a block_diagram, based on the
%   tree only (i.e. does not check the model).
%
%   See: getNodeType.m
%
%   Inputs:
%       node    xmlcomp.Node object.
%
%   Outputs:
%       out     Whether the node represents a block_diagram(1) or not(0).

    % Validate inputs
    try
        assert(isa(node, 'xmlcomp.Node'))
    catch
        message = 'Node argument must be an xmlcomp.Node object.';
        error(message)
    end
    
    if strcmp(node.Name, 'Simulink') && any(strcmp(node.Parent.Name, {'Comparison Root', 'SLX Comparison Root'}))
        out = true;
    else
        out = false;
    end
end