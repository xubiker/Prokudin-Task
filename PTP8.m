function [] = PTP8(in_name, out_name, extension)
    %---------------------------------------------- initial parametres ----
    to_cropp = 1;
    postprocess = 1;
    zones_num = 4;
    pyramid_levels = 4;
    tic;
    %------------------------------------------------ opening image -------
    display('opening image');
    fullim = imread(in_name);
            % check if the grayscale image is yet a colored one
    if ndims(fullim) == 3
        fullim = fullim(:,:,1);
    end
    fullim = im2double(fullim);
    display('done');
    %---------------------------------------------- splitting channels ----
    display('splitting channels');
    overlap = floor(size(fullim,1)*0.01);
    height = floor(size(fullim,1)/3);
    B = fullim(1 : height+overlap*2, 1 : end);
    G = fullim(height-overlap+1 : height*2+overlap, 1 : end);
    R = fullim(height*2-overlap*2+1 : height*3, 1 : end);
    clear fullim;
    display('done');
    %---------------\\\ searching for shift in case of small image ///-----
    if numel(G)*0.6*0.6 < 140000
        x = floor(size(G,2)*0.5);
        y = floor(size(G,1)*0.5);
        w = floor(size(G,2)*0.3);
        h = floor(size(G,1)*0.3);
        ofst = floor(size(G,1)*0.1);
        [shiftB, shiftR] = GetShift(G, B, R, x, y, w, h, ofst);
        B = circshift(B, -shiftB);
        R = circshift(R, -shiftR);
    else
    %----------------\\\ searching for shift in case of big image ///------
        display('searching for special zones');
        [x, y] = GetZones(G, B, R, 6, 8, zones_num);
        display('done');
        display('shift searching');
        [G, B, R] = Pyramid( G, B, R, pyramid_levels, x, y, zones_num);
        display('done');
    end
    %---------------------------------------------------- cropping --------
    if (to_cropp == 1)
        display('cropping image');
        [Left, Right, Top, Bottom] = GetBorder(G, B, R, 1, 80, 20, 0.5);
        G = G(Top : Bottom, Left : Right);
        B = B(Top : Bottom, Left : Right);
        R = R(Top : Bottom, Left : Right);
        display('done');
    end
    %------------------------------------------------ post processing -----
    if (postprocess == 1)
        display('postprocessing image');
        [G, B, R] = AddContrast(G, B, R, 0.85);
        [G, B, R] = AddBright(G, B, R, 0.8);
        display('done');
    end
    %---------------------------------------------- downmixing channels ---
    display('downmixing chanels');
    im = cat (3, R, G, B);
    clear B; clear R; clear G;
    display('done');
    %------------------------------------------------- saving result ------
    display('saving result image');
    imwrite(im, out_name, extension);
    display('done');
    toc;
    tmp = input('Do you want to execute an inpainting function? (y/n): ', 's');
    if (tmp == 'y') 
        display('OK. But it is not so fast');
        outn = input('Please, enter the results image name: ', 's');
        extn = input('Please, enter the results image extension: ', 's');
        InPaint(out_name, outn, extn);
    elseif (tmp == 'n')
        display('OK. That is it. Thanks');
    else
        display('OK. That is it. Thanks');
    end
end