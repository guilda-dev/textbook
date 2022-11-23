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
  
  function nu = get_nu(obj)
    nu = 2;
  end

  function [dx, con] = get_dx_constraint(obj, x, V, I, u)
    dx = [];
    z = real(obj.z)*(1+u(1)) + 1j*imag(obj.z)*(1+u(2));
    con = V+z*I;
    con = [real(con); imag(con)];
  end

  function x_equilibrium = set_equilibrium(obj, V, I, P, Q)
    x_equilibrium = [];
    obj.z = -V/I;
  end
end

end