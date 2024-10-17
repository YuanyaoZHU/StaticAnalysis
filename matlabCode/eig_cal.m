function [w,f] = eig_cal(A,M,C_str,omega,step)

R1 = M+A;
%R1_inv = inv(R1);% 求逆矩阵
R = R1\C_str;
R(4,2) = 0;
R(5,1) = 0;
e = eig(R);
[p,~] = size(e);
w = zeros(1,p);

for i = 1:p
    delta = abs(e(i) - omega.^2);
    if delta < step
        w(i) = omega;
    else
        w(i) = 0;
    end
end