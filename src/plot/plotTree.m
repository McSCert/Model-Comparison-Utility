function h = plotTree(root)
% PLOTTREE Plot the digraph of the comparison tree.
%
%   Inputs:
%       root    xmlcomp.Edits object.
%
%   Outputs:
%       h       Handle to the GraphPlot. 
%               (See www.mathworks.com/help/matlab/ref/graphplot.html)

    G = editsToDigraph(root);
    
    % Construct plot title
    [~, name1, ext1] = fileparts(root.LeftFileName);
    [~, name2, ext2] = fileparts(root.RightFileName);
    t = ['Comparison tree for ' name1 ext1  ' and ' name2 ext2];
    
    % Use Simulink-like plot options
    % Info on options: https://www.mathworks.com/help/matlab/ref/graph.plot.html
    figure
    h = plot(G, 'Layout', 'layered', 'Direction', 'right', 'AssignLayers', 'asap', 'ShowArrows', 'off');
    
    % Visual improvements
    title(t, 'Interpreter' ,'none');
    camroll(-90);
    set(gca,'xtick',[],'ytick',[])
    h.Marker = 's';
    h.MarkerSize = 8;
    
        % Stop underscores from resulting in subscript
    try
        set(h, 'Interpreter' ,'none');
    catch
    end
end