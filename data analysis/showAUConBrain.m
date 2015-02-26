addpath('../visualization/');


mean_auc_per_channel = cellfun(@(x) mean( x ),aucs);

figure('Name',sprintf('Brain accuracy for %s', uniqueLabels{i}) )
draw_channel_2D(false, mean_auc_per_channel);
title('accuracy');
colormap('jet');
colorbar();





% num_classes = length(uniqueLabels);
% mean_auc_per_channel = cell(num_classes,1);
% for i = 1:num_classes
%     mean_auc_per_channel{i} = cellfun(@(x) mean( x{i} ),aucs);
% end
% 
% 
% for i = 1:num_classes
%     figure('Name',sprintf('Brain scatter for %s', uniqueLabels{i}) )
%     draw_channel_2D(false, mean_auc_per_channel{i});
%     title(uniqueLabels{i});
%     colormap('jet');
%     colorbar();
% end



