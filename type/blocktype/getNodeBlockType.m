function type = getNodeBlockType(node, sys)
% GETNODEBLOCKTYPE Determine the block type that the node represents in the model.
%   In general, only elements which are Edited can have their type inferred
%   directly from the tree. For those that cannot be inferred, if sys is 
%   provided, then the model will be checked.
%
%   Inputs:
%       node    xmlcomp.Node object.
%       sys     Path or name of the model. [Optional]
%
%   Outputs:
%       type	The BlockType of the node.

    % Validate inputs
    try
        assert(isa(node, 'xmlcomp.Node'))
    catch
        message = 'Node argument must be an xmlcomp.Node object.';
        error(message)
    end
    
    type = 'unknown';
    
	if isBlock(node)
        % Try checking parameters
        hasBlockType = false;
        if ~isempty(node.Parameters)
            hasBlockType = any(strcmp({node.Parameters.Name}, 'BlockType'));
        end

        if hasBlockType
            idx = strcmp({node.Parameters.Name}, 'BlockType');
            idx = find(idx);
            values = {node.Parameters.Value};
            type = char(values(idx));
        end
    
        % If still unknown and sys is provided, check model
        if strcmp(type, 'unknown') && exist('sys', 'var')
            path = getPath(node, sys);
            try
                type = get_param(path, 'BlockType');
            catch
                % Not a block. Look into why this was not caught by the
                % isBlock function!
            end
        end
	end
end