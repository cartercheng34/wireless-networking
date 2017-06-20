function wifi = determinedWIFI(Train , user, WIFI)
    WiFi = [0, 0];
    previous_distance = sqrt((Train.car{1, user}.pos_x - WIFI{1, Train.car{1, user}.id_station_start}.pos_x)^2 + ...
        (Train.car{1, user}.pos_y - WIFI{1, Train.car{1, user}.id_station_start}.pos_y)^2);
    next_distance = sqrt((Train.car{1, user}.pos_x - WIFI{1, Train.car{1, user}.id_station_end}.pos_x)^2 + ...
        (Train.car{1, user}.pos_y - WIFI{1, Train.car{1, user}.id_station_end}.pos_y)^2);
    if previous_distance <= 35
        WiFi(1) = WIFI{1, Train.car{1, user}.id_station_start}.id;
    end
    if next_distance <= 35
        WiFi(2) = WIFI{1, Train.car{1, user}.id_station_end}.id;
    end
    wifi = WiFi;
end