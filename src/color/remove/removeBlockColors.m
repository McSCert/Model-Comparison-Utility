function removeBlockColors(sys)
% REMOVEBLOCKCOLORS Remove all block coloring from the model.

    allBlks = find_system(sys, 'FollowLinks', 'on', 'type', 'block');
    for i = 1:length(allBlks)
        set_param(allBlks{i}, 'ForegroundColor', 'black');
        set_param(allBlks{i}, 'BackgroundColor', 'white');
    end
end