function hdl = getHandle(node, sys)
% GETHANDLE Get the handle of the model element associated with the node from 
%   the comparison. 
%
%   Note: Not all nodes have an associated handle (e.g., Mask, Comparison Root).
%
%   Inputs:
%       node    xmlcomp.Node object for which to find the handle.
%       sys     Path or name of the model.
%
%   Outputs:
%       hdl     Handle of node in the model.

    try
        assert(isa(node, 'xmlcomp.Node'))
    catch
        message = 'Node argument must be an xmlcomp.Node object.';
        error(message)
    end

    narginchk(2,2);
    
    hdl = [];  % Default return value when there are no matches
    
    type = getNodeType(node, sys);
    if strcmp(type, 'block')
        p = getPath(node, sys);
        if ~isempty(p)
            hdl = get_param(p, 'Handle');
        else
            hdl = [];
        end
    elseif strcmp(type, 'line')
        % -- Search for the line in the model by matching sources, destinations, and parents --
        % Get all lines in the subsystem
        p = getParentPath(node, sys);
        lines = find_system(p, 'SearchDepth', '1', 'FindAll', 'on', 'Type', 'line');
        
        % Get the node's parent
        parent = node.Parent;
        while isLine(parent)
            parent = parent.Parent;
        end
        parentName_node = parent.Name;
        
        % Get the node's source/destination parameters
        try   
            if any(strcmp({node.Parameters.Name}, 'SrcBlock'))
                srcBlock_node = node.Parameters(strcmp({node.Parameters.Name}, 'SrcBlock')).Value;
            else
                srcBlock_node = '';
            end
        catch % line branch
            srcBlock_node = '';
        end
        
        try
            if any(strcmp({node.Parameters.Name}, 'SrcPort'))
                srcPort_node = node.Parameters(strcmp({node.Parameters.Name}, 'SrcPort')).Value;
            else
                srcPort_node = '';
            end
        catch % line branch
            srcPort_node = '';
        end
        
        try
            if any(strcmp({node.Parameters.Name}, 'DstBlock'))
                dstBlock_node = node.Parameters(strcmp({node.Parameters.Name}, 'DstBlock')).Value;
            else
                dstBlock_node = '';
            end
        catch % line branch
            dstBlock_node = '';
        end
        
        try
            if any(strcmp({node.Parameters.Name}, 'DstPort'))
                dstPort_node = node.Parameters(strcmp({node.Parameters.Name}, 'DstPort')).Value;
            else
                dstPort_node = '';
            end
        catch % line branch
            dstPort_node = '';
        end
        
        for i = 1:length(lines)
            if get_param(lines(i), 'LineParent') == -1
                % Line source is a block
                try
                srcHdl = get_param(lines(i), 'SrcPortHandle');
                
                    [~, srcBlock, ~] = fileparts(get_param(srcHdl, 'Parent'));
                    srcPort = num2str(get_param(srcHdl, 'PortNumber'));
                catch
                    % Unconnected line, with no source
                    srcBlock = '';
                    srcPort = '';
                end
            else
                % Line source is a line
                srcBlock = '';
                srcPort = '';
            end
            [~, parentName, ~] = fileparts(get_param(lines(i), 'Parent'));

            try
                % Line destination is a block
                dstHdl = get_param(lines(i), 'DstPortHandle');
                [~, dstBlock, ~] = fileparts(get_param(dstHdl, 'Parent'));
                dstPort = num2str(get_param(dstHdl, 'PortNumber'));
            catch
                % Line destination is multiple lines (i.e., it's a line trunk)
                dstBlock = '';
                dstPort = '';
            end
            
            % Prints for troubleshooting
            %fprintf('%s:%s -> %s:%s', srcBlock_node, srcPort_node, dstBlock_node, dstPort_node)
            %fprintf(' == %s:%s -> %s:%s ', srcBlock, srcPort, dstBlock, dstPort);
            %fprintf(' %s == %s\n', parentName_node, parentName);
            
            sameParent = strcmp(parentName, parentName_node);
            sameSrc = strcmp(srcBlock, srcBlock_node);
            sameSrcPort = strcmp(srcPort, srcPort_node);
            sameDst = strcmp(dstBlock, dstBlock_node);
            sameDestPort = strcmp(dstPort, dstPort_node);
            
            % Check for match
            if sameSrc && sameSrcPort && sameDst && sameDestPort && sameParent
                hdl = lines(i);
                return
            end
        end
    elseif strcmp(type, 'annotation')
         % -- Search for the annotation in the model --
         % Get all annotations in the subsystem
        p = getParentPath(node, sys);
        annotations = find_system(p, 'SearchDepth', '1', 'LookUnderMasks', 'on', 'FindAll', 'on', 'Type', 'annotation');
        
        % Compare the node's Name param with the annotations' Text params
        try
            name_node = node.Parameters(strcmp({node.Parameters.Name}, 'Name')).Value;
        catch
            name_node = '';
        end
        
        for i = 1:length(annotations)
            % Check for match
            if strcmp(name_node, get_param(annotations(i), 'PlainText')) || ...
                    strcmp(name_node, get_param(annotations(i), 'Text')) 
                hdl = annotations(i);
                return
            end
        end
    elseif strcmp(type, 'port')
        % -- Look for the port in the model --
        % Get all ports in the subsystem
        p = getParentPath(node, sys);
        ports = find_system(p, 'SearchDepth', '1', 'FindAll', 'on', 'Type', 'port');
        
        % Compare the node's params with the ports' params
        try
            paramNames  = {node.Parameters.Name};
            paramValues = {node.Parameters.Value};
        catch ME
            if strcmp(ME.identifier, 'MATLAB:structRefFromNonStruct')
                % There are no parameters/values
                paramNames = '';
                paramValues = '';
            else
                rethrow(ME);
            end
        end
        
        for i = 1:length(ports) % For each port
            allParamsSame = true;
            for j = 1:length(paramNames) % For each of its params
                % Param values can be strings, numbers, etc., so we need to
                % compare them appropriately with strcmp or eq
                % TODO: Test with param with vector values like Position
                [num, isNum] = str2num(char(paramValues(j))); 
                if isNum
                    if get_param(ports(i), char(paramNames(j))) ~= num
                        allParamsSame = false;
                        break % Don't check the rest
                    end
                else
                    if ~strcmp(get_param(ports(i), char(paramNames(j))), char(paramValues(j)))
                        allParamsSame = false;
                        break % Don't check the rest
                    end
                end    
            end
            if allParamsSame
                hdl = ports(i);
                return
            end
        end    
    end
end