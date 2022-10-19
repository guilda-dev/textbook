clear
close all

a_branch = cell(2, 1);
a_branch{1} = branch(1, 2, 1.3652-11.6040j);
a_branch{2} = branch(2, 3, -10.5107j);

Y = get_admittance_matrix(3, a_branch);

gen1 = generator(60*2*pi, 100, 10, 5.14,...
  1.569, 0.936, 2.5158, 2.7038);

load2 = load_impedance(1.3224);

gen3 = generator(60*2*pi, 12, 10, 8.97,...
  1.220, 0.667, 0.5000, 2.1250);

a_component = {gen1; load2; gen3};

x0 = [0.5357 + pi/6; 0; 2.3069 + 0.1; 0.0390; 0; 2.0654];
tspan = [0 50];

[t, x, V, I] = simulate_power_system(a_component, Y, x0, tspan);

plot(t, [x{1}(:, 2), x{3}(:, 2)])