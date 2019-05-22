function hilite_system_notopen(sys,hilite,varargin)
%HILITE_SYSTEM_NOTOPEN Highlight a Simulink object.
%   HILITE_SYSTEM_NOTOPEN(SYS) highlights a Simulink object by WITHOUT opening the system
%   window that contains the object and then highlighting the object using the
%   HiliteAncestors property. This is a modification of the original function,
%   described below:
%
%   HILITE_SYSTEM_NOTOPEN(SYS) highlights a Simulink object by first opening the system
%   window that contains the object and then highlighting the object using the
%   HiliteAncestors property.
%
%   You can specify the highlighting options as additional right hand side
%   arguments to HILITE_SYSTEM_NOTOPEN.  Options include:
%
%     default     highlight with the 'default' highlight scheme
%     none        turn off highlighting
%     find        highlight with the 'find' highlight scheme
%     unique      highlight with the 'unique' highlight scheme
%     different   highlight with the 'different' highlight scheme
%     user1       highlight with the 'user1' highlight scheme
%     user2       highlight with the 'user2' highlight scheme
%     user3       highlight with the 'user3' highlight scheme
%     user4       highlight with the 'user4' highlight scheme
%     user5       highlight with the 'user5' highlight scheme
%
%   To alter the colors of a highlighting scheme, use the following command:
%
%     set_param(0, 'HiliteAncestorsData', HILITEDATA)
%
%   where HILITEDATA is a MATLAB structure array with the following fields:
%
%     HiliteType       one of the highlighting schemes listed above
%     ForegroundColor  a color string (listed below)
%     BackgroundColor  a color string (listed below)
%
%   Available colors to set are 'black', 'white', 'red', 'green', 'blue',
%   'yellow', 'magenta', 'cyan', 'gray', 'orange', 'lightBlue', and
%   'darkGreen'.
%
%   Examples:
%
%       % highlight the subsystem 'f14/Controller/Stick Prefilter'
%       HILITE_SYSTEM_NOTOPEN('f14/Controller/Stick Prefilter')
%
%       % highlight the subsystem 'f14/Controller/Stick Prefilter'
%       % in the 'error' highlighting scheme.
%       HILITE_SYSTEM_NOTOPEN('f14/Controller/Stick Prefilter', 'error')
%
%   See also OPEN_SYSTEM, FIND_SYSTEM, SET_PARAM

%   Copyright 1990-2009 The MathWorks, Inc.
%   $Revision: 1.9.2.7 $

%
% Massage the input data for easier management below:
%   chars  --> cell arrays
%   scalar --> vector of length 2 with repeate of scalar (a hack, yes, but
%              it does make things simpler...)
%
if ischar(sys),
  sys = { sys, sys };
elseif iscell(sys) && (length(sys) == 1),
  sys = { cell2mat(sys(1)), cell2mat(sys(1)) };
elseif isreal(sys) && (length(sys) == 1),
  sys = [sys sys];
end

%
% It's easier to use handles instead of strings, it simplifies things
% in the code below
%
sys = get_param(sys,'Handle');
sys = [ sys{:} ];

% Unfortunately, port highlighting is currently not
% supported. If possible, we use a connected segment.
% Otherwise, we return unsuccessfully. See g411096.
ports = find(strcmp(get_param(sys,'type'),'port'));
if(~isempty(ports))
    portLines =  get_param(sys(ports),'Line');
    if(~eq(portLines{1}, -1) && ~eq(portLines{2},-1))
        if iscell(portLines),
          sys(ports) = [ portLines{:} ];
        else
          sys(ports) = portLines;
        end
    else
        return;
    end
end

%
% Construct a list of parent windows for each of the specified objects
%
parents = get_param(sys,'Parent');

%
% Weed out objects with no parent, they're models
%
mdls = find(strcmp(parents,''));
parents(mdls) = [];
sys(mdls) = [];

%
% Set the HiliteAncestors property for each of the blocks
%
if nargin == 1,
  hilite = 'on';
end

hiliteArgs = { 'HiliteAncestors', hilite };

%
% For each 'sys', set the HiliteAncestors property
%
for i = 1:length(sys),
  set_param(sys(i), hiliteArgs{:},varargin{:});
end

% Scroll and zoom the window so that our objects are visible. Don't allow
% the window to zoom out to more than 100% (for backwards compatibility).
% Simulink.scrollToVisible(sys,false);