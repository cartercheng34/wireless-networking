function ME = MovingModel_SouthBound(ME, maxSpeed, acc, dec, MRT_s)
    if ME.status == -2
        ME.pauseTime = ME.pauseTime - 1;
        if ME.pauseTime == 0
            ME.id_station_start = ME.id_station_start - 1;
            ME.id_station_end = ME.id_station_end - 1;
            distToNextStation = sqrt((MRT_s{1, ME.id_station_end}.pos_x - MRT_s{1, ME.id_station_start}.pos_x)^2 + ...
                            (MRT_s{1, ME.id_station_end}.pos_y - MRT_s{1, ME.id_station_start}.pos_y)^2);
            ME.unitvector_x = (MRT_s{1, ME.id_station_end}.pos_x - MRT_s{1, ME.id_station_start}.pos_x)/distToNextStation;
            ME.unitvector_y = (MRT_s{1, ME.id_station_end}.pos_y - MRT_s{1, ME.id_station_start}.pos_y)/distToNextStation;
            ME.velocity = 0;
            ME.status = 1;
            ME.pauseTime = 20;
            if ME.id_station_end == 10
                ME.pauseTime = 40;
            end
            ME.reconfig = 1;
        end
        return
    else
        ME.reconfig = 0;
    end
    distToDestination = sqrt((MRT_s{1, ME.id_station_end}.pos_x + ME.pos_relativeToStation_x - ME.pos_x)^2 ...
                           + (MRT_s{1, ME.id_station_end}.pos_y + ME.pos_relativeToStation_y - ME.pos_y)^2);
    if distToDestination <= ME.velocity
        ME.pos_x = MRT_s{1, ME.id_station_end}.pos_x + ME.pos_relativeToStation_x;
        ME.pos_y = MRT_s{1, ME.id_station_end}.pos_y + ME.pos_relativeToStation_y;
        ME.status = -2;
        ME.velocity = 0;
        % scatter(ME.pos_x, ME.pos_y, 'g');
        return
    end
    ME.pos_x = ME.pos_x + ME.velocity*ME.unitvector_x;
    ME.pos_y = ME.pos_y + ME.velocity*ME.unitvector_y;
    % scatter(ME.pos_x, ME.pos_y, 'g');
    if (ME.status == 1) && ME.velocity < maxSpeed
        ME.velocity = ME.velocity + acc;
    end
    if (ME.status ~= -1) && (ME.velocity == maxSpeed)
        ME.status = 0;
    end
    if ((ME.status == 0) || (ME.status == -1)) && (distToDestination <= (maxSpeed)^2/2)
        if ME.status == 0
            ME.status = -1;
        end
        ME.velocity = ME.velocity + dec;
    end
end