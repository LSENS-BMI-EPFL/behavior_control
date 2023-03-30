function [pink_noise_player, brown_noise_player] = create_context_background_noise(bckg_noise_directory)
%CREATE_CONTEXT_BACKGROUND_NOISE Summary of this function goes here
%   Detailed explanation goes here

[pink_noise, pink_SR] = audioread(strcat(bckg_noise_directory, '\pink_noise.wav'));
pink_noise_player = audioplayer(pink_noise, pink_SR);

[brown_noise, brown_SR] = audioread(strcat(bckg_noise_directory, '\brown_noise.wav'));
brown_noise_player = audioplayer(brown_noise, brown_SR);

end

