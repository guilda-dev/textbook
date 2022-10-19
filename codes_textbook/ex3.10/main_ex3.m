x0 = [1; 0; 1; 0; 1; 0];
options = optimoptions('fsolve', 'Display', 'iter');

y12 = 1.3652 - 11.6040j;
y23 = -10.5107j;
Y = [y12, -y12, 0;
    -y12, y12+y23, -y23;
    0, -y23, y23];

func_curried = @(x) func_ex3(x, Y);

x_sol = fsolve(func_curried, x0, options);
[~, V, I, P, Q] = func_curried(x_sol);