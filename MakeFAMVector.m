% Reduced Global matrix에 맞는 Force Vector 만들기

function ReFAMVector = MakeFAMVector(Force, Moment, FixVectorLocation, RowOfFVL);

[RowOfForce ColOfForce] = size(Force);
[RowOfMoment ColOfMoment] = size(Moment);
ForceXY = Force(1:RowOfForce-1,1:ColOfForce);
MomentZ = Moment(RowOfMoment,1:ColOfMoment);
ForAndMo = [ForceXY;MomentZ]; %포스와 모멘트 합침
[RowOfFAM ColOfFAM] = size(ForAndMo);

% Force의 값을 하나의 벡터로 만들기
FAMVector = []; %Force And Moment Vector
for k=1:1:ColOfFAM
    tFAM(:,:,k) = ForAndMo(:,k);
    FAMVector = [FAMVector;tFAM(:,:,k)];
end

ReFAMVector = [];
for k=1:1:RowOfFVL
    tReFAMVector(:,:,k) = FAMVector(FixVectorLocation(k));
    ReFAMVector = [ReFAMVector;tReFAMVector(:,:,k)];
end