classdef load_impedance < handle
  
properties
  z
end

methods
  function obj = load_impedance(z)
    obj.z = z;
  end

  function nx = get_nx(obj)
    nx = 0;
  end

  function [dx, con] = get_dx_constraint(obj, x, V, I)
    dx = [];
    z = obj.z;
    con = V+z*I;
    con = [real(con); imag(con)];
  end
end
end