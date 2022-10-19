function [t, x, V, I] = simulate_power_system(a_component, ...
  Y, x0, tspan,bus_fault, tspan_fault)

if nargin < 5
  bus_fault = [];
end

if nargin < 6
  tspan_fault = [0, 0];
end

n_component = numel(a_component);
a_nx = zeros(n_component, 1);
for k = 1:n_component
  component = a_component{k};
  a_nx(k) = component.get_nx();
end
nx = sum(a_nx);

M = blkdiag(eye(nx), zeros(n_component*4));
options = odeset('Mass', M, 'RelTol', 1e-6);

y0 = [x0(:); zeros(4*n_component, 1)];

if isempty(bus_fault)
  [t, y] = ode15s(...
    @(t, x) func_simulation(t, x, Y, a_component, []),...
    tspan, y0, options);
else
  [t1, y1] = ode15s(...
    @(t, x) func_simulation(t, x, Y, a_component, bus_fault),...
  tspan_fault, y0, options);
  
  [t2, y2] = ode15s(...
    @(t, x) func_simulation(t, x, Y, a_component, []),...
  [tspan_fault(2), tspan(2)], y1(end, :), options);

  t = [t1; t2];
  y = [y1; y2];
end

x = cell(n_component, 1);
V = zeros(numel(t), n_component);
I = zeros(numel(t), n_component);

idx = 0;

for k = 1:n_component
  x{k} = y(:, idx+(1:a_nx(k)));
  Vk = y(:, nx+2*(k-1)+(1:2));
  V(:, k) = Vk(:, 1) + 1j*Vk(:, 2);
  Ik = y(:, nx+2*n_component+2*(k-1)+(1:2));
  I(:, k) = Ik(:, 1) + 1j*Ik(:, 2);
  idx = idx + a_nx(k);
end

end