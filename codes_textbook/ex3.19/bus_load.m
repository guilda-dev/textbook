classdef bus_load
  
  properties
    P
    Q
  end
  
  methods
    function obj = bus_load(P, Q)
      obj.P = P;
      obj.Q = Q;
    end
    
    function out = get_constraint(obj, Vr, Vi, P, Q)
      out = [P-obj.P; Q-obj.Q];
    end
  end
end