function sameNodes = nodecmp(node1, node2)
% NODECMP Determine if two nodes are the same element before and after a change.
%   This method shold NOT BE USED to show exact equality (e.g. that node1
%   equals node1); please use the eq (==) method instead. This function is to show
%   that two nodes before and after changes represent the same element. This is
%   not the same as exact equality because the nodes may have different parameter
%   values as a result of the changes.
%
%   Inputs:
%       node1       xmlcomp.Node object.
%       node2       xmlcomp.Node object.
%
%   Outputs:
%       sameNodes   Whether the nodes are the same(1) or not(0).

    % Validate inputs
    try
        assert(isa(node1, 'xmlcomp.Node') && isa(node2, 'xmlcomp.Node'))
    catch
        message = 'Node argument must be an xmlcomp.Node object.';
        error(message)
    end

    sameNodes = false;

    % -- Check names --
    if ~(strcmp(node1.Name, node2.Name))
        return
    end

    % -- Check edited --
    if ~(node1.Edited == node2.Edited)
        return
    end

    % -- Check parameters --
    % Different amount of parameters
    if length(node1.Parameters) ~= length(node2.Parameters)
        return
    end

    if ~isempty(node1.Parameters) && ~isempty(node2.Parameters)
        params1 = {node1.Parameters.Name};
        params2 = {node2.Parameters.Name};

        % Keep track of what params were checked for node2.
        % Nodes may have the same number of params, but different params.
        unchecked2 = ones(1, length(params2));

        % Compare for same parameters (but not values)
        for i = 1:length(params1)
            [member, idx] = ismember(params1(i), params2);
            if member
                unchecked2(idx) = 0; % Mark as checked
            else
                return
            end
        end

        if any(unchecked2) % Some param Names were different, so some where unchecked
            return
        end
    end

    sameNodes = true;
end