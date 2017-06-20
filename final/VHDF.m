function bs_id = VHDF(BS, F, P, B, w)
% F: performance of network (SINR)
% P: power consumption
% B: bandwidth of network
% w: weight
    quality = 0;
    id = BS(1);
    s = size(BS);
    for i = 1:s(2)
        q = w(1)*F(i) / max(F) + w(2)*(1/P(i)) / max(1./P) + w(3)*B(i) / max(B);
        if q > quality
            quality = q;
            id = BS(i);
        end
    end
    bs_id = id;
end