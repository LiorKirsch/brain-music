function filename = create_results_filename(conf)

num_chunks = sprintf('_%dchunks', conf.split_chunks);
if conf.use_noise_normalize
    noise_norm = '_noiseNorm';
else
    noise_norm = '';
end

if  conf.zero_mean 
    zero_mean = '';
else
    zero_mean = '_noZeroMean';
end

if  conf.unit_var 
    unit_var = '';
else
    unit_var = '_noUnitVar';
end
if conf.useWeightsToEqualize
    weight_eq = '_weightEqalize';
else
     weight_eq = '';
end
filename = sprintf('results/results%s%s%s%s%s.mat', num_chunks, noise_norm, zero_mean, unit_var, weight_eq);
end