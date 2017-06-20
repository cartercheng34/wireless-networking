function weight = WD(F, P, B, Fmax, Pmax, Bmax, Fmin, Pmin, Bmin )
% F: performance of network (SINR)
% P: power consumption
% B: bandwidth of network
    F_dif = (Fmax-Fmin);
    if F_dif == 0
        F_dif = Fmin;
    end
    P_dif = (Pmax-Pmin);
    if P_dif == 0
        P_dif = 1;
    end
    B_dif = (Bmax-Bmin);
    if B_dif == 0
        B_dif = 1;
    end
    Nf = (F-Fmin) ./ F_dif;
    Np = (P-Pmin) ./ P_dif;
    Nb = (B-Bmin) ./ B_dif;
    
    s = size(Nf);
    Size = s(2);
    
    mf = sum(Nf) / Size;
    mp = sum(Np) / Size;
    mb = sum(Nb) / Size;
    Size = Size - 1;
    sigma_f = sqrt(sum((Nf-mf) .^ 2) / Size);
    sigma_p = sqrt(sum((Np-mp) .^ 2) / Size);
    sigma_b = sqrt(sum((Nb-mb) .^ 2) / Size);
    
    phi_f = exp(-mf+sigma_f);
    phi_p = exp(-mp+sigma_p);
    phi_b = exp(-mb+sigma_b);
    phi = phi_f + phi_p + phi_b;
    
    weight(1:3) = 0;
    weight(1) = phi_f / phi;
    weight(2) = phi_p / phi;
    weight(3) = phi_b / phi;
end