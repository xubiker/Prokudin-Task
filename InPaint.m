function [ ] = InPaint( in_name, out_name, extension )
% detecting zones with defects and removing found defects
%-------------------------------------------------  opening image  --------
    tic;
    display('opening image');
    im = imread(in_name);
    im = im2double(im);
%----------------------------------------------------  parameters  --------
    ofst = 10;
    net = 4;
    wd = 1.5;
    BSizeNet = 32;
    BSize = net * BSizeNet;
%-----------------------------------  calculating additional parameters  --
    numH = floor((size(im,1)-2*ofst-1)/BSize+1);
    numW = floor((size(im,2)-2*ofst-1)/BSize+1);
    top_limit = size(im,1) - ofst - BSize + 1;
    left_limit = size(im,2) - ofst - BSize + 1;
    Bin = zeros( size(im,1), size(im,2), 3 );
%------------------------------------------------  detecting defects  -----    
    display('detecting defects');
    display('        Be patient, please. It may take several minutes =)');
    for i = 1 : numH
        top = min(1 + ofst + BSize * (i-1), top_limit);
        for j = 1 : numW
            left = min(1 + ofst + BSize * (j-1), left_limit);
            Block = im(top : top + BSize - 1, left : left + BSize - 1, : );
            %----------------------------------  block channel matching  --
            [shiftB, shiftR] = GetShift2(Block(:,:,2), Block(:,:,3), Block(:,:,1), ofst);
            Block(:,:,1) = im( top+shiftR(1) : top+shiftR(1)+BSize-1, left+shiftR(2) : left+shiftR(2)+BSize-1, 1 );
            Block(:,:,3) = im( top+shiftB(1) : top+shiftB(1)+BSize-1, left+shiftB(2) : left+shiftB(2)+BSize-1, 3 );
            BinBlockS = FindDefect(Block, net);
            %----------------------------------  filtering found zones  ---
            BinBlock = zeros(BSizeNet*net, BSizeNet*net, 3);
            fltr = [1,1,1; 1,0,1; 1,1,1];
            Q = im2bw(imfilter(BinBlockS(:,:,1), fltr));
            BinBlock(:,:,1) = imresize(BinBlockS(:,:,1) .* Q, net, 'nearest');
            Q = im2bw(imfilter(BinBlockS(:,:,2), fltr));
            BinBlock(:,:,2) = imresize(BinBlockS(:,:,2) .* Q, net, 'nearest');
            Q = im2bw(imfilter(BinBlockS(:,:,3), fltr));
            BinBlock(:,:,3) = imresize(BinBlockS(:,:,3) .* Q, net, 'nearest');
            %------------------------ coping small mask to the total one --
            Bin(top : top+BSize-1, left : left+BSize-1, 2) = BinBlock(:,:,2);
            Bin(top+shiftR(1) : top+shiftR(1)+BSize-1, left+shiftR(2) : left+shiftR(2)+BSize-1, 1) = BinBlock(:,:,1);
            Bin(top+shiftB(1) : top+shiftB(1)+BSize-1, left+shiftB(2) : left+shiftB(2)+BSize-1, 3) = BinBlock(:,:,3);
         end
    end
    display('done');
%---------------------------------------------  widening defect zones  ----
    se = strel('disk', floor(wd * net));
    Bin(:,:,1) = imdilate(Bin(:,:,1),se);
    Bin(:,:,2) = imdilate(Bin(:,:,2),se);
    Bin(:,:,3) = imdilate(Bin(:,:,3),se);
%----------------------------------------------  preparing mask  ----------
    Bin = imcomplement(Bin);
    Bin = Bin / 0;
    Bin(isinf(Bin)) = 1;
%----------------------------------------  applying mask to the image  ----
    im(:,:,1) = im(:,:,1) .* Bin(:,:,1);
    im(:,:,2) = im(:,:,2) .* Bin(:,:,2);
    im(:,:,3) = im(:,:,3) .* Bin(:,:,3);
    clear Bin;
%--------------------------------------------------------  inpainting  ----
    display('inpainting started');
    display('        Be patient, please. It may take even more time =)');
    im(:,:,1) = inpaint_nans(im(:,:,1));
    im(:,:,2) = inpaint_nans(im(:,:,2));
    im(:,:,3) = inpaint_nans(im(:,:,3));
    display('done');
%-------------------------------------------------------- saving result  --
    display('saving result image');
    imwrite(im, out_name, extension);
    display('done');
    toc
    display('OK. That is it. Thanks');
end
