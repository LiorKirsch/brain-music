function main()

num_blocks = 30; % 30 for 40 minutes run;
soundFiles = {'fix_funky.wav','fix_hit me baby.wav','fix_queen2.wav','fix_take5.wav','fix_haleluia.wav','fix_sandman.wav','fix_tocata.wav'};
whiteNoiseFile = 'fix_noise.wav';
output_folder = 'output';
%set random seed
rng('default');
rng(1);

[sounds, white_noise, sound_length, noise_length, fs] = load_sounds(soundFiles, whiteNoiseFile);

longSoundFile = cell(num_blocks,1);
indicator = cell(num_blocks,1);
sound_indicator = cell(num_blocks,1);
for i=1:num_blocks
    current_output_wav = sprintf('%s/block%d.wav',output_folder,i);
    [longSoundFile{i}, indicator{i}, sound_indicator{i}] = build_long_sound(sounds, soundFiles, white_noise,  sound_length,noise_length, 1);
    fprintf('==== %s ====\n', current_output_wav);
    display_playlist(indicator{i}, sound_indicator{i},fs );
    % sound( longSoundFile{i},fs );
    audiowrite(current_output_wav,longSoundFile{i},fs);
end

save('longsound_in_blocks.mat','longSoundFile','indicator','sound_indicator','fs');
end

function [sounds, white_noise, sound_length, noise_length, fs] = load_sounds(soundFiles, whiteNoiseFile)
    num_sounds = length(soundFiles);
    sounds = cell(num_sounds,1);
    sound_length = nan(num_sounds,1);
    fs = nan(num_sounds,1);

    for i = 1:num_sounds
        filename = fullfile('mp3 10 sec wav', soundFiles{i} );
        [sounds{i},fs(i)] = audioread(filename);
        sound_length(i) = length(sounds{i})/fs(i);
        fprintf('%s length is %g\n', soundFiles{i} , sound_length(i) );
    %     sounds{i} = sounds{i} / std(sounds{i}); % normalize to unit variance
    end
    [white_noise,fs] = audioread(fullfile('mp3 10 sec wav/', whiteNoiseFile));
    noise_length = length(white_noise)/fs;
    fprintf('noise length is %g\n', noise_length );
end

function [longSoundFile, indicator, sound_indicator] = build_long_sound(sounds, soundFiles, white_noise,  sound_length,noise_length, num_blocks)
    num_sounds = length(soundFiles);
    block_length = noise_length + sum(sound_length); 
    fprintf('creating a playlist with %d blocks (each %g sec, total %g sec (%g min))\n',  num_blocks, block_length, block_length*num_blocks, block_length*num_blocks/60);
    longSoundFile = [];
    indicator = [1];
    sound_indicator = {};
    for i = 1:num_blocks
        perm = randperm(num_sounds);

        longSoundFile = [longSoundFile ; white_noise];
        indicator = [indicator; indicator(end) + length(white_noise) ];
        sound_indicator = [sound_indicator ; {'noise.wav'} ];
        for j = 1:num_sounds
            longSoundFile = [longSoundFile;  sounds{ perm(j) }];
            sound_indicator = [sound_indicator ; soundFiles(perm(j)) ];
            indicator = [indicator; indicator(end) + length(sounds{ perm(j) }) ];
        end
    end
    indicator = indicator(1:end-1);
end

function display_playlist(indicator, sound_indicator,fs )
    for i = 1: length(indicator)
       fprintf('%g  (%d)\t %s\n', indicator(i) / fs, indicator(i), sound_indicator{i} );
    end
end