options = optimoptions('fsolve', 'Display', 'iter');
x0 = [-0.5; -0.5];
x_sol = fsolve(@func_ex1, x0, options)