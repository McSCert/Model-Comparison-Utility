function path = getPath(node, sys)
% GETPATH Get the path of a node in a model. Note: Not all elements in a
%   model have a Path parameter (e.g. lines, annotations). If an empty cell
%   array is returned, no valid path has been found.
% 
%   Inputs:
%       node    xmlcomp.Node object, representing a block.
%       sys     Path or name of the model.
%
%   Outputs:
%       path    Path of node in the model.
%
%   Examples:
%       getPath(Edits.LeftRoot.Children.Children.Children.Children(1), 'test1_diff')
%           ans =
%               test1_diff/Subsystem/Subsystem/Add

    % Validate inputs
    try
        assert(isa(node, 'xmlcomp.Node'))
    catch
        message = 'Node argument must be an xmlcomp.Node object.';
        error(message)
    end

    sys = char(sys);
    path = assemblePath(sys, node);
    
    % Address R2016b bug
    if strcmp(version('-release'), '2016b')
        path = fixDuplicates(path);
    end
    
    % Parent is root system
    if strcmp(path, sys)
        return
    else
        % Confirm that the model does in fact have an element with this path
        try 
            [~,name,~] = fileparts(sys);
            root = bdroot(name);
            sysLoaded = bdIsLoaded(root);
           % isRoot = strcmp(name, root); 
            if sysLoaded && (getSimulinkBlockHandle(path) == -1)
                path = {};
            end
        catch
            % Model not loaded so cannot check
            warning('off', 'backtrace');
            message = ['Model ' name ' is not loaded. Could not check if ' path ...
                ' exists in system ' sys '. Path returned is a best guess based'...
                ' on the xmlcomp.Edits object.' newline];
            warning(message)
        end
    end
end

function path = assemblePath(sys, node)
% ASSEMBLEPATH Recursively assemble the path string from the xmlcomp.Edits object. 
%   Any comparison artifacts are omitted (e.g. 'Comparison Root').
%
%   Inputs:
%       sys     Path or name of the model.
%       node    xmlcomp.Node object, representing a block, for which to find the path. 
%
%   Outputs:
%       path    Path of the node.

    basePath = getPathTree(node);
    
    initPath1 = 'SLX Comparison Root/Simulink/System';
    initPath2 = 'Comparison Root/Simulink';
    if any(strcmp(basePath, {...
        initPath1, ...
        fileparts(initPath1), ...
        fileparts(fileparts(initPath1)), ...
        initPath2, ...
        fileparts(initPath2)}))
        path = '';
    else
        startIdx = regexp(basePath, ['^(' initPath1 '|' initPath2 ')/'], 'end', 'once');
        assert(~isempty(startIdx), 'Internal error. Bad assumption about xmlcomp.Node objects.')
        startIdx = startIdx + 1;
        
        [~,name,~] = fileparts(sys);
        path = [name '/' basePath(startIdx:end)];
    end
    
%     if any(strcmp(node.Name, {'SLX Comparison Root', 'Comparison Root'}))
%         path = ''; % Omit
%     elseif any(strcmp(node.Name, {'Simulink', 'System'}))
%         [~,name,~] = fileparts(sys);
%         path = name; % Use actual model name
%     else
%         path = [assemblePath(sys, node.Parent) '/' node.Name];
%     end
end

function pathafter = fixDuplicates(pathbefore)
% FIXDUPLICATES Removes duplicated elements in the Edits tree, caused due to 
%   a bug in R2016b. Specifically, removes duplicated Subsystems and
%   Simulink Functions.
%
%   Inputs:
%       pathbefore    Original path.
%
%   Outputs:
%       pathafter     Modified path.
%
%   Examples:
%       fixDuplicates('test1_diff_2016b/Subsystem/Subsystem/Subsystem/Subsystem/Add')
%           ans =
%               test1_diff_2016b/Subsystem/Subsystem/Add

    % Relevant observations:
    %
    % Undesirable duplicates occur after parts(1) and if another index is not a
    % duplicate, then it is assumed that there are no more duplicates.
    % Examples:
    %   a/a/b -> a/a/b
    %   a/a/a/b -> a/a/b
    %   a/b/b/c/c/d/e/e/e -> a/b/c/d/e/e/e
    %   a/b/b/c/c/c/d/d/d -> a/b/c/c/d/d/d
    %
    % Subsystems in paths are separated by a single '/' with no adjacent '/'.
    
    if ~isempty(pathbefore)
        splitIdxs1 = regexp(pathbefore, '[^/]/') + 1;
        splitIdxs2 = regexp(pathbefore, '/[^/]');
        splitIdxs = intersect(splitIdxs1, splitIdxs2); % Positions of '/' with no '/' immediately before or after (pattern '[^/]/[^/]' would fail for 'a/a/a')
        splitIdxs = [0 splitIdxs length(pathbefore)+1]; % Also 'split' at start and end
        parts = {};
        for i = 1:length(splitIdxs)-1
            start = splitIdxs(i)+1;
            stop = splitIdxs(i+1)-1;
            parts{i} = pathbefore(start:stop);
        end

        partsafter = parts;
        i = 2;
        flag = true;
        while flag
            if i+1 <= length(partsafter)
                if strcmp(partsafter{i}, partsafter{i+1})
                    % Remove duplicate
                    partsafter(i+1) = [];
                    i = i+1;
                else
                    % Keep the rest
                    flag = false;
                end
            else
                % Keep the rest
                flag = false;
            end
        end
        
        pathafter = strjoin(partsafter, '/');
    else
        pathafter = pathbefore;
    end

%     parts = strsplit(pathbefore, '/');
%     path = '';
%     
%     idx = 1;
%     while idx <= length(parts)
%         path = [path parts(idx)];
%         if strcmpi(parts(idx), 'Subsystem') || strcmpi(parts(idx), 'Simulink Function')
%             idx = idx + 2; %Skip
%         else
%             idx = idx + 1;
%         end
%     end
%     pathafter = strjoin(path, '/');
end