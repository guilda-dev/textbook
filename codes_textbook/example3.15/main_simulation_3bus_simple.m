a_branch = cell(2, 1);
a_branch{1} = branch(1, 2, 1.3652-11.6040j);
a_branch{2} = branch(2, 3, -10.5107j);
Y = get_admittance_matrix(3, a_branch);

parameter = struct();

parameter.M1 = 100;
parameter.D1 = 10;
parameter.tau1 = 5.14;
parameter.X1 = 1.569;
parameter.X1_prime = 0.936;
parameter.Pmech1 = 2.5158;
parameter.Vfield1 = 2.7038;

parameter.z2 = 1.3224;

parameter.M3 = 12;
parameter.D3 = 10;
parameter.tau3 = 8.97;
parameter.X3 = 1.220;
parameter.X3_prime = 0.667;
parameter.Pmech3 = 0.5000;
parameter.Vfield3 = 2.1250;

parameter.omega0 = 60*2*pi;

x0 = [0.5357 + pi/6; 0; 2.3069 + 0.1;...
    0.0390; 0; 2.0654; zeros(12, 1)];
M = blkdiag(eye(6), zeros(12, 12));

tspan = [0 50];

options = odeset('Mass', M);
func = @(t, x) func_simulation_3bus(x, Y, parameter);
[t, x] = ode15s(func, tspan, x0, options); 

plot(t, x(:, [2, 5]))