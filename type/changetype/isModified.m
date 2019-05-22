function modified = isModified(node, checkPorts)
% ISMODIFIED Determine if the node has been modified. A modified node is 
%   one with a corresponding element in the model against which it is being 
%   compared, and has different parameters and/or different parents.
%
%   Modification does not mean added/removed/renamed. To check for this,
%   see isAdded, isRemoved, or isRenamed functions.
%
%   Inputs:
%       node        xmlcomp.Node object.
%       checkPorts  Whether to consider changes in number of subsystem ports(1) or not(0).
%
%   Outputs:
%       out         Whether the node has been modified(1) or not(0).

    % Validate inputs
    try
        assert(isa(node, 'xmlcomp.Node'))
    catch
        message = 'Node argument must be an xmlcomp.Node object.';
        error(message)
    end
    
    if nargin < 2
        checkPorts = true;
    end
    
    % Note: Modified nodes are not necessarily flagged as Edited.
    
    modified = false;
    
    % Has a correspodinging node
    if isempty(node.Partner)
        return
    else
       % Check if parents are different
        if isempty(node.Parent) && isempty(node.Partner.Parent)
            % Root nodes don't have parents
        elseif xor(isempty(node.Parent), isempty(node.Partner.Parent)) || ...
                ~nodecmp(node.Parent, node.Partner.Parent)
            % One node was a root, while the other is not anymore, or
            % the parents are different nodes.
            % This occurs when a model element is moved.
            modified = true;
            return
        end
    end

    % Both have parameters to check
    if ~isempty(node.Parameters) && ~isempty(node.Partner.Parameters)
        params1 = {node.Parameters.Name};
        params2 = {node.Partner.Parameters.Name};
        values1 = {node.Parameters.Value};
        values2 = {node.Partner.Parameters.Value};

        % Keep track of what params were checked. 
        % Nodes may have same number of params, but different params
        unchecked2 = ones(1, length(params2));

        % Compare Values for matching Names
        for i = 1:length(params1)
            [member, idx] = ismember(params1(i), params2);
            if strcmp(params1(i), 'Name') && strcmp(params2(idx), 'Name') % Skip differences in Name param. This is classified as 'renamed' type.
                 unchecked2(idx) = 0; % Mark as checked
            elseif ~checkPorts && (strcmp(params1(i), 'Ports') && strcmp(params2(idx), 'Ports')) % Skip differences in Ports param
                 unchecked2(idx) = 0; % Mark as checked
            elseif member && strcmp(values1(i), values2(idx))
                unchecked2(idx) = 0; % Mark as checked
            else
                modified = true;
                return
            end        
        end

        if any(unchecked2) % Some param Names were different, so some where unchecked
            modified = true;
            return
        end
    end
end