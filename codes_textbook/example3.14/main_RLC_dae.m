R = 1;
C = 1;
L = 1;
E = 1;

M = zeros(6, 6);
M(1, 2) = L;
M(2, 6) = C;

x0 = zeros(6, 1);
tspan = [0 30];

options = odeset('Mass', M);
[t, x] = ode15s(@(t, x) func_RLC_dae(x, R, C, L, E),...
  tspan, x0, options);

plot(t, x(:, [2, 6]))