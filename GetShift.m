function [shiftB, shiftR] = GetShift( G, B, R, x, y, w, h, ofst )
% calculating chanels shift using FFT
    GT = G(y-h+ofst : y+h-ofst, x-w+ofst : x+w-ofst);
    BB = B(y-h : y+h, x-w : x+w);

    height = size(GT,1)+size(BB,1)-1;
    width = size(GT,2)+size(BB,2)-1;

    GT = GT - sum(GT(:)) / numel(GT);
    GGG = zeros(height,width);
    GGG(1 : size(GT,1), 1 : size(GT,2)) = GT(:,:);
    clear GT;

    BB = BB - sum(BB(:)) / numel(BB);
    BBB = zeros(height,width);
    BBB(1 : size(BB,1), 1 : size(BB,2)) = BB(:,:);
    clear BB;

    C = ifft2( fft2(BBB) .* conj( fft2( GGG ) ) );
    C = C(1 : 2*ofst+1, 1 : 2*ofst+1);
    clear BBB;
    [val, linind] = max(C(:));
    [i, j] = ind2sub(size(C), linind);
    clear C;
    shiftB = [i-ofst-1, j-ofst-1];
    
    RR = R(y-h : y+h, x-w : x+w);
    RR = RR - sum(RR(:)) / numel(RR);
    RRR = zeros(height,width);
    RRR(1 : size(RR,1), 1 : size(RR,2)) = RR(:,:);
    clear RR;

    C = ifft2( fft2(RRR) .* conj( fft2( GGG ) ) );
    C = C(1 : 2*ofst+1, 1 : 2*ofst+1);
    clear RRR;
    clear GGG;
    [val, linind] = max(C(:));
    [i, j] = ind2sub(size(C), linind);
    clear C;
    shiftR = [i-ofst-1, j-ofst-1];
end