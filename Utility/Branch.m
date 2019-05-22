classdef Branch < double
% Branch values.
% Note: We assume that the Edits tree is created with the before branch as the
% first argument, and the after branch as the second argument.
    enumeration
        Left(0)      % Before branch.
        Right(1)     % After branch.
        Both(2)      % Both branches.
        NotFound(-1) % Neither branch.
    end
end