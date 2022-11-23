function [out, V, I, P, Q] = func_power_flow(x, Y, a_bus)

V = x(1:2:end) + 1j*x(2:2:end);
I = Y*V;
PQhat = V.*conj(I);
P = real(PQhat);
Q = imag(PQhat);

out_cell = cell(numel(a_bus), 1);

for i = 1:numel(a_bus)
  bus = a_bus{i};
  out_cell{i} = bus.get_constraint(...
    real(V(i)), imag(V(i)), P(i), Q(i));
end
out = vertcat(out_cell{:});

end