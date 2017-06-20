function s = SumOfSat(Train , Type, WIFI, Micro, Prefer_bw)
% Type == 1 : with VH
% Type == 2 : without VH
    num = [0];
    ID = [0];
    satisfication = 0;
    for user = 1:Train.numOfME
        if ID(1) == 0
            num(1) = 1;
            ID(1) = Train.car{1, user}.id_BS_connected(Type);
        else
            check = 0;
            sizeOfID = size(ID);
            for b = 1:sizeOfID(2)
                if Train.car{1, user}.id_BS_connected(Type) == ID(b)
                    num(b) = num(b) + 1;
                    check = 1;
                    break;
                end
            end
            if check == 0
                ID = [ID, Train.car{1, user}.id_BS_connected(Type)];
                num = [num, 1];
            end
        end 
    end
    sizeOfID = size(ID);
    for id = 1:sizeOfID(2)
        for n = 1:num(id)
            if ID(id) > 200
                bw = WIFI;
            else
                bw = Micro;
            end
        end
        satisfication = satisfication + Sat(bw / num(id), Prefer_bw);
    end
    s = satisfication;
end