function t = treeToTable(root)
% TREETOTABLE Produce a table of nodes from the comparison tree.
%
%   Inputs:
%       root        xmlcomp.Edits object.
%
%   Outputs:
%       t           Table.
%
%   Example:
%       >> Edits = slxmlcomp.compare('demo_after', 'demo_before');
%       >> t = classifyChanges(Edits)
%t =
%
%  13x5 table
%
%          nodes                                 path                           changeType     nodeType          blockType     
%    __________________    ________________________________________________    ____________    _________    ___________________
%
%    [1x1 xmlcomp.Node]    {'demo_after/Subsystem/Data Store↵Memory'     }    {'deleted' }    {'block'}    {'DataStoreMemory'}
%    [1x1 xmlcomp.Node]    {'demo_after/Subsystem/Subsystem/Add'          }    {'modified'}    {'block'}    {'Sum'            }
%    [1x1 xmlcomp.Node]    {'demo_after/Subsystem/Subsystem/Constant'     }    {'modified'}    {'block'}    {'Constant'       }
%    [1x1 xmlcomp.Node]    {'demo_after/Subsystem/Subsystem/Gain'         }    {'deleted' }    {'block'}    {'Gain'           }
%    [1x1 xmlcomp.Node]    {'demo_after/Subsystem/Subsystem/NewName'      }    {'renamed' }    {'block'}    {'Outport'        }
%    [1x1 xmlcomp.Node]    {'demo_after/Subsystem/Subsystem/In2/1'        }    {'deleted' }    {'line' }    {0x0 char         }
%    [1x1 xmlcomp.Node]    {'demo_after/Subsystem/Subsystem/Gain/1'       }    {'deleted' }    {'line' }    {0x0 char         }
%    [1x1 xmlcomp.Node]    {'demo_after/Subsystem/Subsystem/Add'          }    {'modified'}    {'block'}    {'Sum'            }
%    [1x1 xmlcomp.Node]    {'demo_after/Subsystem/Subsystem/Constant'     }    {'modified'}    {'block'}    {'Constant'       }
%    [1x1 xmlcomp.Node]    {'demo_before/Subsystem/Subsystem/Out1'        }    {'renamed' }    {'block'}    {'Outport'        }
%    [1x1 xmlcomp.Node]    {'demo_before/Subsystem/Subsystem/Integrator'  }    {'added'   }    {'block'}    {'Integrator'     }
%    [1x1 xmlcomp.Node]    {'demo_before/Subsystem/Subsystem/In2/1'       }    {'added'   }    {'line' }    {0x0 char         }
%    [1x1 xmlcomp.Node]    {'demo_before/Subsystem/Subsystem/Integrator/1'}    {'added'   }    {'line' }    {0x0 char         }

    % Validate inputs
    try
        assert(isa(root, 'xmlcomp.Edits'))
    catch
        message = 'Node argument must be an xmlcomp.Edits object.';
        error(message)
    end
    
    % Find all nodes that are actual changes
    nodes = find_node(root, 'ChangeType', {'added', 'deleted', 'modified', 'renamed'});
    
    % Initialize outputs
    changeType = cell(size(nodes));
    path       = cell(size(nodes));
    nodeType   = cell(size(nodes));
    blockType  = cell(size(nodes));
    
    % For each change
    for i = 1:length(nodes)
        changeType{i} = getNodeChangeType(nodes(i), root);
        
        % Get handle in model
        hdl = getHandle(nodes(i), root.LeftFileName);
        if isempty(hdl)
            hdl = getHandle(nodes(i), root.RightFileName);
        end
        
        % Get path in model
        path{i} = getfullname(hdl);
        if isempty(path{i})
            path{i} = '';
        end
        
        % Get node type
        nodeType{i} = get_param(hdl, 'Type');
        if isempty(nodeType{i})
            nodeType{i} = getNodeType(nodes(i), root.LeftFileName);
        end
        if isempty(nodeType{i})
            nodeType{i} = getNodeType(nodes(i), root.RightFileName);
        end
        if isempty(nodeType(i))
            nodeType{i} = '';
        end
        
        % Get block type
        if strcmp(nodeType{i}, 'block')
            blockType{i} = get_param(hdl, 'BlockType');
        else
            blockType{i} = '';
        end
    end
    
    t = table(nodes, path, changeType, nodeType, blockType);
end