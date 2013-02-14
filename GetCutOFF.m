function [ idx ] = GetCutOFF( vr, koeff )
% analyzing image borders and calculating the cropping coeffs
    idx = 0;
    [min_val, min_idx] = min(vr);
    [max_val, max_idx] = max(vr(min_idx : end));    
    for i = min_idx : min_idx + max_idx - 1
        if (vr(i) >= (min_val*(1-koeff) + max_val*koeff))
            idx = i;
            break;
        end
    end
end

