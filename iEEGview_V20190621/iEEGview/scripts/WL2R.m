function [Rmn Rmx] = WL2R(W,L)
Rmn = L - (W/2);
Rmx = L + (W/2);
if (Rmn >= Rmx)
    Rmx = Rmn + 1;
end
end