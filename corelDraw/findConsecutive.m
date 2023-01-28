function [firstStart, firstEnd, lastStart, lastEnd] = findConsecutive(data, n)
    firstStart = 0;
    firstEnd = 0;
    lastStart = 0;
    lastEnd = 0;
    count = 0;
    for i = 2:length(data)
        if data(i) == data(i-1) + 1
            if count == 0
                if firstStart == 0
                    firstStart = i-1;
                end
                lastStart = i-1;
            end
            count = count + 1;
            if count == n-1
                if firstEnd == 0
                    firstEnd = i;
                end
                lastEnd = i;
            end
        else
            count = 0;
        end
    end
end
