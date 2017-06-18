%% parameter setting
base_num = 19;
extend_num = 6;
micro_BS = cell(extend_num+1, base_num);
WIFI = cell(1 , 24);
ISD = 2000;
length = ISD/sqrt(3);
BS_X = length * [0, 0, -1.5, -1.5, 0, 1.5, 1.5, 0, -1.5, -3, -3, -3, -1.5, 0, 1.5, 3, 3, 3, 1.5] ;
BS_Y = ISD * [0, 1,  0.5, -0.5, -1, -0.5, 0.5, 2, 1.5, 1, 0, -1, -1.5, -2, -1.5, -1, 0, 1, 1.5] ;
macro_ISD = 10000;
macro_length = macro_ISD/sqrt(3);
ISD_WIFI = 35;
length_WIFI = ISD_WIFI/sqrt(3);
m_h = 7.5;
b_h = 51.5;
WIFI_h = 9;
temp = 300;
WIFI_bw = 10^8;
Micro_bw = 2 * 10^7;
WIFI_ps = 5;
Micro_ps = 8;
WIFI_power = -60; % dBm
Micro_power = 30; % dBm
WIFI_gain = 2; % dB
Micro_gain = 14; % dB
Mobile_gain = 14; % dB
Noise_wo_bw = 1.38 * (10^-23) * (273+27);
prefer_F = 0.0000001;
prefer_P = 4;
prefer_B = Micro_bw / 20;
%% map construct
pos_x = [121.579430 , 121.573145 , 121.568102 , 121.558201 , 121.557052 , 121.558791 , 121.553004 , 121.543437 , 121.543584 ...
         121.543757 , 121.544040 , 121.544226 , 121.551995 , 121.546894 , 121.555592 , 121.567212 , 121.575079 , 121.585064 ...
         121.594407 , 121.602143 , 121.607620 , 121.611452 , 121.615952 , 121.617852];%longitude
pos_y = [24.998259 , 24.998240 , 24.998585 , 24.999389 , 25.005243 , 25.018535 , 25.023739 , 25.026124 , 25.032928 ...
         25.040958 , 25.052241 , 25.060848 , 25.063004 , 25.079476 , 25.084853 , 25.082148 , 25.080031 , 25.078530 ...
         25.083660 , 25.083841 , 25.072504 , 25.067123 , 25.059904 , 25.055405];%latitude

x = zeros(1 , 24);
y = zeros(1 , 24);
MRT_s = cell(1 , 24);
for i = 1:23
    x(1 , i+1) = great_circle(pos_y(1 , i) , pos_x(1 , i) , pos_y(1 , i) , pos_x(1 , i+1));
    y(1 , i+1) = great_circle(pos_y(1 , i) , pos_x(1 , i) , pos_y(1 , i+1) , pos_x(1 , i));
end
mrt_x = zeros(1 , 24);
mrt_y = zeros(1 , 24);
mrt_x(1 , 1) = 400;
mrt_y(1 , 1) = 450;
for i = 1:23
    if pos_x(1 , i+1) > pos_x(1 , i)
        mrt_x(1 , i+1) = mrt_x(1 , i) + x(1 , i+1);
    else mrt_x(1 , i+1) = mrt_x(1 , i) - x(1 , i+1);
    end
    if pos_y(1 , i+1) > pos_y(1 , i)
        mrt_y(1 , i+1) = mrt_y(1 , i) + y(1 , i+1);
    else mrt_y(1 , i+1) = mrt_y(1 , i) - y(1 , i+1);
    end
end
for_orientation = zeros(1 , 24); % forward direction
%{
for i = 1:23
    for_orientation(1 , i) = atan((mrt_y(1 , i+1) - mrt_y(1 , i) )/ ((mrt_x(1 , i+1) - mrt_x(1 , i) ))) + pi;%denote ith to (i+1)th
    back_orientation(1 , i+1) = for_orientation(1 , i) - pi;
end

for i = 1:24
    MRT_s{1 , i} = MRT_station(mrt_x(1 , i) , mrt_y(1 , i) , i);
end
%}
figure;
scatter(mrt_x(1 , :) , mrt_y(1 , :) , 'r');
hold on
for i = 1:base_num
    [x_vec_tmp , y_vec_tmp] = draw_hex2(BS_X(i) , BS_Y(i) , length , ISD);
    micro_BS{1 , i} = BaseStation(i , BS_X(i) , BS_Y(i) , x_vec_tmp , y_vec_tmp);
    text(micro_BS{1 , i}.pos_x, micro_BS{1,i}.pos_y, int2str(i));
end

extend_center = zeros(2 , extend_num);
for i = 1:extend_num
    tmp_angle = 0 : pi/3 : 2*pi;
    extend_center(1 , i) = (-7.5*length)*cos(tmp_angle(i)) - ISD/2*sin(tmp_angle(i));
    extend_center(2 , i) = (-7.5*length)*sin(tmp_angle(i)) + ISD/2*cos(tmp_angle(i));    
    for j = 1:base_num
        [x_vec_tmp , y_vec_tmp] = draw_hex2(BS_X(j) + extend_center(1 , i) , BS_Y(j) + extend_center(2 , i), length , ISD);
        micro_BS{i+1 , j} = BaseStation(19*i + j , BS_X(j) + extend_center(1 , i) , BS_Y(j) + extend_center(2 , i) , x_vec_tmp , y_vec_tmp);
        text(micro_BS{i+1,j}.pos_x,micro_BS{i+1,j}.pos_y, int2str(micro_BS{i+1,j}.id));
    end
end

for i = 1:24
    [x_vec_tmp , y_vec_tmp] = draw_hex2(mrt_x(1 , i) , mrt_y(1 , i) , length_WIFI , ISD_WIFI);
    WIFI{1 , i} = BaseStation(200+i , mrt_x(1 , i) , mrt_y(1 , i) , x_vec_tmp , y_vec_tmp);
    MRT_s{1 , i} = MRT_station(mrt_x(1 , i) , mrt_y(1 , i) , i, 30, 30);
end

%% Generate First Trains
acc = 1; % accelaration
dec = -1; % decelaration
maxSpeed = floor(70*5/18); % MRT max speed = 70km/h
trainLength = 55.12; % Total train length for Wenhu Line
Trains = cell(1, 4); % Total 4 trains will be generated
Trains{1, 1} = InitializeTrain(1, MRT_s{1, 1}, MRT_s{1, 2}, trainLength); % Odd IDs for Northbound trains
Trains{1, 2} = InitializeTrain(2, MRT_s{1, 24}, MRT_s{1, 23}, trainLength); % Even IDs for Southbound trains

%% Simulation
simTime = 1300;
Count_VH = 0;
satisfication1 = zeros(1, simTime);
satisfication2 = zeros(1, simTime);
for t = 1:simTime
    if t >= 180
        numOfTrains = 4;
    else
        numOfTrains = 2;
    end
    Trains = Simulation(t, Trains, trainLength, maxSpeed, acc, dec, MRT_s);
    %{
    BS_id = [0,0];
    height = [0,0];
    gain = [0,0];
    BS_power = [0,0];
    F = [0,0];
    P = [0,0];
    B = [0,0];
    %}
    for train = 1:numOfTrains
        BS_id = [0,0];
        height = [0,0];
        gain = [0,0];
        BS_power = [0,0];
        F = [0,0];
        P = [0,0];
        B = [0,0];
        d = zeros(1 , 7*19);
        count = 1;
        for i = 1:(extend_num+1)
            for j = 1:base_num
                d(count) = sqrt((Trains{1, train}.car{1,1}.pos_x-micro_BS{i,j}.pos_x)^2 +...
                    (Trains{1, train}.car{1,1}.pos_y-micro_BS{i,j}.pos_y)^2);
                count = count + 1;
            end
        end
        BS_id(1) = find(d == min(d));
        d(find(d == min(d))) = [];
        BS_id(2) = find(d == min(d));
        flag = 0;
        d_end = sqrt((Trains{1, train}.car{1,1}.pos_x-WIFI{1,Trains{1, 1}.car{1,1}.id_station_end}.pos_x)^2 + (Trains{1, train}.car{1,1}.pos_y-WIFI{1,Trains{1, train}.car{1,1}.id_station_end}.pos_y)^2);
        d_start = sqrt((Trains{1, train}.car{1,1}.pos_x-WIFI{1,Trains{1, 1}.car{1,1}.id_station_start}.pos_x)^2 + (Trains{1, train}.car{1,1}.pos_y-WIFI{1,Trains{1, train}.car{1,1}.id_station_start}.pos_y)^2);
        if d_end < 35
            BS_id = [BS_id,WIFI{1,Trains{1, train}.car{1,1}.id_station_end}.id];
            flag = 1;
        end
        if d_start < 35
            BS_id = [BS_id,WIFI{1,Trains{1, train}.car{1,1}.id_station_start}.id];
            flag = 1;
        end
        for index = 1:2
            P(index) = 8;
            height(index) = b_h;
            gain(index) = 10^(14/10);
            B(index) = Micro_bw;
            BS_power(index) = 10^(Micro_power/10)*10^(-3);
        end
        s = size(BS_id);
        if flag == 1
            for index = 3:s(2)
                P = [P,5];
                height = [height,9];
                gain = [gain,10^(2/10)];
                B = [B,WIFI_bw];
                BS_power = [BS_power,10^(WIFI_power/10)*10^(-3)];
                F = [F,0];
            end
        end
%%
        for people = 1:Trains{1,train}.numOfME
            for BS = 1:s(2)
                if BS <= 2
                    micro_j = rem(BS_id(BS),19);
                    if micro_j == 0
                        micro_j = 19;
                    end
                    micro_i = (BS_id(BS) - micro_j)/19 + 1;
                    d_BS = sqrt((Trains{1, train}.car{1,people}.pos_x-micro_BS{micro_i,micro_j}.pos_x)^2 ...
                            + (Trains{1, train}.car{1,people}.pos_y-micro_BS{micro_i,micro_j}.pos_y)^2);
                else
                    d_BS = sqrt((Trains{1, train}.car{1,people}.pos_x-WIFI{1,BS_id(BS)-200}.pos_x)^2 ...
                            + (Trains{1, train}.car{1,people}.pos_y-WIFI{1,BS_id(BS)-200}.pos_y)^2);
                power = BS_power(BS) * 10^(Mobile_gain/10) * gain(BS) * (m_h*height(BS))^2/d_BS^4;
                end
                numOfpeople = 1;
                interference = 0;
                for others = 1:Trains{1,train}.numOfME
                    if Trains{1,train}.car{1,others}.id_BS_connected == BS_id(BS)
                        numOfpeople = numOfpeople + 1;
                        if BS <= 2
                            micro_j = rem(BS_id(BS),19);
                            if micro_j == 0
                                micro_j = 19;
                            end
                            micro_i = (BS_id(BS) - micro_j)/19 + 1;
                            d_BS = sqrt((Trains{1, train}.car{1,others}.pos_x-micro_BS{micro_i,micro_j}.pos_x)^2 ...
                                + (Trains{1, train}.car{1,others}.pos_y-micro_BS{micro_i,micro_j}.pos_y)^2);
                        else
                            d_BS = sqrt((Trains{1, train}.car{1,others}.pos_x-WIFI{1,BS_id(BS)-200}.pos_x)^2 ...
                                + (Trains{1, train}.car{1,others}.pos_y-WIFI{1,BS_id(BS)-200}.pos_y)^2);
                        end
                        interference = interference + BS_power(BS) * 10^(Mobile_gain/10) * gain(BS) * (m_h*height(BS))^2/d_BS^4;
                    end
                end
                B(BS) = B(BS) / numOfpeople;
                interference = interference - power;
                F(BS) = power / (interference+Noise_wo_bw*B(BS));
            end
            w1 = WD(F,P,B,max(F),max(P),max(B),min(F),min(P),min(B));
            ID1 = VHDF(BS_id,F,P,B,w1);
            Trains{1,train}.car{1,people}.id_BS_connected = ID1;
 %{
            if (Trains{1,train}.car{1,people}.id_BS_connected < 200) && (ID1 > 200)
                Count_VH = Count_VH + 1;
            end
 %}
            %%
            for BS = 1:2
                micro_j = rem(BS_id(BS),19);
                if micro_j == 0
                    micro_j = 19;
                end
                micro_i = (BS_id(BS) - micro_j)/19 + 1;
                d_BS = sqrt((Trains{1, train}.car{1,people}.pos_x-micro_BS{micro_i,micro_j}.pos_x)^2 ...
                    + (Trains{1, train}.car{1,people}.pos_y-micro_BS{micro_i,micro_j}.pos_y)^2);
                power2 = BS_power(BS) * 10^(Mobile_gain/10) * gain(BS) * (m_h*height(BS))^2/d_BS^4;
                numOfpeople2 = 1;
                interference2 = 0;
                for others = 1:Trains{1,train}.numOfME
                    if Trains{1,train}.car{1,others}.id_Micro == BS_id(BS)
                        numOfpeople2 = numOfpeople2 + 1;
                        micro_j = rem(BS_id(BS),19);
                        if micro_j == 0
                            micro_j = 19;
                        end
                        micro_i = (BS_id(BS) - micro_j)/19 + 1;
                        d_BS = sqrt((Trains{1, train}.car{1,others}.pos_x-micro_BS{micro_i,micro_j}.pos_x)^2 ...
                            + (Trains{1, train}.car{1,others}.pos_y-micro_BS{micro_i,micro_j}.pos_y)^2);
                        interference2 = interference2 + BS_power(BS) * 10^(Mobile_gain/10) * gain(BS) * (m_h*height(BS))^2/d_BS^4;
                    end
                end
                B(BS) = B(BS) / numOfpeople2;
                interference2 = interference2 - power2;
                F(BS) = power2 / (interference2+Noise_wo_bw*B(BS));
            end
            w2 = WD(F(1:2),P(1:2),B(1:2),max(F(1:2)),max(P(1:2)),max(B(1:2)),min(F(1:2)),min(P(1:2)),min(B(1:2)));
            ID2 = VHDF(BS_id(1:2),F(1:2),P(1:2),B(1:2),w2);
            Trains{1,train}.car{1,people}.id_Micro = ID2;
            %satisfication(t) = satisfication(t) + Sat(F(iD),P(iD),B(iD),prefer_F,prefer_P,prefer_B,w);
        end
        B_num1 = [0];
        B_ID1 = [0];
        B_num2 = [0];
        B_ID2 = [0];
        if train == 1
        for user = 1:Trains{1,train}.numOfME
            S = size(B_ID1);
            Size = S(2);
            if B_ID1(1) == 0
                B_num1(1) = 1;
                B_ID1(1) = Trains{1,train}.car{1,user}.id_BS_connected;
            else
                check = 0;
                for b = 1:Size
                    if Trains{1,train}.car{1,user}.id_BS_connected == B_ID1(b)
                       B_num1(b) = B_num1(b) + 1;
                       check = 1;
                       break;
                    end
                end
                if check == 0
                    B_ID1 = [B_ID1,Trains{1,train}.car{1,user}.id_BS_connected];
                    B_num1 = [B_num1,1];
                end
            end
        end
        SS = size(B_ID1);
        for node = 1:SS(2)
            for num = 1:B_num1(node)
                if B_ID1 > 200 
                    bw = WIFI_bw;
                else
                    bw = Micro_bw;
                end
                satisfication1(t) = satisfication1(t) + Sat(1,1,bw/B_num1(node),1,1,prefer_B,w); 
            end
        end
        for user = 1:Trains{1,train}.numOfME
            S = size(B_ID2);
            Size = S(2);
            if B_ID2(1) == 0
                B_num2(1) = 1;
                B_ID2(1) = Trains{1,train}.car{1,user}.id_Micro;
            else
                check = 0;
                for b = 1:Size
                    if Trains{1,train}.car{1,user}.id_Micro == B_ID2(b)
                       B_num2(b) = B_num2(b) + 1;
                       check = 1;
                       break;
                    end
                end
                if check == 0
                    B_ID2 = [B_ID2,Trains{1,train}.car{1,user}.id_Micro];
                    B_num2 = [B_num2,1];
                end
            end
        end
        SS = size(B_ID2);
        for node = 1:SS(2)
            for num = 1:B_num2(node)
                if B_ID > 200 
                    bw = WIFI_bw;
                else
                    bw = Micro_bw;
                end
                satisfication2(t) = satisfication2(t) + Sat(1,1,bw/B_num2(node),1,1,prefer_B,w); 
            end
        end
        end
    end
end
if simTime >= 180
    numOfTrains = 4;
else
    numOfTrains = 2;
end
    
for trainID = 1:numOfTrains
    for j = 1:Trains{1, trainID}.numOfME
        scatter(Trains{1, trainID}.car{1, j}.pos_x, Trains{1, trainID}.car{1, j}.pos_y, 'g');
    end
end
xaxis = 1:simTime;
figure;
plot(xaxis,satisfication1(xaxis),'r');
hold on
plot(xaxis,satisfication2(xaxis),'g');
xlabel('Time(s)');
ylabel('User satisfication');