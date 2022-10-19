classdef bus_slack
  
  properties
    Vabs
    Vangle
  end
  
  methods
    function obj = bus_slack(Vabs, Vangle)
      obj.Vabs = Vabs;
      obj.Vangle = Vangle;
    end
    
    function out = get_constraint(obj, Vr, Vi, P, Q)
      Vabs = norm([Vr; Vi]);
      Vangle = atan2(Vi, Vr);
      out = [Vabs-obj.Vabs; Vangle-obj.Vangle];
    end
  end
end