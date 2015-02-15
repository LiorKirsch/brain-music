addpath('../visualization/');

num_classes = length(uniqueLabels);
mean_auc_per_channel = cell(num_classes,1);
for i = 1:num_classes
    mean_auc_per_channel{i} = cellfun(@(x) mean( x{i} ),aucs);
end


for i = 1:num_classes
    figure('Name',sprintf('Brain scatter for %s', uniqueLabels{i}) )
    draw_channel_2D(false, mean_auc_per_channel{i});
    title(uniqueLabels{i});
    colormap('jet');
    colorbar();
end



