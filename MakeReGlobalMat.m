% Reduced Global Matrix �����

function [ReducedMat FixVectorLocation RowOfFVL] = MakeReGlobalMat(GlobalMat, NoFix)

[RowOfNoFix ColOfNoFix] = size(NoFix);
NoFixXY = NoFix(1:RowOfNoFix - 1, 1:ColOfNoFix);

% 0�� 1�� ���� �ٲ۴�.
% �׷����ϸ� 0�� ���� ������ ������ �ƴ� ��(��, ������ 0)�� �ǰ�, �ƴϸ� �𸣴� ���� �ȴ�.
[RowOfNoFixXY ColOfNoFixXY] = size(NoFixXY);
for k=1:1:RowOfNoFixXY
    for m=1:1:ColOfNoFixXY
        if (NoFixXY(k,m) == 0)
            NoFixXY(k,m) = 1;
        else
            NoFixXY(k,m) = 0;
        end
    end
end

% NoFixXY�� ���� �ϳ��� ���ͷ� �����
FixVector = [];
for k=1:1:ColOfNoFixXY
    tFix(:,:,k) = NoFixXY(:,k);
    FixVector = [FixVector;tFix(:,:,k)];
end

% FixVector���� 0�� �ƴ� ���� ����� ��ġ�� �ľ�
% ��Ȯ�ϰ� ���ϸ� FixVector�� ���� �𸣴� ���� ��ġ�� �ľ��ϴ� ��
FixVectorLocation = [];
for k=1:1:ColOfNoFixXY*2
    if (FixVector(k) == 1)
        FixVectorLocation = [FixVectorLocation;k];
    end
end

[RowOfFVL ColOfFVL] = size(FixVectorLocation);

ReducedMat = [];
for k=1:1:RowOfFVL
    tReducedMat = [];
    for m=1:1:RowOfFVL
        tReducedMat = [tReducedMat, GlobalMat(FixVectorLocation(k), FixVectorLocation(m))];
    end
    ReducedMat = [ReducedMat;tReducedMat];
end