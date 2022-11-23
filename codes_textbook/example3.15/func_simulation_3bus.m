function dx = func_simulation_3bus(x, Y, parameter)

delta1 = x(1);
omega1 = x(2);
E1 = x(3);
delta3 = x(4);
omega3 = x(5);
E3 = x(6);
V1 = x(7)  + 1j*x(8);
V2 = x(9)  + 1j*x(10);
V3 = x(11) + 1j*x(12);
I1 = x(13) + 1j*x(14);
I2 = x(15) + 1j*x(16);
I3 = x(17) + 1j*x(18);

omega0 = parameter.omega0;

X1 = parameter.X1;
X1_prime = parameter.X1_prime;
M1 = parameter.M1;
D1 = parameter.D1;
tau1 = parameter.tau1;
Pmech1 = parameter.Pmech1;
Vfield1 = parameter.Vfield1;

z2 = parameter.z2;

X3 = parameter.X3;
X3_prime = parameter.X3_prime;
M3 = parameter.M3;
D3 = parameter.D3;
tau3 = parameter.tau3;
Pmech3 = parameter.Pmech3;
Vfield3 = parameter.Vfield3;

P1 = real(V1*conj(I1));
P3 = real(V3*conj(I3));

dx1 = [omega0 * omega1;
    (-D1*omega1-P1+Pmech1)/M1;
    (-X1/X1_prime*E1+...
    (X1/X1_prime-1)*abs(V1)*cos(delta1-angle(V1))+Vfield1)/tau1];

dx3 = [omega0 * omega3;
    (-D3*omega3-P3+Pmech3)/M3;
    (-X3/X3_prime*E3+...
    (X3/X3_prime-1)*abs(V3)*cos(delta3-angle(V3))+Vfield3)/tau3];

con1 = I1-(E1*exp(1j*delta1)-V1)/(1j*X1_prime);
con2 = V2+z2*I2;
con3 = I3-(E3*exp(1j*delta3)-V3)/(1j*X3_prime);

con_network = [I1; I2; I3] - Y*[V1; V2; V3];

dx = [dx1; dx3;real(con1); imag(con1); real(con2);
    imag(con2); real(con3); imag(con3);
    real(con_network); imag(con_network)];

end

