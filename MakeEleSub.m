% Make Element Global Sub matrix
% Element matrix를 2x2 행렬로 나눈 후 그것을 global matrix의 사이즈와 같게 만들기

function EleSub = MakeEleSub(SubKeMat, k, Node1, Node2, NoOfNode)

tEGMat = zeros(NoOfNode*3);

if (k == 1)
    tEGMat(Node1*3-2:Node1*3, Node1*3-2:Node1*3) = SubKeMat;
elseif (k == 2)
    tEGMat(Node1*3-2:Node1*3, Node2*3-2:Node2*3) = SubKeMat;
elseif (k == 3)
    tEGMat(Node2*3-2:Node2*3, Node1*3-2:Node1*3) = SubKeMat;
elseif (k == 4)
    tEGMat(Node2*3-2:Node2*3, Node2*3-2:Node2*3) = SubKeMat;
end
%3X3 사이즈에 맞게 수정
EleSub = tEGMat;