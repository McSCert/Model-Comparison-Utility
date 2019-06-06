function removeAnnotationColors(sys)
% REMOVEANNOTATIONCOLORS Remove all block coloring from the model.

    ann = find_system(sys, 'FindAll', 'on', 'FollowLinks', 'on', 'type', 'annotation');
    for i = 1:length(ann)
        set_param(ann(i), 'ForegroundColor', 'black');
        set_param(ann(i), 'BackgroundColor', 'white');
    end
end