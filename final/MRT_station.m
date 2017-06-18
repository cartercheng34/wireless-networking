classdef MRT_station
    properties
        pos_x;
        pos_y;
        id
        lambda_in
        lambda_out
    end
    methods
        function M = MRT_station(x , y , id, in, out)
            M.pos_x = x;
            M.pos_y = y;
            M.id = id;
            M.lambda_in = in;
            M.lambda_out = out;
        end
    end
end