function [ min_elem ] = StripCorr( GG, BB, RR )
% Calculating strip corellation between chanels;
% returns the min value of corellation
    
    % correlation GG with BB
    Q = GG .* BB;
    GB = sum(Q(:));
    Q = GG .* GG;
    GB = GB / sqrt(sum(Q(:)));
    Q = BB .* BB;
    GB = GB / sqrt(sum(Q(:)));
    % correlation GG with RR
    Q = GG .* RR;
    GR = sum(Q(:));
    Q = GG .* GG;
    GR = GR / sqrt(sum(Q(:)));
    Q = RR .* RR;
    GR = GR / sqrt(sum(Q(:)));
    % correlation BB with RR
    Q = BB .* RR;
    BR = sum(Q(:));
    Q = BB .* BB;
    BR = BR / sqrt(sum(Q(:)));
    Q = RR .* RR;
    BR = BR / sqrt(sum(Q(:)));

    min_elem = min([GR, BR, GB]);
end

