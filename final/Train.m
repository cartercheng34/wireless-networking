classdef Train
    properties
        id
        id_startStation
        id_endStation
        numOfME
        car
        ME_startingID
        largestID_ME
    end
    methods
        function t = Train(id, id_start, id_end, numOfME, id_ME_start)
            t.id = id;
            t.id_startStation = id_start;
            t.id_endStation = id_end;
            t.numOfME = numOfME;
            t.car = cell(1, numOfME);
            t.ME_startingID = id_ME_start;
            t.largestID_ME = id_ME_start + numOfME - 1;
        end
    end
end