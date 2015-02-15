function draw_channel_3D( show_channel_name)

load('channels_positions.mat');

if ~exist('show_channel_name','var')
    show_channel_name = false;
end
   
        

figure;
d = 0.01;
scatter3(channel_3d_position(:,1),channel_3d_position(:,2),channel_3d_position(:,3));
if show_channel_name
    text(channel_3d_position(:,1)+d,channel_3d_position(:,2)+d,channel_3d_position(:,3)+d, channel_labels);
end

end