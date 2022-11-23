function [V, I, P, Q] = calculate_power_flow(a_bus, a_branch)

n_bus = numel(a_bus);
Y = get_admittance_matrix(n_bus, a_branch);

func_curried = @(x) func_power_flow(x, Y, a_bus);

x0 = kron(ones(n_bus, 1), [1; 0]);
options = optimoptions('fsolve', 'Display', 'iter');
x_sol = fsolve(func_curried, x0, options);

[~, V, I, P, Q] = func_curried(x_sol);
end