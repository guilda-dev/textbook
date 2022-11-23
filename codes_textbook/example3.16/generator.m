classdef generator < handle
  
properties
  omega0
  X
  X_prime
  M
  D
  tau
  Pmech
  Vfield
end

methods
  function obj = generator(omega0, M, D, tau,...
      X, X_prime, Pmech, Vfield)

    obj.omega0 = omega0;
    obj.X = X;
    obj.X_prime = X_prime;
    obj.M = M;
    obj.D = D;
    obj.tau = tau;
    obj.Pmech = Pmech;
    obj.Vfield = Vfield;
  end

  function nx = get_nx(obj)
    nx = 3;
  end

  function [dx, con] = get_dx_constraint(obj, x, V, I)
    delta = x(1);
    omega = x(2);
    E = x(3);
    P = real(V*conj(I));

    Pmech = obj.Pmech;
    Vfield = obj.Vfield;

    X = obj.X;
    X_prime = obj.X_prime;
    D = obj.D;
    M = obj.M;
    tau = obj.tau;

    omega0 = obj.omega0;

    dE = (-X/X_prime*E+...
      (X/X_prime-1)*abs(V)*cos(delta-angle(V))...
      +Vfield)/tau;
    dx = [omega0 * omega;
      (-D*omega-P+Pmech)/M;
      dE];
    con = I-(E*exp(1j*delta)-V)/(1j*X_prime);
    con = [real(con); imag(con)];
  end
end
  
end