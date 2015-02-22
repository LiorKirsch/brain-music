function  [new_X,new_y,new_original_sound,new_batch_id] = split_into_n_chunks(X,y,n,original_sound,batch_id)
    new_y = repmat(y,1,n)';
    new_y = new_y(:);

    new_batch_id = repmat(batch_id,1,n)';
    new_batch_id = new_batch_id(:);
    
    num_samples = size(X,1);
    new_num_samples = size(X,1) *n ;
    new_timepoint_size = size(X,2) /n  ;
    
    samplers_iterator = 1;
    new_X = nan( new_num_samples ,new_timepoint_size , size(X,3)  );
    new_original_sound = nan( new_num_samples ,new_timepoint_size); 
    for i = 1: num_samples
        timepoint_start = 1;
        for j = 1: n
            timepoint_ends = timepoint_start + new_timepoint_size -1;
            new_X(samplers_iterator,:,:) = X(i, timepoint_start: timepoint_ends ,:);
	    new_original_sound(samplers_iterator,:,:) = original_sound(i, timepoint_start: timepoint_ends);
            timepoint_start = timepoint_ends + 1;
            samplers_iterator = samplers_iterator +1;
        end
    end
    
    assert( ~any(any(any(isnan(new_X)))),'all cell should have a value that is not nan');
%     new_X2 = reshape(X, size(X,1) *n, size(X,2) /n , size(X,3) );
%     all(all(all( new_X == new_X2)))
end
