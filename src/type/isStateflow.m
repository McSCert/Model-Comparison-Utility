function out = isStateflow(node)
% ISSTATEFLOW Determine if the node represents a Stateflow object.
%
%   Inputs:
%       node    xmlcomp.Node object.
%
%   Outputs:
%       out     Whether the node represents an Stateflow object(1) or not(0).

    out = false;

    % Inspect all parents of the node to see if it is contained in a Stateflow 
    % Chart or Stateflow table.
    while hasParent(node)
        if ~isempty(node.Parameters) 
            paramNames = {node.Parameters.Name};
            paramVals  = {node.Parameters.Value};
            idx = find(contains(paramNames, 'SFBlockType'));
            if ~isempty(idx) && contains(paramVals{idx}, {'Chart', 'State Transition Table', 'Truth Table'})
                out = true; 
                break
            else
                node = node.Parent;
            end
        else
            node = node.Parent;
        end
    end
end     