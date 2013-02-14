function [ corr ] = Corr( A, B )
    Q = A .* B;
    corr = sum(Q(:));
    Q = A .* A;
    corr = corr / sqrt(sum(Q(:)));
    Q = B .* B;
    corr = corr / sqrt(sum(Q(:)));
end

