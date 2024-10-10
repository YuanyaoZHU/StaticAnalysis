function M = Inertial_Process(M0,MC_platform)

xg = MC_platform(1);
yg = MC_platform(2);
zg = MC_platform(3);

m = M0(1,1);

M = zeros(6,6);
M(1:3,1:3) = M0(1:3,1:3);

M(1,5) =  m*zg;
M(1,6) = -m*yg;
M(2,4) = -m*zg;
M(2,6) =  m*xg;
M(3,4) =  m*yg;
M(3,5) = -m*xg;
M(4,2) = -m*zg;
M(4,3) =  m*yg;
M(5,1) =  m*zg;
M(5,3) = -m*xg;
M(6,1) = -m*yg;
M(6,2) =  m*xg;

T = zeros(3,3);
T(1,1) = yg^2+zg^2;
T(1,2) = -xg*yg;
T(1,3) = -xg*zg;
T(2,1) = -xg*yg;
T(2,2) = xg^2+zg^2;
T(2,3) = -yg*zg;
T(3,1) = -xg*zg;
T(3,2) = -yg*zg;
T(3,3) =  xg^2+yg^2;

M(4:6,4:6) = M0(4:6,4:6)+m*T;