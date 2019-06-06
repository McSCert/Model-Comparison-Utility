function out = isSubsystem(node)
% ISSUBSYSTEM Determine if the node represents a Subsystem block.
%
%   Caution: xmlcomp.Node objects representing Subsystems in the model will 
%   be in the xmlcomp.Edits tree for preserving the hierarchy, even
%   though the subsystem block itself is not edited (i.e. node.Edited is 0). 
%   If the Subsystem is unedited, it will not be detectable as a Subsystem 
%   because it will have empty parameters. Therefore, this function can
%   only detect Edited subsystems. All others are ignored.
%
%   Inputs:
%       node    xmlcomp.Node object.
%
%   Outputs:
%       out     Whether the node represents a Subsystem block(1) or not(0).

    try
        assert(isa(node, 'xmlcomp.Node'))
    catch
        message = 'Node argument must be an xmlcomp.Node object.';
        error(message)
    end
    
    % Nodes representing blocks have their name set to the Name parameter of the
    % block, so we have to do some deduction
    
    hasBlockType = false;
    if ~isempty(node.Parameters)
        hasBlockType = any(strcmp({node.Parameters.Name}, 'BlockType'));
    end
    
    isSubSys = false;
    if hasBlockType
        idx = strcmp({node.Parameters.Name}, 'BlockType');
        idx = find(idx);
        values = {node.Parameters.Value};
        
        isSubSys = strcmp(char(values(idx)), 'SubSystem');
    end
    
    out = isSubSys && ~(isLine(node) || isPort(node) || isMask(node) || isAnnotation(node));
end