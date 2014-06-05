% Reduced Global matrix에 맞는 Force Vector 만들기

function ReForceVector = MakeForceVector(Force, FixVectorLocation, RowOfFVL);

[RowOfForce ColOfForce] = size(Force);
ForceXY = Force(1:RowOfForce-1,1:ColOfForce);

% Force의 값을 하나의 벡터로 만들기
ForceVector = [];
for k=1:1:ColOfForce
    tForce(:,:,k) = ForceXY(:,k);
    ForceVector = [ForceVector;tForce(:,:,k)];
end

ReForceVector = [];
for k=1:1:RowOfFVL
    tReForceVector(:,:,k) = ForceVector(FixVectorLocation(k));
    ReForceVector = [ReForceVector;tReForceVector(:,:,k)];
end