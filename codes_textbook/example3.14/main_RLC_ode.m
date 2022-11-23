R = 1;
L = 1;
C = 1;
E = 1;

func = @(t, x) func_RLC_ode(x, R, C, L, E);
x0 = [0; 0];
tspan = [0 30];

[t, x] = ode45(func, tspan, x0);

plot(t, x)
