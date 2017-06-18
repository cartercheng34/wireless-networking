function satisfication = Sat(F, P, B, F_p, P_p, B_p, w)
    %satisfication = w(1)*(F_p-F) / F + w(2)*(P_p-P) / P + w(3)*(B_p-B) / B;
    satisfication = (B_p-B) / B;
end