function [X,y,original_sounds,batch_id] = handle_white_noise_samples(what_to_do, X,y,original_sounds,batch_id)

%     what_to_do = {'remove noise' ,'normalize with noise'}

    num_batches = max(batch_id);
    noise_samples = strcmp('noise.wav', y);
    
    disp('seperating the white noise samples from the music samples')
    X_noise = X(noise_samples, :, :);
    batch_id_noise = batch_id(noise_samples);
    
    X = X(~noise_samples, :, :);
    original_sounds = original_sounds(~noise_samples,:);
    batch_id = batch_id(~noise_samples);
    y = y(~noise_samples);
    
    if strcmp(what_to_do ,'normalize with noise' )
        disp('normalizing each sample using the activity in the white noise sounds in the begining of each session')
        for i =1:num_batches
            noise_samples_from_batch = batch_id_noise==i;
            mean_noise_activity = mean(X_noise(noise_samples_from_batch,:,:),1);
            std_noise_activity = std(X_noise(noise_samples_from_batch,:,:),1,1);
            
            samples_from_batch = batch_id==i;
            num_samples_in_batch = sum(samples_from_batch);
            X(samples_from_batch,:,:) = X(samples_from_batch,:,:) - repmat(mean_noise_activity, num_samples_in_batch,1,1);
            X(samples_from_batch,:,:) = X(samples_from_batch,:,:) ./ repmat(std_noise_activity, num_samples_in_batch,1,1);
            
        end

    end
    
end