x0 = [1; 0; 1; 0; 1; 0];
options = optimoptions('fsolve', 'Display', 'iter');
x_sol = fsolve(@func_ex2, x0, options);
[~, V, I, P, Q] = func_ex2(x_sol);
Vabs = abs(V);
Vangle = angle(V);
display('Vabs:'), display(Vabs')
display('Vangle:'), display(Vangle')
display('P:'), display(P')
display('Q:'), display(Q')