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
Mobile_power = 23; % dBm
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
simTime = 1200;
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
    for train = 1:numOfTrains
        BS = determineMicro(extend_num + 1, base_num, Trains{1, train}, micro_BS);
        Trains = SimUser(Trains, numOfTrains, train, BS, base_num, micro_BS, WIFI,...
            Micro_power, WIFI_power, Mobile_gain, Micro_gain, WIFI_gain, m_h,...
            b_h, WIFI_h, 1, Micro_bw, WIFI_bw, Noise_wo_bw, Micro_ps, WIFI_ps);
        Trains = SimUser(Trains, numOfTrains, train, BS, base_num, micro_BS, WIFI,...
            Micro_power, WIFI_power, Mobile_gain, Micro_gain, WIFI_gain, m_h,...
            b_h, WIFI_h, 2, Micro_bw, WIFI_bw, Noise_wo_bw, Micro_ps, WIFI_ps);
        if train == 1
            satisfication1(t) = SumOfSat(Trains{1,1}, 1, WIFI_bw, Micro_bw, prefer_B);
            satisfication2(t) = SumOfSat(Trains{1,1}, 2, WIFI_bw, Micro_bw, prefer_B);
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
figure
plot(xaxis,satisfication1(xaxis),'r');
hold on
plot(xaxis,satisfication2(xaxis),'g');
xlabel('Time(s)');
ylabel('User satisfication');