function parent = getStateflowParent(node)
% GETSTATEFLOWPARENT Get the parent node of the Stateflow object node.
%
%   Inputs:
%       node    xmlcomp.Node object.
%
%   Outputs:
%       parent  Parent node.

    parent = node;
    while hasParent(parent)
        if ~isempty(parent.Parameters)
            paramNames = {parent.Parameters.Name};
            paramVals  = {parent.Parameters.Value};
            idx = find(contains(paramNames, 'SFBlockType'));
            if ~isempty(idx) && contains(paramVals{idx}, {'Chart', 'State Transition Table', 'Truth Table'})
                break
            else
                parent = parent.Parent;
            end
        else
            parent = parent.Parent;
        end
    end
end