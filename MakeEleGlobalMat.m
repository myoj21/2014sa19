% Element Global matrix
% Element matrix를 Global matrix 형태로 만들기

function EGMat = MakeEleGlobalMat(KeMat, Node1, Node2, NoOfNode)

tKeMat(:,:,1) = KeMat(1:3,1:3);
tKeMat(:,:,2) = KeMat(1:3,4:6);
tKeMat(:,:,3) = KeMat(4:6,1:3);
tKeMat(:,:,4) = KeMat(4:6,4:6);
%Ke의 크기에 맞게 수정
EGMat = zeros(NoOfNode*3);
for k=1:1:4
    pKeMat(:,:,k) = MakeEleSub(tKeMat(:,:,k), k, Node1, Node2, NoOfNode);
    EGMat = EGMat + pKeMat(:,:,k);
end
