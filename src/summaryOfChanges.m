function summaryOfChanges(root, printPath, printFile)
% SUMMARYOFCHANGES Print a summary report of all the changes in the comparison tree.
%
%   Inputs:
%       root        xmlcomp.Edits object.
%       printPath   Whether to print the paths(1) or not(0). [Optional]
%       printFile   Whether to create a file with the summary(1) or not(0).
%                   File is created in the current directory, with filename:
%                   model1_VS_model2.txt. [Optional]
%
%   Outputs:
%       N/A
%
%   Side Effects:
%       File output or Command Window output.

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
        file = 1;
    end

    % Queries to print
    printQuery(root, {'ChangeType', 'added'}, printPath, file);
    printQuery(root, {'ChangeType', 'deleted'}, printPath, file);
    printQuery(root, {'ChangeType', 'renamed'}, printPath, file);
    printQuery(root, {'ChangeType', 'modified'}, printPath, file);
    
    printQuery(root, {'NodeType', 'block', 'ChangeType', 'added'}, printPath, file);
    printQuery(root, {'NodeType', 'block', 'ChangeType', 'deleted'}, printPath, file);
    printQuery(root, {'NodeType', 'block', 'ChangeType', 'renamed'}, printPath, file);
    printQuery(root, {'NodeType', 'block', 'ChangeType', 'modified'}, printPath, file);
    
    printQuery(root, {'NodeType', 'block', 'ChangeType', 'added', 'BlockType', 'inport'}, printPath, file);
    printQuery(root, {'NodeType', 'block', 'ChangeType', 'deleted', 'BlockType', 'inport'}, printPath, file);
    printQuery(root, {'NodeType', 'block', 'ChangeType', 'renamed', 'BlockType', 'inport'}, printPath, file);
    printQuery(root, {'NodeType', 'block', 'ChangeType', 'modified', 'BlockType', 'inport'}, printPath, file);
    
    printQuery(root, {'NodeType', 'block', 'ChangeType', 'added', 'BlockType', 'outport'}, printPath, file);
    printQuery(root, {'NodeType', 'block', 'ChangeType', 'deleted', 'BlockType', 'outport'}, printPath, file);
    printQuery(root, {'NodeType', 'block', 'ChangeType', 'renamed', 'BlockType', 'outport'}, printPath, file);
    printQuery(root, {'NodeType', 'block', 'ChangeType', 'modified', 'BlockType', 'outport'}, printPath, file);
    
    printQuery(root, {'NodeType', 'block', 'ChangeType', 'added', 'BlockType', 'subsystem'}, printPath, file);
    printQuery(root, {'NodeType', 'block', 'ChangeType', 'deleted', 'BlockType', 'subsystem'}, printPath, file);
    printQuery(root, {'NodeType', 'block', 'ChangeType', 'renamed', 'BlockType', 'subsystem'}, printPath, file);
    printQuery(root, {'NodeType', 'block', 'ChangeType', 'modified', 'BlockType', 'subsystem'}, printPath, file);
    
%     [n, p] = find_node(root, 'BlockType', 'subsystem');
%     subsystemModifiedContents = {};
%     for i = 1:length(n)
%         if isChildrenModified(n(i), root)
%             subsystemModifiedContents{end+1} = char(p(i));
%         end
%     end
%     subsystemModifiedContents = unique(subsystemModifiedContents);
%     fprintf(file, 'BlockType, subsystem, containing modified: TOTAL %d\n', length(subsystemModifiedContents));
%     printPaths(subsystemModifiedContents, file)
    
    printQuery(root, {'NodeType', 'line', 'ChangeType', 'added'}, printPath, file);
    printQuery(root, {'NodeType', 'line', 'ChangeType', 'deleted'}, printPath, file);
    printQuery(root, {'NodeType', 'line', 'ChangeType', 'renamed'}, printPath, file);
    printQuery(root, {'NodeType', 'line', 'ChangeType', 'modified'}, printPath, file);

    % Close file
    if ~(file == 1)
        fclose(file);
    end
end

function printQuery(root, query, printPath, file)
    % Get data
    [~,p] = find_node(root, 'NodeType', 'block', query{:});
    n = length(p);
    
    % Construct formatting for query
    format = repmat('%s, ', 1, length(query));
    format = format(1:end-2); % Take off last comma and space
    
    % Print query
    fprintf(file, format, query{:});
    fprintf(file, ' -- TOTAL %d\n', n);

    % Print paths  
    if printPath
        printPaths(p, file);
    end
end

function printPaths(p, file)
% PRINTPATHS Print a cell array of paths.
    for i = 1:length(p)
        line = strrep(cell2mat(p(i)), newline, ' ');
        fprintf(file, '\t%s\n', line);
    end
end