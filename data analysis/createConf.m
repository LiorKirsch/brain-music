function conf = createConf()
    conf.C = power(10,[-7:2])';
    conf.random_seed = 42;
    
    conf.zero_mean = true;
    conf.unit_var = true;
    conf.sparse = false;
    conf.useWeightsToEqualize = true;
    conf.useProbabilties = false;
    
    conf.only_one_cross_val = false;
%     conf.C = ([1000])';

%     conf.log_level = 'debug';
    conf.log_level = 'clean';
    
    conf.split_chunks = 10;
    % conf.split_chunks = 1;
    conf.use_noise_normalize = true;
end