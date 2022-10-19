function out = func_simulation(t, x, Y, a_component,...
  bus_fault, U, bus_U)

n_component = numel(a_component);
x_split = cell(n_component, 1);
V = zeros(n_component, 1);
I = zeros(n_component, 1);

idx = 0;
for k = 1:n_component
  nx = a_component{k}.get_nx();
  x_split{k} = x(idx+(1:nx));
  idx = idx + nx;
end

for k = 1:n_component
  V(k) = x(idx+1) + x(idx+2)*1j;
  idx = idx + 2;
end

for k = 1:n_component
  I(k) = x(idx+1) + x(idx+2)*1j;
  idx = idx + 2;
end

dx = cell(n_component, 1);
con = cell(n_component, 1);

for k = 1:n_component
  component = a_component{k};
  xk = x_split{k};
  Vk = V(k);
  Ik = I(k);
  
  if ismember(k, bus_U)
    uk = U{bus_U==k}(t);
  else
    uk = zeros(component.get_nu(), 1);
  end
  
  [dx{k}, con{k}] = component.get_dx_constraint(xk, Vk, Ik, uk);
  
end

con_network = I - Y*V;
con_network(bus_fault) = V(bus_fault);

out = vertcat(dx{:});
out = [out; vertcat(con{:})];
out = [out; real(con_network); imag(con_network)];

end
