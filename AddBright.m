function [G, B, R] = AddBright(G, B, R, koeff)
% function corrects the image brightness
    s = 0 + sum(G(:))/numel(G);
    s = s + sum(B(:))/numel(B);
    s = s + sum(R(:))/numel(R);
    k = (koeff * (2-s) / 2) ^ 3;
    G = G * (1 + k);
    B = B * (1 + k);
    R = R * (1 + k);
end

