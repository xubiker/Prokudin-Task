function [G, B, R] = AddContrast(G, B, R, koeff)
% increasing the image contrast
    s1 = stretchlim(G);
    s2 = stretchlim(B);
    s3 = stretchlim(R);
    G = imadjust(G, [s1(1)*koeff, 1-(1 - s1(2))*koeff], []);
    B = imadjust(B, [s2(1)*koeff, 1-(1 - s2(2))*koeff], []);
    R = imadjust(R, [s3(1)*koeff, 1-(1 - s3(2))*koeff], []);
    clear s1;
    clear s2;
    clear s3;
end

