function Trains = Simulation(currentTime, Trains, trainLength, maxSpeed, acc, dec, MRT_s)
        % First Train
        for j = 1:Trains{1, 1}.numOfME
            Trains{1, 1}.car{1, j} = MovingModel_NorthBound(Trains{1, 1}.car{1, j}, maxSpeed, acc, dec, MRT_s);
        end
        if Trains{1, 1}.car{1, 1}.reconfig == 1
            Trains{1, 1} = RegenerateTrain(MRT_s{1, Trains{1, 1}.car{1, 1}.id_station_start}, ...
                                           MRT_s{1, Trains{1, 1}.car{1, 1}.id_station_end}, ...
                                           Trains{1, 1}, trainLength);
        end
        
        % Second Train
        for j = 1:Trains{1, 2}.numOfME
            Trains{1, 2}.car{1, j} = MovingModel_SouthBound(Trains{1, 2}.car{1, j}, maxSpeed, acc, dec, MRT_s);
        end
        if Trains{1, 2}.car{1, 1}.reconfig == 1
            Trains{1, 2} = RegenerateTrain(MRT_s{1, Trains{1, 2}.car{1, 1}.id_station_start}, ...
                                           MRT_s{1, Trains{1, 2}.car{1, 1}.id_station_end}, ...
                                           Trains{1, 2}, trainLength);
        end
        
        % Generate 3rd and 4th Train
        if currentTime == 180
            Trains{1, 3} = InitializeTrain(3, MRT_s{1, 1}, MRT_s{1, 2}, trainLength);
            Trains{1, 4} = InitializeTrain(4, MRT_s{1, 24}, MRT_s{1, 23}, trainLength);
        end
        
        % Third Train
        if currentTime > 180
            for j = 1:Trains{1, 3}.numOfME
            Trains{1, 3}.car{1, j} = MovingModel_NorthBound(Trains{1, 3}.car{1, j}, maxSpeed, acc, dec, MRT_s);
            end
            if Trains{1, 3}.car{1, 1}.reconfig == 1
                Trains{1, 3} = RegenerateTrain(MRT_s{1, Trains{1, 3}.car{1, 1}.id_station_start}, ...
                                               MRT_s{1, Trains{1, 3}.car{1, 1}.id_station_end}, ...
                                               Trains{1, 3}, trainLength);
            end
        end
        
        % Fourth Train
        if currentTime > 180
            for j = 1:Trains{1, 4}.numOfME
            Trains{1, 4}.car{1, j} = MovingModel_SouthBound(Trains{1, 4}.car{1, j}, maxSpeed, acc, dec, MRT_s);
            end
            if Trains{1, 4}.car{1, 1}.reconfig == 1
                Trains{1, 4} = RegenerateTrain(MRT_s{1, Trains{1, 4}.car{1, 1}.id_station_start}, ...
                                               MRT_s{1, Trains{1, 4}.car{1, 1}.id_station_end}, ...
                                               Trains{1, 4}, trainLength);
            end
        end
end