classdef MobileEquipment
    properties
        id_ME
        id_station_start
        id_station_end
        pos_x
        pos_y
        unitvector_x
        unitvector_y
        velocity
        status %% 1 = accelerating, 0 = constant speed, -1 = decelarating, -2 = stays in station;
        pauseTime
        pos_relativeToStation_x
        pos_relativeToStation_y
        reconfig %% set to 1 if ME just changed its status from -2 to 1
        id_BS_connected
    end
    methods
        function ME = MobileEquipment(id, index_start, index_end, x, y, u_x, u_y, v, status, pauseTime, rel_x, rel_y)
            ME.id_ME = id;
            ME.id_station_start = index_start;
            ME.id_station_end = index_end;
            ME.pos_x = x;
            ME.pos_y = y;
            ME.unitvector_x = u_x;
            ME.unitvector_y = u_y;
            ME.velocity = v;
            ME.status = status;
            ME.pauseTime = pauseTime;
            ME.pos_relativeToStation_x = rel_x;
            ME.pos_relativeToStation_y = rel_y;
            ME.reconfig = 0;
            ME.id_BS_connected = [0, 0];
        end
    end
end