x0 = [1; 0; 1; 0; 1; 0];
options = optimoptions('fsolve', 'Display', 'iter');
y12 = 1.3652 - 11.6040j;
y23 = -10.5107j;
Y = [y12, -y12, 0;
    -y12, y12+y23, -y23;
    0, -y23, y23];

a_bus = cell(3, 1);
a_bus{1} = bus_slack(2, 0);
a_bus{2} = bus_load(-3, 0);
a_bus{3} = bus_generator(0.5, 2);

func_curried = @(x) func_power_flow(x, Y, a_bus);

x_sol = fsolve(func_curried, x0, options);

[~, V, I, P, Q] = func_curried(x_sol);
Vabs = abs(V);
Vangle = angle(V);
display('Vabs:'), display(Vabs')
display('Vangle:'), display(Vangle')
display('P:'), display(P')
display('Q:'), display(Q')