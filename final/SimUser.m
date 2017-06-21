function Trains = SimUser(Trains, numOfTrains, trainNum, BS_id, numOfCell, Micro, ...
    WIFI, Micro_power, WIFI_power, Mobile_gain, Micro_gain, WIFI_gain, m_h,... 
    Micro_h, WIFI_h, Type, Micro_bw, WIFI_bw, Noise, Micro_con, WIFI_con)
    for people = 1:Trains{1, trainNum}.numOfME
        BS = BS_id;
        Power = [10^(Micro_power/10)*10^-3, 10^(Micro_power/10)*10^-3];
        BS_gain = [10^(Micro_gain/10), 10^(Micro_gain/10)];        
        height = [Micro_h, Micro_h];
        P = [Micro_con, Micro_con];
        B = [Micro_bw, Micro_bw];
        F = [0 , 0];
        if Type == 1
            wifi = determinedWIFI(Trains{1, trainNum}, people, WIFI);
            for i = 1:2
                if wifi(i) ~= 0
                    Power = [Power , 10^(WIFI_power/10)*10^-3];
                    BS = [BS, wifi(i)];
                    BS_gain = [BS_gain, 10^(WIFI_gain/10)];
                    height = [height, WIFI_h];
                    P = [P, WIFI_con];
                    B = [B, WIFI_bw];
                    F = [F, 0];
                end
            end
        end
        sizeOfBS = size(BS);
        for bs = 1:sizeOfBS(2)
            % power
            power = 0;
            d = 0;
            if bs <= 2
                micro_j = rem(BS(bs), numOfCell);
                if micro_j == 0
                    micro_j = numOfCell;
                end
                micro_i = (BS(bs) - micro_j) / numOfCell + 1;
                d = sqrt((Trains{1, trainNum}.car{1, people}.pos_x - Micro{micro_i, micro_j}.pos_x)^2 + ...
                    (Trains{1, trainNum}.car{1, people}.pos_y - Micro{micro_i, micro_j}.pos_y)^2);
            else
                d = sqrt((Trains{1, trainNum}.car{1, people}.pos_x - WIFI{1, BS(bs) - 200}.pos_x)^2 + ...
                    (Trains{1, trainNum}.car{1, people}.pos_y - WIFI{1, BS(bs) - 200}.pos_y)^2);
            end
            power = Power(bs) * 10^(Mobile_gain/10) * BS_gain(bs) * (m_h*height(bs))^2/d^4;
            numOfUser = 1;
            interference = 0;
            for t = 1:numOfTrains
                for user = 1:Trains{1, trainNum}.numOfME
                    d = 0;
                    if t~= trainNum || user ~= people
                        if Trains{1, trainNum}.car{1, user}.id_BS_connected(Type) == BS(bs)
                            numOfUser = numOfUser + 1;
                            if bs <= 2
                                micro_j = rem(BS(bs), numOfCell);
                                if micro_j == 0
                                    micro_j = numOfCell;
                                end
                                micro_i = (BS(bs) - micro_j) / numOfCell + 1;
                                d = sqrt((Trains{1, trainNum}.car{1, user}.pos_x - Micro{micro_i, micro_j}.pos_x)^2 + ...
                                        (Trains{1, trainNum}.car{1, user}.pos_y - Micro{micro_i, micro_j}.pos_y)^2);
                            else
                                d = sqrt((Trains{1, trainNum}.car{1, user}.pos_x - WIFI{1, BS(bs) - 200}.pos_x)^2 + ...
                                        (Trains{1, trainNum}.car{1, user}.pos_y - WIFI{1, BS(bs) - 200}.pos_y)^2);
                            end
                            interference = interference + Power(bs) * 10^(Mobile_gain/10) * BS_gain(bs) * (m_h*height(bs))^2/d^4;
                        end
                    end
                end
            end
            B(bs) = B(bs) / numOfUser;
            F(bs) = power / (interference + Noise*B(bs));
        end
        w = WD(F,P,B,max(F),max(P),max(B),min(F),min(P),min(B));
        ID = VHDF(BS,F,P,B,w);
        Trains{1,trainNum}.car{1,people}.id_BS_connected(Type) = ID;
    end
end