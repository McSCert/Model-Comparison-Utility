function obj = getStateflowObj(node)
% GETSTATEFLOWOBJ Get the model element corresponding to the Stateflow
% node. Stateflow objects don't have handles like Simulink, therefore this
% function returns the object itself. Note: The model needs to be open. 
%
%   Inputs:
%       node    xmlcomp.Node object.
%
%   Outputs:
%       obj     Stateflow object.

    obj = '';
    chart_node = getStateflowParent(node);
    chart = find(sfroot, '-isa', 'Stateflow.Chart', 'Name', chart_node.Name);

    for i = 1:length(chart) % Multiple charts with the same name can be found, so search all
        
        if ~isempty(node.Parameters)
            %% Get type from model by following the SSID, name, or label string
            paramNames = {node.Parameters.Name};
            paramVals = {node.Parameters.Value};
            idx_id = find(strcmpi(paramNames, 'ID'));
            idx_ssid = find(strcmpi(paramNames, 'SSID'));
            idx_lbl = find(strcmpi(paramNames, 'labelString'));
            idx_name = find(strcmpi(paramNames, 'Name'));
            idx_text = find(strcmp(paramNames, 'Text'));
            idx_port = find(strcmp(paramNames, 'Port'));
            idx_block = find(strcmp(paramNames, 'BlockType'));

            if numel(idx_name) > 1 % If both 'name' and 'Name' found, use 'Name'
                idx_name = find(strcmp(paramNames, 'Name'));
            end

            obj = '';
            if node == chart_node 
                % Node is the chart itself
                obj = chart(i);
            elseif ~isempty(idx_id) 
                % Try to find and object with the same SSID
                obj = find(chart(i), 'ssid', str2num(paramVals{idx_id}));
            elseif ~isempty(idx_ssid)
                obj = find(chart(i), 'ssid', str2num(paramVals{idx_ssid}));
            elseif ~isempty(idx_lbl)
                obj = find(chart(i), 'LabelString', paramVals{idx_lbl});
            elseif ~isempty(idx_name) && (isempty(idx_port) && isempty(idx_block))
                obj = find(chart(i), '-isa', 'Stateflow.Data', 'Name', paramVals{idx_name});
            elseif ~isempty(idx_name) && ~isempty(idx_port)
                obj = find(chart(i), '-isa', 'Stateflow.Data', 'Name', paramVals{idx_name});
            elseif ~isempty(idx_name)
                name = paramVals{idx_name};
                obj = find(chart(i), 'Name', name);
                if isempty(obj)
                    % Inports/outports may have () appended
                    name_stripped = regexprep(name, '\(.*?\)', '');
                    obj = find(chart(i), 'Name', name_stripped);
                end
                if isempty(obj)
                    % May be a function
                    obj = find(chart(i), 'LabelString', name);
                end
            elseif ~isempty(idx_text) 
                % Check if annotation by comparing text
                objs = find(chart(i), '-isa', 'Stateflow.Annotation');
                for j = 1:length(objs)
                    if contains(objs(j).Text, paramVals{idx_text})
                        obj = objs(j);
                        break;
                    end
                end
            end
        end

        if isempty(obj)
            %% Get object from the node name only
            if isempty(node.Name)
                % Check if name matches name
                obj = find(chart(i), '-not', '-isa', 'Stateflow.Chart', 'Name', node.Name);

                % Check if label matches name
                if isempty(obj)
                    obj = find(chart(i), 'LabelString', node.Name);
                end
            end
        end
          
        if ~isempty(obj)
            break;
        end
    end
end