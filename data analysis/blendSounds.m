function [ meshed_sound ] = blendSounds( songsMat , w)
% blendSounds( songsMat , w) create a sound vector meshed_sound
% this vector is a weighted combination of all songs.
% Inputs:
%  songsMat size is (number_of_songs x samples_in_time)
%  w is a matrix of size (number_of_songs x number_of_time_segments) filled with the weights

    numOfMultiplications = floor(max(size(songsMat))/size(w,2));
    wDuplicated = kron(w,ones(1,numOfMultiplications));
    meshed_sound = sum(songsMat'.*wDuplicated',2);
end

