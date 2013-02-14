function [ x, y ] = GetZones( G, B, R, numVer, numHor, cnt )
% function sorts image zones for further shift searching
    BorderVer = floor(size(G,1)*0.3);
    BorderHor = floor(size(G,2)*0.3);
    sizeVer = floor((size(G,1)-2*BorderVer)/numVer);
    sizeHor = floor((size(G,2)-2*BorderHor)/numHor);
    D = zeros(numVer, numHor);
    for i = 1 : numVer
        for j = 1 : numHor
            GG = G(BorderVer+(i-1)*sizeVer : BorderVer+i*sizeVer, BorderHor+(j-1)*sizeHor : BorderHor+j*sizeHor);
            GG = GG + B(BorderVer+(i-1)*sizeVer : BorderVer+i*sizeVer, BorderHor+(j-1)*sizeHor : BorderHor+j*sizeHor);
            GG = GG + R(BorderVer+(i-1)*sizeVer : BorderVer+i*sizeVer, BorderHor+(j-1)*sizeHor : BorderHor+j*sizeHor);
            GG = GG/3;
            GGG = GG.*GG;
            D(i,j) = sum(GGG(:)) - (sum(GG(:))^2)/numel(GG);
            clear GG;
            clear GGG;
        end
    end
    x = zeros(1,cnt);
    y = zeros(1,cnt);
    for q = 1 : cnt
        [val, linind] = max(D(:));
        [i, j] = ind2sub(size(D), linind);
        D(i,j) = 0;
        x(q) = floor(BorderVer+(i-1)*sizeVer+sizeVer*0.5);
        y(q) = floor(BorderHor+(j-1)*sizeHor+sizeHor*0.5);
    end
end

