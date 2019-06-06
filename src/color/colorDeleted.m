function colorDeleted(root)
% COLORDELETED Color the deleted elements of a model based on the comparison
%   tree.
%
%   Inputs:
%       root    xmlcomp.Edits object.
%
%   Outputs:
%       N/A

    [n,~] = find_node(root, 'ChangeType', 'deleted');
    [~,sys,~] = fileparts(root.LeftFileName);
    
    h = zeros(1, length(n));
    for i = 1:length(n)
        try
            h(i) = getHandle(n(i), sys);
        catch
            h(i) = 0;
        end
    end
    
    try
        highlightNodes(h, sys, 'red', 'magenta')
    catch
    end
end