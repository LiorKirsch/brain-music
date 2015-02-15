load('channel_position_MEG.mat')

channel_id = h.channel;
channel_3d_position = chnPos;
channel_2d_position = h.layout.pos(1:248,:);
channel_labels = h.layout.label(1:248);
head_outline = h.layout.outline;

%reorder so everything will be in the same order as channel_id;
[~, reorder] = ismember(channel_id, channel_labels);

channel_2d_position = channel_2d_position(reorder,:);
channel_labels = channel_labels(reorder);


save('channels_positions.mat','channel_3d_position','channel_2d_position','channel_labels','head_outline');
