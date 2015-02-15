function triggers = get_triggers(trigger_channel, trigger_treshold, mix_diff_between_triggers)
% Get the triggers time
% 1. Treshold the trigger data to find the start in the rise of the spike
% 2. Check that the differances between the places above the spike are above a differance treshold
% get those triggers.


    trigger_channel_above_threshold = trigger_channel > trigger_treshold;
    inds_above_treshold = find(trigger_channel_above_threshold);
    diff_inds = diff(inds_above_treshold);
    right_size_diff = diff_inds > mix_diff_between_triggers;

    right_inds = [true, right_size_diff];
    triggers = inds_above_treshold(right_inds);

%     plot(diff(trigers));

%     trigger_bool = false(length(megdata.X1),1);
%     trigger_bool(trigers) = true;
%     subplot(2,1,1);
%     plot(megdata.X3)
%     xlim([0,175400])
%     % xlim([2540007,Inf])
%     subplot(2,1,2);
%     % plot(inds)
%     plot(trigger_bool);
%     xlim([0,175400])
%     % xlim([2540007,Inf])

end