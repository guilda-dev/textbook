classdef bus_generator
  
  properties
    P
    Vabs
  end
  
  methods
    function obj = bus_generator(P, Vabs)
      obj.P = P;
      obj.Vabs = Vabs;
    end
    
    function out = get_constraint(obj, Vr, Vi, P, Q)
      Vabs = norm([Vr; Vi]);
      out = [obj.P-P; Vabs-obj.Vabs];
    end
  end
end