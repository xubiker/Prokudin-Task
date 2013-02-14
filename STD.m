function [ std ] = STD( A, B )
    T = A - B;
    T = T .* T;
%    std = sqrt( sum(T(:)) / numel(T) );
    std = sum(T(:)) / numel(T);
end

