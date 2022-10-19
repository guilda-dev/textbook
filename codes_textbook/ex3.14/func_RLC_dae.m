function dx = func_RLC_dae(x, R, C, L, E)

iR = x(1);
iL = x(2);
iC = x(3);
vR = x(4);
vL = x(5);
vC = x(6);

diL = vL;
dvC = iC;

con1 = vC-vL;
con2 = E-vC-vR;
con3 = iR-(iC+iL);
con4 = vR-iR*R;

dx = [diL; dvC; con1; con2; con3; con4];
end