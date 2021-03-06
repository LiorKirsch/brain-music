addpath('~/Projects/general use functions/')

%load the data
fprintf('loading the MEG data into memory\n');
data_folder = get_data_folder();
load( fullfile(data_folder, 'preprocessed_meg_data.mat') );
%%

% fprintf('spliting to smaller samples and reshape the data\n');
% % [X,y,original_sounds,batch_id] = split_into_n_chunks(X,y,n,original_sounds,batch_id);

% % ==== concatenate all channels to one ====
% X_new = reshape(X, size(X,1), size(X,2) * size(X,3) );
 
% 
% fprintf('performing classification using svm \n');
% conf = createConf();
% [single_run_weights, weights, aucs, no_train_aucs] = svm_classification(X_new, y, conf);

%%
 
% [X,y,original_sounds,batch_id] = handle_white_noise_samples('remove noise', X,y,original_sounds,batch_id);
% [X,y,original_sound_samples,batch_id] = handle_white_noise_samples('normalize with noise', X,y,original_sound_samples,batch_id);

conf = createConf();
num_channels = size(X,3);
fprintf('performing classification using svm \n');
weights = cell(num_channels,1) ;
aucs = cell(num_channels,1) ;
models = cell(num_channels,1) ;
[X,y,original_sound_samples,batch_id] = split_into_n_chunks(X,y,conf.split_chunks,original_sound_samples,batch_id);

for i = 1:num_channels
    fprintf('===== channel %d =====\n', i);
    conf.useWeightsToEqualize = false;
    [weights{i}, aucs{i}, models{i}, uniqueLabels] = svm_classification_multi(X(:,:,i), y,batch_id, conf);
%     [weights{i}, aucs{i}, models{i}, uniqueLabels] = svm_classification(X(:,:,i), y,batch_id, conf);
end
filename = create_results_filename(conf);
save(filename, 'aucs', 'models','uniqueLabels','original_sounds','batch_id','y');


