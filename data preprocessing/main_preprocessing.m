%load the data
data_folder = '/cortex/users/lior/data/brain_music/';
megdata = load( fullfile(data_folder, 'MEGsongsP1.mat') );
music_metadata = load( fullfile(data_folder, 'longsound.mat') );

%split the data according to the

files_order = music_metadata.sound_indicator;

% find the rect signal and get the indices whenever a change of music was
% made


triggers = get_triggers( megdata.X1, 0.25, 4000);
assert(length(triggers) == length(files_order) , 'number of music files and the trigger should be the same');


[X,y,music_samples_in_meg] = split_to_samples(megdata.MEG', triggers, files_order, megdata.X3);
sampling_rate = megdata.samplingRate;

original_sound_samples = split_original_sound_signal(music_metadata.longSoundFile ,music_metadata.indicator);
original_sound_sampling_rate = music_metadata.fs;

batch_id = add_session_id(files_order);

output_file = fullfile(data_folder, 'preprocessed_meg_data.mat');
save(output_file,'X','y','music_samples_in_meg', 'batch_id', 'sampling_rate','original_sound_samples','original_sound_sampling_rate','-v7.3');
% sound( music_samples(6,:) *10,round(sampling_rate) );
% sound( original_sound_samples(6,:),original_sound_sampling_rate );
