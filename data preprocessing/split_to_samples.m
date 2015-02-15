function [X,y,music_samples] = split_to_samples(megdata, sample_triggers, sample_id, music_signal)
    % Parses the continuous meg signal into to samples and labels
    %
    % megdata         - the actuall meg data of dimentions   [time X channels]
    % sample_triggers - holds the bin where each trigger starts
    % sample_id       - holds the identifier for each sample
    % music_signal    - the music which was played

    [total_time, num_channels] = size(megdata);
    assert(total_time == length(music_signal) ,'the number of timepoint recorded by the meg and the timepoints for the music signal should be the same');
    n = length(sample_triggers);
    assert(n== length(sample_id) ,'the number of labels and the number of triggers should be the same');
    sample_size = 10000;
    
    minimum_diff = min(diff(sample_triggers));
    assert( sample_size < minimum_diff, 'all samples should have at least "sample_size" timepoints' );
    start_after = floor( (minimum_diff - sample_size) / 2 ) ;

    X = nan(n, sample_size, num_channels);
    music_samples = nan(n, sample_size);
    for i = 1:n
       sample_start = sample_triggers(i) + start_after;
       sample_end = sample_start + sample_size -1; 
       X(i,:,:) =  megdata(sample_start:sample_end,:);
       music_samples(i,:) = music_signal(sample_start:sample_end);
    end
    y = sample_id;
end