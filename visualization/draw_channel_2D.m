function draw_channel_2D(show_channel_name, values)

load('channels_positions.mat');
if ~exist('show_channel_name','var')
    show_channel_name = false;
end

numchannels = size(channel_2d_position,1);

hold on 
for i =1:4
    plot(head_outline{i}(:,1),head_outline{i}(:,2))
end



if exist('values','var')
    assert(length(values) == numchannels ,'if values are specified there should be one value per channel');
    scatter(channel_2d_position(:,1),channel_2d_position(:,2),20,values,'.');
else
    scatter(channel_2d_position(:,1),channel_2d_position(:,2));
end

if show_channel_name
    dx = 0.01; dy = 0.01; % displacement so the text does not overlay the data points
    text(channel_2d_position(:,1)+ dx ,channel_2d_position(:,2)+dy, channel_labels);
end

hold off;
end