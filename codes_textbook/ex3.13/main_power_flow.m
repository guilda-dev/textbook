a_bus = cell(3, 1);
a_bus{1} = bus_slack(2, 0);
a_bus{2} = bus_load(-3, 0);
a_bus{3} = bus_generator(0.5, 2);

a_branch = cell(2, 1);
a_branch{1} = branch(1, 2, 1.3652-11.6040j);
a_branch{2} = branch(2, 3, -10.5107j);

[V, I, P, Q] = calculate_power_flow(a_bus, a_branch);

display('Vabs:'), display(abs(V)')
display('Vangle:'), display(angle(V)')
display('P:'), display(P')
display('Q:'), display(Q')