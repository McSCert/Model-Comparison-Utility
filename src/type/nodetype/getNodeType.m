function type = getNodeType(node, varargin)
% GETNODETYPE Determine the type of element that the node represents in the
%   model: block, block_diagram, line, port, mask, or annotation.
%
%   In general, only elements which are Edited can have their type inferred
%   directly from the tree. For those that cannot be inferred, if sys is 
%   provided, then the model will be checked. Otherwise, it is unknown.
%
%   Inputs:
%       node    xmlcomp.Node object.
%       sys     Path or name of the model. [Optional]
%
%   Outputs:
%       type	The type of node.

    % Validate inputs
    try
        assert(isa(node, 'xmlcomp.Node'))
    catch
        message = 'Node argument must be an xmlcomp.Node object.';
        error(message)
    end
    
    narginchk(1,2);
    
    sys = [];
    if nargin > 2
        error('Too many input arguments');
    elseif nargin == 2
        sys = varargin{:};
    end
    
    if ~isempty(sys)
        % Get the model name
        [~,sys,~] = fileparts(sys);
        
        % Check if loaded
        sysLoaded = bdIsLoaded(sys);
        if ~sysLoaded
            message = ['Model ' sys ' is not loaded.' newline];
            error(message)
        end
    end

    % First try to see if we can check the type without looking at the model.
    % If that does not work, check the model
    if ~isempty(node.Parameters) && any(strcmp({node.Parameters.Name}, 'BlockType'))
      type = 'block';
    elseif isBlockDiagram(node)
        type = 'block_diagram';
    elseif isLine(node)
        type = 'line';
    elseif isPort(node)
        type = 'port';
    elseif isMask(node)
        type = 'mask';
    elseif isAnnotation(node)
        type = 'annotation';
    elseif isConfiguration(node)
        type = 'configuration';
    elseif ~isempty(sys)
        path = getPath(node, varargin);
        if ~isempty(path) % Tree artifacts don't have paths (e.g. Comparison Root), or annotation, etc.
            try
               type = get_param(path, 'Type');
            catch
               % The path was not valid
               type = 'unknown';
            end
        else
            type = 'unknown';
        end                   
    else
        type = 'unknown';
    end
end