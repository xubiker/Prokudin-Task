function [Left, Right, Top, Bottom] = GetBorder( G, B, R, Step, Strip, MaxNoiseStrip, cut_koeff )
% Calculating cropping coordinates
    Left = 1;
    Right = size(G,2);
    Top = 1;
    Bottom = size(G,1);
    VerStrip = floor((size(G,1) - size(G,1)*Strip/100) / 2);
    HorStrip = floor((size(G,2) - size(G,2)*Strip/100) / 2);
    VerStep = floor(size(G,1)*Step/100);
    HorStep = floor(size(G,2)*Step/100);

    vctrBottom = zeros(floor(MaxNoiseStrip/Step),1);
    for i = 1 : floor(MaxNoiseStrip/Step)
        GG = G(Bottom-VerStep : Bottom, HorStrip : end-HorStrip);
        GG = GG - sum(GG(:)) / numel(GG);
        BB = B(Bottom-VerStep : Bottom, HorStrip : end-HorStrip);
        BB = BB - sum(BB(:)) / numel(BB);
        RR = R(Bottom-VerStep : Bottom, HorStrip : end-HorStrip);
        RR = RR - sum(RR(:)) / numel(RR);
        
        Bottom = Bottom - VerStep;
        vctrBottom(i) = StripCorr(GG, BB, RR);
    end
    indx = GetCutOFF(vctrBottom, cut_koeff);
    Bottom = size(G,1) - indx * VerStep;
    vctrTop = zeros(floor(MaxNoiseStrip/Step),1);
    for i = 1 : floor(MaxNoiseStrip/Step)
        GG = G(Top : Top+VerStep, HorStrip : end-HorStrip);
        GG = GG - sum(GG(:)) / numel(GG);
        BB = B(Top : Top+VerStep, HorStrip : end-HorStrip);
        BB = BB - sum(BB(:)) / numel(BB);
        RR = R(Top : Top+VerStep, HorStrip : end-HorStrip);
        RR = RR - sum(RR(:)) / numel(RR);
        
        Top = Top + VerStep;
        vctrTop(i) = StripCorr(GG, BB, RR);
    end
    indx = GetCutOFF(vctrBottom, cut_koeff);
    Top = indx * VerStep;
    vctrLeft = zeros(floor(MaxNoiseStrip/Step),1);
    for i = 1 : floor(MaxNoiseStrip/Step)
        GG = G(VerStrip : end-VerStrip, Left : Left+HorStep);
        GG = GG - sum(GG(:)) / numel(GG);
        BB = B(VerStrip : end-VerStrip, Left : Left+HorStep);
        BB = BB - sum(BB(:)) / numel(BB);
        RR = R(VerStrip : end-VerStrip, Left : Left+HorStep);
        RR = RR - sum(RR(:)) / numel(RR);
        
        Left = Left + HorStep;
        vctrLeft(i) = StripCorr(GG, BB, RR);
    end
    indx = GetCutOFF(vctrLeft, cut_koeff);
    Left = indx * HorStep;
    vctrRight = zeros(floor(MaxNoiseStrip/Step),1);
    for i = 1 : floor(MaxNoiseStrip/Step)
        GG = G(VerStrip : end-VerStrip, Right-HorStep : Right);
        GG = GG - sum(GG(:)) / numel(GG);
        BB = B(VerStrip : end-VerStrip, Right-HorStep : Right);
        BB = BB - sum(BB(:)) / numel(BB);
        RR = R(VerStrip : end-VerStrip, Right-HorStep : Right);
        RR = RR - sum(RR(:)) / numel(RR);
        
        Right = Right - HorStep;
        vctrRight(i) = StripCorr(GG, BB, RR);
    end
    indx = GetCutOFF(vctrRight, cut_koeff);
    Right = size(G,2) - indx * HorStep;
end