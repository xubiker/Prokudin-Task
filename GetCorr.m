function [corr] = GetCorr( A, B, ofst )
    T = A(1+ofst : end-ofst, 1+ofst : end-ofst);

    height = size(T,1)+size(B,1)-1;
    width = size(T,2)+size(B,2)-1;

    T = T - sum(T(:)) / numel(T);
    TT = zeros(height,width);
    TT(1 : size(T,1), 1 : size(T,2)) = T(:,:);
    clear T;

    B = B - sum(B(:)) / numel(B);
    BB = zeros(height,width);
    BB(1 : size(B,1), 1 : size(B,2)) = B(:,:);
    clear B;

    C = ifft2( fft2(BB) .* conj( fft2( TT ) ) );
    clear TT;
    C = C(1 : 2*ofst+1, 1 : 2*ofst+1);
    clear BB;
    corr = max(C(:));
    clear C;
end