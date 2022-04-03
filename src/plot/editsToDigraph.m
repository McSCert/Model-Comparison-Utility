function D = editsToDigraph(root)
% EDITSTODIGRAPH Create a digraph from a comparison tree.
%
%   Inputs:
%       root    xmlcomp.Edits object.
%
%   Outputs:
%       D       Digraph.
    
    % Validate inputs
    try
        assert(isa(root, 'xmlcomp.Edits'))
    catch
        message = 'Node argument must be an xmlcomp.Edits object.';
        error(message)
    end
    
    [source, target, nodes] = createSourceTarget(root);
    
    D = digraph(source, target);
    D.Nodes.Label = nodes;
end

function [source, target, nodes] = createSourceTarget(root, varargin)
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
%       nodes    Cell array of node labels.
    
    % Handle input
    omitParam = lower(getInput('OmitParam', varargin, 'on'));
    
    % Initialize
    source = {};
    target = {};
    nodes  = {};
    
    % Add the root node
    nodes{end+1}  = 'Edits';
    
    source{end+1} = 'Edits';
    target{end+1} = 'Comparison Root (before)';
    nodes{end+1}  = 'Comparison Root (before}';
     
    source{end+1} = 'Edits';
    target{end+1} = 'Comparison Root (after)';
    nodes{end+1}  = 'Comparison Root (after}';
        
    % Before
    nodes_before = getSubTree(root.LeftRoot);
   
    for j = 1:length(nodes_before)
        children = nodes_before(j).Children;
        if isempty(children)
            continue
        else
            children = nodes_before(j).Children;
            parent = getPathTree(nodes_before(j));
            suffix = ' (before)';
            
            for k = 1:length(children)
                if strcmp(omitParam, 'off') || ...
                    (strcmp(omitParam, 'on') && (~strcmp(getNodeType(children(k)), 'unknown') || children(k).Edited == 1))
                    source{end+1} = [parent suffix];
                    target{end+1} = [getPathTree(children(k)) suffix];
                    nodes{end+1}  = char(children(k).Name);
                end
            end
        end
    end
    
    % After
    nodes_after = getSubTree(root.RightRoot);   
    for j = 1:length(nodes_after)
        children = nodes_after(j).Children;
        if isempty(children)
            continue
        else
            children = nodes_after(j).Children;  
            parent = getPathTree(nodes_after(j));  
            suffix = ' (after)';
            
            for k = 1:length(children)
                if strcmp(omitParam, 'off') || ...
                    (strcmp(omitParam, 'on') && (~strcmp(getNodeType(children(k)), 'unknown') || children(k).Edited == 1))
                    source{end+1} = [parent suffix];
                    target{end+1} = [getPathTree(children(k)) suffix];
                    nodes{end+1}  = char(children(k).Name);
                end
            end
        end
    end
    nodes = nodes';
end