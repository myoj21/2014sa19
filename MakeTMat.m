% T Matrix

function TMat = MakeTMat(theta)

TMat=[cos(theta), sin(theta), 0, 0; 0, 0, cos(theta), sin(theta)];