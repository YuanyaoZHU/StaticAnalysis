clc;
clear;
rho = 1025; %海水密度

% 读取数据

filename = "..\HydroDynamicData\Spar.1";
fileID = fopen(filename);
DataIn = textscan(fileID,repmat('%f',[1,5]),'CollectOutput',1);
fclose(fileID);
Data = DataIn{1,1};

M0 = load("..\HydroDynamicData\mass.txt")*1; % 相对平台自身质心的质量矩阵, mass.txt为平台质量矩阵，mass_total.txt为整体质量矩阵
M_total = load("..\HydroDynamicData\mass_total.txt");
C0 = load("..\HydroDynamicData\Spar.hst"); % 读取静水回复力参数
C_mooring = load("..\HydroDynamicData\mooring_force.txt");



MC_platform = [0,0,-78]; % 平台质心
xg = MC_platform(1); % 质心x坐标
yg = MC_platform(2); % 质心y坐标
zg = MC_platform(3); % 质心z坐标

M_platform = Inertial_Process(M0,MC_platform); % 运用移轴定理将参考点移到水线面中心处
m_platform = M_platform(1,1);
g = 9.81;


M_rotor_origin = zeros(6,6);
M_rotor_origin(1,1) = 110e+3;
M_rotor_origin(2,2) = 110e+3;
M_rotor_origin(3,3) = 110e+3;
m_rotor = 110e+3;
MC_rotor = [0,0,90];
M_rotor = Inertial_Process(M_rotor_origin,MC_rotor);

M_nacelle_origin = zeros(6,6);
M_nacelle_origin(1,1) = 240e+3;
M_nacelle_origin(2,2) = 240e+3;
M_nacelle_origin(3,3) = 240e+3;
m_nacelle = 240e+3;
MC_nacelle = [0,0,90];
M_nacelle = Inertial_Process(M_nacelle_origin,MC_nacelle);

M_tower_origin = zeros(6,6);
M_tower_origin(1,1) = 249718;
M_tower_origin(2,2) = 249718;
M_tower_origin(3,3) = 249718;
M_tower_origin(4,4) = 119076259.7;
M_tower_origin(5,5) = 119076259.7;
m_tower = 249718;
MC_tower = [0,0,43.4];
M_tower = Inertial_Process(M_tower_origin,MC_tower);

panduan = 0; % panduan为1时，表示质量矩阵根据转子、机舱、塔筒等分项进行计算获得，
             % 非1时，表示通过外部直接输入获得。

if panduan == 1
    M = M_platform + M_rotor + M_nacelle + M_tower;
    m = m_platform + m_rotor + m_nacelle + m_tower;
    MC = (m_platform*MC_platform + m_rotor*MC_rotor + m_nacelle*MC_nacelle + m_tower*MC_tower)/m;
else
    M = M_total;
    MC = [0,0,-73];
    m = M(1,1);
end




C1 = zeros(6,6); % 将读取的静水回复力参数转变为矩阵表达形式
[p,~] = size(C0(:,1));
for i = 1:p
    C1(C0(i,1),C0(i,2)) = C0(i,3)*rho*g;    
end
C2 = zeros(6,6);
C2(4,4) = -m*g*MC(3);
C2(5,5) = -m*g*MC(3);
C2(6,6) = 98340000;
C_mooring(1,1)=C_mooring(1,1)*0.5;
C_mooring(2,2)=C_mooring(2,2)*0.5;

C_str = C1+C2+C_mooring;


[HydroData_1,Freedom] = dataProcess(Data); % dataProcess函数用于处理读取的水动力文件，返回值HydroData_1为各个自由度的数据，Freedom为自由度

A = zeros(6,6);
A1 = zeros(6,6);
A2 = zeros(6,6);
[p,~] = size(HydroData_1{1}(:,1));
[q,~] = size(Freedom(:,1));

w_natural = zeros(6,1);

for i=1:p-1
    omega1 = HydroData_1{1}(i,1);
    omega2 = HydroData_1{1}(i+1,1);
    omega = [omega1,omega2];
    for j = 1:q
        A1(Freedom(j,1),Freedom(j,2)) = HydroData_1{j}(i,4);
        A2(Freedom(j,1),Freedom(j,2)) = HydroData_1{j}(i+1,4);        
    end
    step = 1e-4; % 计算精度
    
    for j = omega1:step:omega2
        for k = 1:6
            for t = 1:6
                if omega1==j
                    A(k,t) = A1(k,t);
                elseif omega2 ==j
                    A(k,t) = A2(k,t);
                else
                    A(k,t) = interp1(omega,[A1(k,t),A2(k,t)],j); 
                end
            end
        end
        w = eig_cal(A,M,C_str,j,step);
        for k = 1:6
            if w(k)~=0
                w_natural(k) = w(k);
            end 
        end
    end    
end
w_natural
T_natural = 2*pi./w_natural
f_natural = w_natural/2/pi



