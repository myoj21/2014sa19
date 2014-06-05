% Element Global matrix
% Element matrix를 Global matrix 형태로 만들기

function EGMat = MakeEleGlobalMat(KeMat, Node1, Node2, NoOfNode)

tKeMat(:,:,1) = KeMat(1:2,1:2);
tKeMat(:,:,2) = KeMat(1:2,3:4);
tKeMat(:,:,3) = KeMat(3:4,1:2);
tKeMat(:,:,4) = KeMat(3:4,3:4);

EGMat = zeros(NoOfNode*2);
for k=1:1:4
    pKeMat(:,:,k) = MakeEleSub(tKeMat(:,:,k), k, Node1, Node2, NoOfNode);
    EGMat = EGMat + pKeMat(:,:,k);
end
