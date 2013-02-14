function [shiftB, shiftR] = GetShift2( G, B, R, ofst )
% calculating chanels shift using FFT

    GT = G(1+ofst : end-ofst, 1+ofst : end-ofst);
    height = size(GT,1)+size(B,1)-1;
    width = size(GT,2)+size(B,2)-1;

    GT = GT - sum(GT(:)) / numel(GT);
    GG = zeros(height,width);
    GG(1 : size(GT,1), 1 : size(GT,2)) = GT(:,:);
    clear GT;
    
    B = B - sum(B(:)) / numel(B);
    BB = zeros(height,width);
    BB(1 : size(B,1), 1 : size(B,2)) = B(:,:);

    C = ifft2( fft2(BB) .* conj( fft2( GG ) ) );
    C = C(1 : 2*ofst+1, 1 : 2*ofst+1);
    clear BB;
    [val, linind] = max(C(:));
    [i, j] = ind2sub(size(C), linind);
    clear C;
    shiftB = [i-ofst-1, j-ofst-1];
    
    R = R - sum(R(:)) / numel(R);
    RR = zeros(height,width);
    RR(1 : size(R,1), 1 : size(R,2)) = R(:,:);

    C = ifft2( fft2(RR) .* conj( fft2( GG ) ) );
    C = C(1 : 2*ofst+1, 1 : 2*ofst+1);
    clear RR;
    clear GG;
    [val, linind] = max(C(:));
    [i, j] = ind2sub(size(C), linind);
    clear C;
    shiftR = [i-ofst-1, j-ofst-1];
end