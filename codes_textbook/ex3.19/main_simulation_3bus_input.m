clear
close all

a_bus = cell(3, 1);
a_bus{1} = bus_slack(2, 0);
a_bus{2} = bus_load(-3, 0);
a_bus{3} = bus_generator(0.5, 2);

a_branch = cell(2, 1);
a_branch{1} = branch(1, 2, 1.3652-11.6040j);
a_branch{2} = branch(2, 3, -10.5107j);

gen1 = generator(60*2*pi, 100, 10, 5.14, 1.569, 0.936, [], []);
load2 = load_impedance([]);
gen3 = generator(60*2*pi, 12, 10, 8.97, 1.220, 0.667, [], []);

a_component = {gen1; load2; gen3};

[V, I, P, Q] = calculate_power_flow(a_bus, a_branch);
Y = get_admittance_matrix(3, a_branch);

x_equilibrium = cell(numel(a_component), 1);
for k=1:numel(a_component)
   x_equilibrium{k} = a_component{k}.set_equilibrium(V(k), I(k), P(k), Q(k)); 
end

x0 = vertcat(x_equilibrium{:});

tspan = [0 50];

bus_U = [1; 2];
U = {@(t) 0; @(t) [0.05*t/50; 0.05*t/50]};

[t, x, V, I] = simulate_power_system(a_component, Y, x0,...
    tspan, [], [], U, bus_U);

plot(t, [x{1}(:, 2), x{3}(:, 2)])