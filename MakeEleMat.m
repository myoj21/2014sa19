% Make Element Matrix

function [EleMat TMat KeLocal] = MakeEleMat(Coord1x, Coord1y, Coord2x, Coord2y, PropE, PropA)

Length = sqrt((Coord2x-Coord1x)^2+(Coord2y-Coord1y)^2);

% theta: radian
if ((Coord2x - Coord1x) == 0 && Coord1y < Coord2y)
    theta = pi/2;
elseif ((Coord2x - Coord1x) == 0 && Coord1y > Coord2y)
    theta = 3*pi/2;
elseif (Coord1x > Coord2x)
    ttheta = atan((Coord2y-Coord1y)/(Coord2x-Coord1x));
    theta = ttheta + pi;
elseif (Coord1x < Coord2x && Coord1y > Coord2y)
    ttheta = atan((Coord2y-Coord1y)/(Coord2x-Coord1x));
    theta = ttheta + 2*pi;
else
    theta = atan((Coord2y-Coord1y)/(Coord2x-Coord1x));
end

TMat = MakeTMat(theta);
KeLocal = MakeKeLocal(PropE, PropA, Length);

EleMat = TMat'*KeLocal*TMat;