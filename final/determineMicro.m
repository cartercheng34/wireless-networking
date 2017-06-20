function bs = determineMicro(numOfArea, numOfCell, Train, Micro) 
    distance = zeros(1, 7*19);
    count = 1;
    for i = 1:numOfArea
        for j = 1:numOfCell
            distance(count) = sqrt((Train.car{1, 1}.pos_x - Micro{i, j}.pos_x)^2 +...
                (Train.car{1, 1}.pos_y - Micro{i, j}.pos_y)^2);
            count = count + 1;
        end
    end
    BS = [0 ,0];
    BS(1) = find(distance == min(distance));
    distance(find(distance == min(distance))) = [];
    BS(2) = find(distance == min(distance));
    bs = BS;
end