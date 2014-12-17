function main()

num_blocks = 2; % 30 for 40 minutes run;
soundFiles = {'funky.wav','hit me baby.wav','queen2.wav','take5.wav','haleluia.wav','sandman2.wav','tocata.wav'};
whiteNoiseFile = {'noise.wav'};

%set random seed
rng('default');
rng(1);

[sounds, white_noise, sound_length, noise_length, fs] = load_sounds(soundFiles, whiteNoiseFile);

[longSoundFile, indicator, sound_indicator] = build_long_sound(sounds, soundFiles, white_noise,  sound_length,noise_length, num_blocks);

display_playlist(indicator, sound_indicator,fs );
% sound( longSoundFile,fs(1) );
audiowrite('output.wav',longSoundFile,fs(1));
save('longsound.mat','longSoundFile','indicator','sound_indicator','fs');
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
%         sounds{i} = sounds{i} / (100*std(sounds{i})); % normalize to unit variance
%         sound( sounds{i},fs(i) );
    end
    [white_noise,fs] = audioread('mp3 10 sec wav/noise.wav');
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