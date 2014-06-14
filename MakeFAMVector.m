% Reduced Global matrix�� �´� Force Vector �����

function ReFAMVector = MakeFAMVector(Force, Moment, FixVectorLocation, RowOfFVL);

[RowOfForce ColOfForce] = size(Force);
[RowOfMoment ColOfMoment] = size(Moment);
ForceXY = Force(1:RowOfForce-1,1:ColOfForce);
MomentZ = Moment(RowOfMoment,1:ColOfMoment);
ForAndMo = [ForceXY;MomentZ]; %������ ���Ʈ ��ħ
[RowOfFAM ColOfFAM] = size(ForAndMo);

% Force�� ���� �ϳ��� ���ͷ� �����
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