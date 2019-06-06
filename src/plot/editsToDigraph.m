function D = editsToDigraph(root)
% EDITSTODIGRAPH Create a digraph from a comparison tree.
%
%   Inputs:
%       root    xmlcomp.Edits object.
%
%   Outputs:
%       D       Digraph.

    % Known issues:
    %   1) Non-unique node names may result in single nodes when there should be 
    %   two distinct nodes. Subsystems, all named 'Subsystem', are shown as
    %   loops. This is resolved currently by using the node paths as the graph
    %   nodes names. This results in long names.
    
    % Validate inputs
    try
        assert(isa(root, 'xmlcomp.Edits'))
    catch
        message = 'Node argument must be an xmlcomp.Edits object.';
        error(message)
    end
    
    [source, target] = createSourceTarget(root);
    
    D = digraph(source, target);
end

function [source, target] = createSourceTarget(root)
% CREATESOURCETARGET Get the directed graph edges as (source, target) pairs for
%   a comparison tree.
%   (See www.mathworks.com/help/matlab/ref/digraph.html#mw_26035adf-ff90-4a33-a8f8-42048d7e39a6)
%
%   Inputs:
%       root     xmlcomp.Edits object.
%
%   Outputs:
%       source   Cell array of source nodes.
%       target   Cell array of target nodes.

    nodes_before = getSubTree(root.LeftRoot);
    nodes_after = getSubTree(root.RightRoot);
    
    
    source = {};
    target = {};
    % Before
    for j = 1:length(nodes_before)
        children = nodes_before(j).Children;
        if isempty(children)
            continue
        else
            %children = {nodes_before(j).Children.Name};
            %parent = nodes_before(j).Name;
            children = nodes_before(j).Children;
            parent = getPathTree(nodes_before(j));
            suffix = ' (before)';
            
            for k = 1:length(children)
                %source{end+1} = [parent suffix];
                %target{end+1} = [char(children(k)) suffix];
                source{end+1} = [parent suffix];
                target{end+1} = [getPathTree(children(k)) suffix];
            end
        end
    end
    % After
    for j = 1:length(nodes_after)
        children = nodes_after(j).Children;
        if isempty(children)
            continue
        else
            children = nodes_after(j).Children;  
            parent = getPathTree(nodes_after(j));  
            suffix = ' (after)';
            
            for k = 1:length(children)
                source{end+1} = [parent suffix];
                target{end+1} = [getPathTree(children(k)) suffix];
            end
        end
    end

    % Add the root node
    source{end+1} = 'Edits';
    source{end+1} = 'Edits';
    if verLessThan('Simulink', '8.9')
        target{end+1} = 'SLX Comparison Root (before)';
        target{end+1} = 'SLX Comparison Root (after)';
    else
        target{end+1} = 'Comparison Root (before)';
        target{end+1} = 'Comparison Root (after)';
    end
end