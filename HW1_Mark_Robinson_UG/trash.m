lin = 1:20;
index = find(mod(lin, 2) == 0);
lin(index) = -1 * lin(index)

r = rand([1,5]);
index = find(r < 0.5);
r(index) = 0