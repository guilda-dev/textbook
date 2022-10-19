function [out, Vhat, Ihat, Phat, Qhat] = func_ex2(x)
% x: [Real(V1), Imag(V1),
%     Real(V2), Imag(V2),
%     Real(V3), Imag(V3)]';

y12 = 1.3652 - 11.6040j;
y23 = -10.5107j;
Y = [y12, -y12, 0;
    -y12, y12+y23, -y23;
    0, -y23, y23];

V1abs = 2;
V1angle = 0;

P2 = -3;
Q2 = 0;

P3 = 0.5;
V3abs = 2;

V1hat = x(1) + 1j*x(2);
V2hat = x(3) + 1j*x(4);
V3hat = x(5) + 1j*x(6);

Vhat = [V1hat; V2hat; V3hat];

Ihat = Y*Vhat;
PQhat = Vhat.*conj(Ihat);
Phat = real(PQhat);
Qhat = imag(PQhat);

out = [V1abs-abs(V1hat); V1angle-angle(V1hat);
    P2-Phat(2); Q2-Qhat(2);
    P3-Phat(3); V3abs-abs(V3hat)];
end