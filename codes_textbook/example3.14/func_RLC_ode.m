function dx = func_RLC_ode(x, R, C, L, E)

iL = x(1);
vC = x(2);

diL = vC/L;
dvC = (E-vC)/R/C - iL/C;

dx = [diL; dvC];

end