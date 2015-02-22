function normalizedData = normalizeZeroMeanUnitVariance(data,conf)
    [num_samples, num_features] = size(data);
    normalizedData = data;
    if conf.zero_mean
        fprintf('normalizing the data to have zero mean\n');
        normalizedData = normalizedData - repmat(mean(normalizedData,2),1,num_features );
    end
    
    if conf.unit_var
        fprintf('normalizing the data to have unit variance\n');
        normalizedData = normalizedData ./ repmat( std(normalizedData,0,2),1,num_features );
    end
end