function Y = get_admittance_matrix(n_bus, a_branch)
Y = zeros(n_bus, n_bus);

for i = 1:numel(a_branch)
  br = a_branch{i};
  Y_branch = br.get_admittance_matrix();
  Y([br.from, br.to], [br.from, br.to]) =...
    Y([br.from, br.to], [br.from, br.to]) + Y_branch;
end
end