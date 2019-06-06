function summaryOfChanges(root, printPath, printFile)
% SUMMARYOFCHANGES Print a summary report of all the changes in the comparison tree.
%
%   Inputs:
%       root        xmlcomp.Edits object.
%       printPath   Whether to print the paths(1) or not(0). [Optional]
%       printFile   Whether to create a file with the summary(1) or not(0).
%                   File is created in the current directory, with name:
%                   model1_VS_model2.txt. [Optional]
%
%   Outputs:
%       N/A

    model1 = root.LeftFileName;
    model2 = root.RightFileName;
    [~,name1,~] = fileparts(model1);
    [~,name2,~] = fileparts(model2);
    if ~bdIsLoaded(name1) || ~bdIsLoaded(name2)
        error('Models are not loaded.');
    end

    if (nargin < 2) && ~exist('printPath', 'var')
        printPath = 0;
    end

    % Open file for printing, if applicable
    if (nargin > 2) && printFile
        % Open the file, then print a header
        filename = [name1 '_VS_' name2 '.txt'];
        file = fopen(filename, 'wt');
    else
        filename = '';
        file = '';
    end

    % Print sections
    allElements(root, printPath, file);
    allBlocks(root, printPath, file);
    allInports(root, printPath, file);
    allOutports(root, printPath, file);
    allSubsystems(root, printPath, file);
    allLines(root, printPath, file);

    % Close file
    if file
        fclose(file);
    end
end

function printQuery(root, query, printPath, file)
    [~,p] = find_node(root, 'NodeType', 'block', query{:});
    % Print query
    if file
        fprint(file, '%s\n', query)
    else
        fprint('%s\n', query)
    end
    % Print paths
    printPaths(p, file);
end

function allElements(root, printPath, file)
    if file
        fprintf(file, '\n-------------\n');
        fprintf(file, 'All Elements\n');
        fprintf(file, '-------------\n');

        [~,p] = find_node(root, 'ChangeType', 'added');
        fprintf(file, '\nADDED: %d\n', length(p));
        if printPath
            printPaths(p, file)
        end

        [~,p] = find_node(root, 'ChangeType', 'deleted');
        fprintf(file, '\nDELETED: %d\n', length(p));
        if printPath
            printPaths(p, file)
        end

        [~,p] = find_node(root, 'ChangeType', 'renamed');
        fprintf(file, '\nRENAMED: %d\n', length(p)/2);
        if printPath
            printPaths(p, file)
        end

        [~,p] = find_node(root, 'ChangeType', 'modified');
        fprintf(file, '\nMODIFIED: %d\n', length(p));
        if printPath
            printPaths(p, file)
        end
    else
        fprintf('\n-------------\n');
        fprintf('All Elements\n');
        fprintf('-------------\n');

        [~,p] = find_node(root, 'ChangeType', 'added');
        fprintf('\nADDED: %d\n', length(p));
        if printPath
            printPaths(p, file)
        end

        [~,p] = find_node(root, 'ChangeType', 'deleted');
        fprintf('\nDELETED: %d\n', length(p));
        if printPath
            printPaths(p, file)
        end

        [~,p] = find_node(root, 'ChangeType', 'renamed');
        fprintf('\nRENAMED: %d\n', length(p)/2);
        if printPath
            printPaths(p, file)
        end

        [~,p] = find_node(root, 'ChangeType', 'modified');
        fprintf('\nMODIFIED: %d\n', length(p));
        if printPath
            printPaths(p, file)
        end
    end
end

function allBlocks(root, printPath, file)
    if file
        fprintf(file, '\n-------------\n');
        fprintf(file, 'All Blocks\n');
        fprintf(file, '-------------\n');

        [~,p] = find_node(root, 'NodeType', 'block', 'ChangeType', 'added');
        fprintf(file, '\nADDED: %d\n', length(p));
        if printPath
            printPaths(p, file)
        end

        [~,p] = find_node(root, 'NodeType', 'block', 'ChangeType', 'deleted');
        fprintf(file, '\nDELETED: %d\n', length(p));
        if printPath
            printPaths(p, file)
        end

        [~,p] = find_node(root, 'NodeType', 'block', 'ChangeType', 'renamed');
        fprintf(file, '\nRENAMED: %d\n', length(p)/2);
        if printPath
            printPaths(p, file)
        end

        [~,p] = find_node(root, 'NodeType', 'block', 'ChangeType', 'modified');
        fprintf(file, '\nMODIFIED: %d\n', length(p));
        if printPath
            printPaths(p, file)
        end
    else
        fprintf('\n-------------\n');
        fprintf('All Blocks\n');
        fprintf('-------------\n');

        [~,p] = find_node(root, 'NodeType', 'block', 'ChangeType', 'added');
        fprintf('\nADDED: %d\n', length(p));
        if printPath
            printPaths(p, file)
        end

        [~,p] = find_node(root, 'NodeType', 'block', 'ChangeType', 'deleted');
        fprintf('\nDELETED: %d\n', length(p));
        if printPath
            printPaths(p, file)
        end

        [~,p] = find_node(root, 'NodeType', 'block', 'ChangeType', 'renamed');
        fprintf('\nRENAMED: %d\n', length(p)/2);
        if printPath
            printPaths(p, file)
        end

        [~,p] = find_node(root, 'NodeType', 'block', 'ChangeType', 'modified');
        fprintf('\nMODIFIED: %d\n', length(p));
        if printPath
            printPaths(p, file)
        end
    end
end

function allInports(root, printPath, file)
    if file
        fprintf(file, '\n-------------\n');
        fprintf(file, 'Inports\n');
        fprintf(file, '-------------\n');

        [~,p] = find_node(root, 'NodeType', 'block', 'ChangeType', 'added', 'BlockType', 'inport');
        fprintf(file, '\nADDED: %d\n', length(p));
        if printPath
            printPaths(p, file)
        end

        [~,p] = find_node(root, 'NodeType', 'block', 'ChangeType', 'deleted', 'BlockType', 'inport');
        fprintf(file, '\nDELETED: %d\n', length(p));
        if printPath
            printPaths(p, file)
        end

        [~,p] = find_node(root, 'NodeType', 'block', 'ChangeType', 'renamed', 'BlockType', 'inport');
        fprintf(file, '\nRENAMED: %d\n', length(p)/2);
        if printPath
            printPaths(p, file)
        end

        [~,p] = find_node(root, 'NodeType', 'block', 'ChangeType', 'modified', 'BlockType', 'inport');
        fprintf(file, '\nMODIFIED: %d\n', length(p));
        if printPath
            printPaths(p, file)
        end
    else
        fprintf('\n-------------\n');
        fprintf('Inports\n');
        fprintf('-------------\n');

        [~,p] = find_node(root, 'NodeType', 'block', 'ChangeType', 'added', 'BlockType', 'inport');
        fprintf('\nADDED: %d\n', length(p));
        if printPath
            printPaths(p, file)
        end

        [~,p] = find_node(root, 'NodeType', 'block', 'ChangeType', 'deleted', 'BlockType', 'inport');
        fprintf('\nDELETED: %d\n', length(p));
        if printPath
            printPaths(p, file)
        end

        [~,p] = find_node(root, 'NodeType', 'block', 'ChangeType', 'renamed', 'BlockType', 'inport');
        fprintf('\nRENAMED: %d\n', length(p)/2);
        if printPath
            printPaths(p, file)
        end

        [~,p] = find_node(root, 'NodeType', 'block', 'ChangeType', 'modified', 'BlockType', 'inport');
        fprintf('\nMODIFIED: %d\n', length(p));
        if printPath
            printPaths(p, file)
        end
    end
end

function allOutports(root, printPath, file)
    if file
        fprintf(file, '\n-------------\n');
        fprintf(file, 'Outports\n');
        fprintf(file, '-------------\n');

        [~,p] = find_node(root, 'NodeType', 'block', 'ChangeType', 'added', 'BlockType', 'outport');
        fprintf(file, '\nADDED: %d\n', length(p));
        if printPath
            printPaths(p, file)
        end

        [~,p] = find_node(root, 'NodeType', 'block', 'ChangeType', 'deleted', 'BlockType', 'outport');
        fprintf(file, '\nDELETED: %d\n', length(p));
        if printPath
            printPaths(p, file)
        end

        [~,p] = find_node(root, 'NodeType', 'block', 'ChangeType', 'renamed', 'BlockType', 'outport');
        fprintf(file, '\nRENAMED: %d\n', length(p)/2);
        if printPath
            printPaths(p, file)
        end

        [~,p] = find_node(root, 'NodeType', 'block', 'ChangeType', 'modified', 'BlockType', 'outport');
        fprintf(file, '\nMODIFIED: %d\n', length(p));
        if printPath
            printPaths(p, file)
        end
    else
        fprintf('\n-------------\n');
        fprintf('Outports\n');
        fprintf('-------------\n');

        [~,p] = find_node(root, 'NodeType', 'block', 'ChangeType', 'added', 'BlockType', 'outport');
        fprintf('\nADDED: %d\n', length(p));
        if printPath
            printPaths(p, file)
        end

        [~,p] = find_node(root, 'NodeType', 'block', 'ChangeType', 'deleted', 'BlockType', 'outport');
        fprintf('\nDELETED: %d\n', length(p));
        if printPath
            printPaths(p, file)
        end

        [~,p] = find_node(root, 'NodeType', 'block', 'ChangeType', 'renamed', 'BlockType', 'outport');
        fprintf('\nRENAMED: %d\n', length(p)/2);
        if printPath
            printPaths(p, file)
        end

        [~,p] = find_node(root, 'NodeType', 'block', 'ChangeType', 'modified', 'BlockType', 'outport');
        fprintf('\nMODIFIED: %d\n', length(p));
        if printPath
            printPaths(p, file)
        end
    end
end

function allSubsystems(root, printPath, file)
    if file
        fprintf(file, '\n-------------\n');
        fprintf(file, 'Subsystems\n');
        fprintf(file, '-------------\n');

        [~,p] = find_node(root, 'NodeType', 'block', 'ChangeType', 'added', 'BlockType', 'subsystem');
        fprintf(file, '\nADDED: %d\n', length(p));
        if printPath
            printPaths(p, file)
        end

        [~,p] = find_node(root, 'NodeType', 'block', 'ChangeType', 'deleted', 'BlockType', 'subsystem');
        fprintf(file, '\nDELETED: %d\n', length(p));
        if printPath
            printPaths(p, file)
        end

        [~,p] = find_node(root, 'NodeType', 'block', 'ChangeType', 'renamed', 'BlockType', 'subsystem');
        fprintf(file, '\nRENAMED: %d\n', length(p)/2);
        if printPath
            printPaths(p, file)
        end

        [n, p] = find_node(root, 'BlockType', 'subsystem');
        subsystemModifiedContents = {};
        for i = 1:length(n)
            if isChildrenModified(n(i), root)
                subsystemModifiedContents{end+1} = char(p(i));
            end
        end
        subsystemModifiedContents = unique(subsystemModifiedContents);
        fprintf(file, '\nCONTAINS MODIFIED CHILDREN: %d\n', length(subsystemModifiedContents));
        if printPath
            printPaths(subsystemModifiedContents, file)
        end
    else
        fprintf('\n-------------\n');
        fprintf('Subsystems\n');
        fprintf('-------------\n');

        [~,p] = find_node(root, 'NodeType', 'block', 'ChangeType', 'added', 'BlockType', 'subsystem');
        fprintf('\nADDED: %d\n', length(p));
        if printPath
            printPaths(p, file)
        end

        [~,p] = find_node(root, 'NodeType', 'block', 'ChangeType', 'deleted', 'BlockType', 'subsystem');
        fprintf('\nDELETED: %d\n', length(p));
        if printPath
            printPaths(p, file)
        end

        [~,p] = find_node(root, 'NodeType', 'block', 'ChangeType', 'renamed', 'BlockType', 'subsystem');
        fprintf('\nRENAMED: %d\n', length(p)/2);
        if printPath
            printPaths(p, file)
        end

        [n, p] = find_node(root, 'BlockType', 'subsystem');
        subsystemModifiedContents = {};
        for i = 1:length(n)
            if isChildrenModified(n(i), root)
                subsystemModifiedContents{end+1} = char(p(i));
            end
        end
        subsystemModifiedContents = unique(subsystemModifiedContents);
        fprintf('\nCONTAINS CHILDREN THAT CONTAIN CHANGES: %d\n', length(subsystemModifiedContents));
        if printPath
            printPaths(subsystemModifiedContents, file)
        end
    end
end

function allLines(root, printPath, file)
    if file
        fprintf(file, '\n-------------\n');
        fprintf(file, 'All Lines\n');
        fprintf(file, '-------------\n');

        [~,p] = find_node(root, 'NodeType', 'line', 'ChangeType', 'added');
        fprintf(file, '\nADDED: %d\n', length(p));
         if printPath
            printPaths(p, file)
         end

        [~,p] = find_node(root, 'NodeType', 'line', 'ChangeType', 'deleted');
        fprintf(file, '\nDELETED: %d\n', length(p));
          if printPath
            printPaths(p, file)
          end

        [~,p] = find_node(root, 'NodeType', 'line', 'ChangeType', 'modified');
        fprintf(file, '\nMODIFIED: %d\n', length(p));
         if printPath
            printPaths(p, file)
         end
    else
        fprintf('\n-------------\n');
        fprintf('All Lines\n');
        fprintf('-------------\n');

        [~,p] = find_node(root, 'NodeType', 'line', 'ChangeType', 'added');
        fprintf('\nADDED: %d\n', length(p));
         if printPath
            printPaths(p, file)
         end

        [~,p] = find_node(root, 'NodeType', 'line', 'ChangeType', 'deleted');
        fprintf('\nDELETED: %d\n', length(p));
          if printPath
            printPaths(p, file)
          end

        [~,p] = find_node(root, 'NodeType', 'line', 'ChangeType', 'modified');
        fprintf('\nMODIFIED: %d\n', length(p));
         if printPath
            printPaths(p, file)
         end
    end
end

function printPaths(p, file)
% PRINTPATHS Print a cell array of paths.
    if file
        for i = 1:length(p)
            line = strrep(cell2mat(p(i)), newline, ' ');
            fprintf(file, '\t%s\n', line);
        end
    else
        for i = 1:length(p)
            line =  strrep(cell2mat(p(i)), newline, ' ');
            fprintf('\t%s\n', line);
        end
    end
end