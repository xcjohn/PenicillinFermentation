function [modeDelay] = transDelay(actmode,delay)
modeDelay= actmode;
for i = 1:size(actmode,2)
    if i>delay
        if actmode(i) == 0
            if sum(actmode(i-delay:i)) == 0
                modeDelay(i) = 0;
            else
                modeDelay(i)=actmode(i-delay);
            end            
        end
    end
end
end