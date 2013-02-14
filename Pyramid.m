function [ G, B, R ] = Pyramid( G, B, R, scale, x, y, zones_num )
% Pyramid algorithm realization
    offset = floor (200 / scale);
    sw = floor( size (G,2) * 0.25 / scale );
    sh = floor( size (G,1) * 0.25 / scale );
    
    while scale >= 1
        shiftBres = 0;
        shiftRres = 0;
        if scale ~= 1
            GT = imresize(G, 1/scale);
            BB = imresize(B, 1/scale);
            RR = imresize(R, 1/scale);
        end
        for p = 1 : zones_num
            % there is no need to copy the whole layer
            if scale == 1
                [shiftB, shiftR] = GetShift(G, B, R, floor(x(p)/scale), floor(y(p)/scale), sw, sh, offset);
            else
                [shiftB, shiftR] = GetShift(GT, BB, RR, floor(x(p)/scale), floor(y(p)/scale), sw, sh, offset);
            end
            shiftBres = shiftBres + shiftB;
            shiftRres = shiftRres + shiftR;
        end
        shiftBres = floor (shiftBres / zones_num);
        shiftRres = floor (shiftRres / zones_num);
        B = circshift(B, -scale * shiftBres);
        R = circshift(R, -scale * shiftRres);
        scale = scale / 2;
        offset = 2;
    end
    if scale ~= 1
        clear BB; clear RR; clear GT;
    end
end

