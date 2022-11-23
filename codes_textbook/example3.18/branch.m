classdef branch
  
  properties
    y
    from
    to
  end
  
  methods
    function obj = branch(from, to, y)
      obj.from = from;
      obj.to = to;
      obj.y = y;
    end
    
    function Y = get_admittance_matrix(obj)
      y = obj.y;
      Y = [y, -y;
        -y,  y];
    end
  end
end