% Make Element Global Sub matrix
% Element matrix�� 2x2 ��ķ� ���� �� �װ��� global matrix�� ������� ���� �����

function EleSub = MakeEleSub(SubKeMat, k, Node1, Node2, NoOfNode)

tEGMat = zeros(NoOfNode*2);

if (k == 1)
    tEGMat(Node1*2-1:Node1*2, Node1*2-1:Node1*2) = SubKeMat;
elseif (k == 2)
    tEGMat(Node1*2-1:Node1*2, Node2*2-1:Node2*2) = SubKeMat;
elseif (k == 3)
    tEGMat(Node2*2-1:Node2*2, Node1*2-1:Node1*2) = SubKeMat;
elseif (k == 4)
    tEGMat(Node2*2-1:Node2*2, Node2*2-1:Node2*2) = SubKeMat;
end

EleSub = tEGMat;