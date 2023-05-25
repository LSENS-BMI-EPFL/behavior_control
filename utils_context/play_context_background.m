function noise = play_context_background(block, pink_noise, brown_noise, session)
%PLAY_CONTEXT_BACKGROUND Summary of this function goes here
%   Detailed explanation goes here

if strcmp(block, 'pink')
    if ~ pink_noise.isplaying
        pink_noise.play
        if brown_noise.isplaying
            brown_noise.pause
        end
    end
    outputSingleScan(session,[1])
elseif strcmp(block, 'brown')    
    if ~ brown_noise.isplaying
        brown_noise.play
        if pink_noise.isplaying
            pink_noise.pause
        end
    end
    outputSingleScan(session,[1])
end

end

