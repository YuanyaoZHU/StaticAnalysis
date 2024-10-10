function [w,f] = eig_cal(A,M,C_str,omega)

R1 = M+A;
%R1_inv = inv(R1);% 求逆矩阵
R = R1\C_str;
e = eig(R);
[p,~] = size(e);
w = zeros(1,p);

for i = 1:p
    delta = abs(e(i) - omega.^2);
    if delta < 1e-4
        w(i) = omega;
    else
        w(i) = 0;
    end
end