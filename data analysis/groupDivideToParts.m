function samplesDivide = groupDivideToParts(K,sample_group_ind)
% Divides the data into K chunks where sample that belong to a group must be in the same chunk

    num_samples = length(sample_group_ind);
    unique_groups = unique(sample_group_ind);
    [~, sample_group_ind] = ismember(sample_group_ind, unique_groups);
    num_groups = length(unique_groups);
    
    assert(K <= num_groups,'there should be more groups than K');
    groupsDivide = randomDivideToParts(num_groups,K);
    
    groupsDivide = double(groupsDivide) * ((1:K)');
    
    samplesDivide = groupsDivide(sample_group_ind);
    
    samplesDivide = sparse(1:num_samples, samplesDivide, ones(num_samples,1), num_samples, K);
    samplesDivide = full(logical(samplesDivide));
end
    