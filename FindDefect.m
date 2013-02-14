function [ BinBlockS ] = FindDefect( im, net )

    BinBlockS = zeros(floor(size(im,1)/net), floor(size(im,2)/net), 3);
    
    for i = 0 : floor( size(im,1)/net ) - 1
        for j = 0 : floor( size(im,2)/net ) - 1
            BlockR = im(1+i*net : (i+1)*net, 1+j*net : (j+1)*net, 1);
            BlockR = BlockR / (sum(BlockR(:))/numel(BlockR));
            BlockR = BlockR - 1;
            BlockG = im(1+i*net : (i+1)*net, 1+j*net : (j+1)*net, 2);
            BlockG = BlockG / (sum(BlockG(:))/numel(BlockG));
            BlockG = BlockG - 1;
            BlockB = im(1+i*net : (i+1)*net, 1+j*net : (j+1)*net, 3);
            BlockB = BlockB / (sum(BlockB(:))/numel(BlockB));
            BlockB = BlockB - 1;

            CGB = Corr(BlockG, BlockB);
            CGR = Corr(BlockG, BlockR);
            CRB = Corr(BlockR, BlockB);
            
            SGB = STD(BlockG, BlockB);
            SGR = STD(BlockG, BlockR);
            SRB = STD(BlockR, BlockB);
            
            k1 = 0.1;
            k2 = 20;
            min_corr = min([CGB, CRB, CGR]);
            if (min_corr < k1)
                Q = [SGB, SRB, SGR];
                [val, ind] = min(Q);
                Q = Q / val;
                if (sum(Q) > k2)
                    BinBlockS(i+1, j+1, ind) = 1;
                end
            end    
        end
    end
end

