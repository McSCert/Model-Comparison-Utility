function out = isAnnotation(node)
% ISANNOTATION Determine if the node represents an annotation, based on the tree
%   only (i.e. does not check the model).
%
%   See: getNodeType.m
%
%   Inputs:
%       node    xmlcomp.Node object.
%
%   Outputs:
%       out     Whether the node represents an annotation(1) or not(0).

    % Validate inputs
    try
        assert(isa(node, 'xmlcomp.Node'))
    catch
        message = 'Node argument must be an xmlcomp.Node object.';
        error(message)
    end
    
    % Can be identified if it has the InternalMargins parameter
     if ~isempty(node.Parameters) && any(strcmp({node.Parameters.Name}, 'InternalMargins'))
    	out = true;
     else
         out = false;
     end
end