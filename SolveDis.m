% Displacement ±¸ÇÏ±â

function Dis = SolveDis(ReGlobalMat, ReForceVector, NoOfNode, FixVectorLocation, RowOfFVL);

ReDis = ReGlobalMat^-1*ReForceVector;

Dis = zeros(NoOfNode*2, 1);

for k=1:1:RowOfFVL
    Dis(FixVectorLocation(k)) = ReDis(k);
end