function printParams(node)
% PRINTPARAMS Print the parameters of a node.
%
%   Inputs:
%       node    xmlcomp.Node object.
%
%   Outputs:
%       N/A

    p = node.Parameters;
    for i = 1:length(p)
        fprintf('%s - ''%s''\n', p(i).Name, p(i).Value);
    end
end