% Reduced Global Matrix 만들기

function [ReducedMat FixVectorLocation RowOfFVL] = MakeReGlobalMat(GlobalMat, NoFix)

[RowOfNoFix ColOfNoFix] = size(NoFix);
NoFixXY = NoFix(1:RowOfNoFix - 1, 1:ColOfNoFix);

% 0과 1의 값을 바꾼다.
% 그렇게하면 0의 값을 가지고 있으면 아는 값(즉, 변위가 0)이 되고, 아니면 모르는 값이 된다.
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

% NoFixXY의 값을 하나의 벡터로 만들기
FixVector = [];
for k=1:1:ColOfNoFixXY
    tFix(:,:,k) = NoFixXY(:,k);
    FixVector = [FixVector;tFix(:,:,k)];
end

% FixVector에서 0이 아닌 값이 저장된 위치를 파악
% 정확하게 말하면 FixVector의 값을 모르는 곳의 위치를 파악하는 것
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