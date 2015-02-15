function original_sound_samples = split_original_sound_signal(sound_signal,sound_switch_trigger)

    n = length(sound_switch_trigger);
    sample_size = min(diff(sound_switch_trigger));
    
    original_sound_samples = nan(n, sample_size);
    for i = 1:n
       sample_start = sound_switch_trigger(i);
       sample_end = sample_start + sample_size -1; 
       original_sound_samples(i,:) =  sound_signal(sample_start:sample_end,1);
    end
end