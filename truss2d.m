% 2D Truss


[ior] = fopen('input.txt', 'rt');  % ���� �б�
[iow] = fopen('output.txt', 'wt');  % �������� �����

% ù���� ������. �о �״�� �ٽ� ���
fseek(ior, 0, 'bof');
firstString = fgets(ior);
fprintf(iow, firstString);

[MandN, count] = fscanf(ior, '%d', 4); % �ι�°�� �� 4���� �о ���ͷ� ����
NoOfEle = MandN(1,1); % �� ������Ʈ ��
NoOfNode = MandN(2,1);  % �� ����
GenerationLevel = MandN(3,1);
PlotterControl = MandN(4,1);
fprintf(iow, '%s %5d \n', 'Number of Elements:', NoOfEle);
fprintf(iow, '%s %5d \n', 'Number of Nodes:', NoOfNode);
fprintf(iow, '%s %5d \n', 'Generation Level:', GenerationLevel);
fprintf(iow, '%s %5d \n', 'Plotter Control:', PlotterControl);

[PMAT, count] = fscanf(ior, '%e', 3); % ����°��
PropertyE = PMAT(1,1);
PropertyI = PMAT(2,1);
PropertyA = PMAT(3,1);
fprintf(iow, '%s %e \n', 'Modulus of Elasticity(E)', PropertyE);
fprintf(iow, '%s %e \n', 'Second Moment of Area(I)', PropertyI);
fprintf(iow, '%s %e \n', 'Area(A)', PropertyA);

for k=1:1:NoOfNode
    [NFIX, count] = fscanf(ior, '%d', 4);
    [NCOORD, count] = fscanf(ior, '%f', 3);
    [NFORCE, count] = fscanf(ior, '%f', 3);
    % fixity
    NoFix(1,k) = NFIX(2,1); % k���� x
    NoFix(2,k) = NFIX(3,1); % k���� y
    NoFix(3,k) = NFIX(4,1); % k���� z
    % coordinate
    Coord(1,k) = NCOORD(1,1); % k���� x
    Coord(2,k) = NCOORD(2,1); % k���� y
    Coord(3,k) = NCOORD(3,1); % k���� z
    % force
    Force(1,k) = NFORCE(1,1); % k���� x
    Force(2,k) = NFORCE(2,1); % k���� y
    Force(3,k) = NFORCE(3,1); % k���� z
end

fprintf(iow, '\n');
fprintf(iow, 'NODE    FIXITY  X-COORD Y-COORD Z-COORD X-LOAD  Y-LOAD  Z-LOAD  \n');
for k=1:1:NoOfNode
    fprintf(iow, '%-8d %-2d %-2d %-2d %-8.4f %-8.4f %-8.4f %-8.4f %-8.4f %-8.4f \n', k, NoFix(1,k), NoFix(2,k), NoFix(3,k), Coord(1,k), Coord(2,k), Coord(3,k), Force(1,k), Force(2,k), Force(3,k));
end

% Connectivity
for k=1:1:NoOfEle
    [NNODE, count] = fscanf(ior, '%d', 4);
    Node(1,k) = NNODE(3,1);
    Node(2,k) = NNODE(4,1);
end

fprintf(iow, '\n');
fprintf(iow, 'ELEMENT NO.  N1   N2     \n');
for k=1:1:NoOfEle
    fprintf(iow, '%-18d %5d %5d \n', k, Node(1,k), Node(2,k));
end
fprintf(iow, '\n');
    
fclose(ior);
fclose(iow);

% Element matrix �����
for k=1:1:NoOfEle
    [KeMat(:,:,k) TMat(:,:,k) KeLocal(:,:,k)] = MakeEleMat(Coord(1,Node(1,k)), Coord(2,Node(1,k)), Coord(1,Node(2,k)), Coord(2,Node(2,k)), PropertyE, PropertyA);
    % ù��° ����� x��ǥ, ù��° ����� y��ǥ, �ι�° ����� x��ǥ, �ι�° ����� y��ǥ, E, A
    strLine = ['ELEMENT STIFFNESS MATRIX FOR ELEMENT ', num2str(k)];
    MatrixAppending(strLine, KeMat(:,:,k));
end

% Global matrix�� �����
GlobalMat = zeros(NoOfNode*2);
for k=1:1:NoOfEle
    tEleGlobalMat(:,:,k)=MakeEleGlobalMat(KeMat(:,:,k), Node(1,k), Node(2,k), NoOfNode);
    % Element matrix, connectivity1, connectivity2, �� ����
    GlobalMat = GlobalMat + tEleGlobalMat(:,:,k);
end
MatrixAppending('GLOBAL STIFFNESS MATRIX', GlobalMat);

% Reduced Global Matrix �����
[ReGlobalMat FixVectorLocation RowOfFVL] = MakeReGlobalMat(GlobalMat, NoFix);
% FixVectorLocation: displacement�� �𸣴� ���� ��ġ�� �ϳ��� ���ͷ� ��Ÿ����
% RowOfFVL: FidVectorLocation�� ���� ����
MatrixAppending('REDUCED GLOBAL STIFFNESS MATRIX', ReGlobalMat);

% Reduced Global Matrix�� �´� Force ���� �����
ReForceVector = MakeForceVector(Force, FixVectorLocation, RowOfFVL);

% Displacement ���ϱ�
Dis = SolveDis(ReGlobalMat, ReForceVector, NoOfNode, FixVectorLocation, RowOfFVL);
VectorAppending('d', Dis);

% ��ü �ܷ� ���ϱ�
Fext = GlobalMat*Dis;
VectorAppending('F', Fext);

% Member force ���ϱ�
for k=1:1:NoOfEle
    MemberF(:,:,k) = SolveMemberF(KeLocal(:,:,k), TMat(:,:,k), Dis(Node(1,k)*2-1:Node(1,k)*2), Dis(Node(2,k)*2-1:Node(2,k)*2));
    % Local Ke, T matrix, 1�� ������� �ش��ϴ� x,y��ǥ�� �ϳ��� ���ͷ�, 2�� ������� �ش��ϴ� x,y��ǥ�� �ϳ��� ���ͷ�
    strLine = ['MEMBER FORCE ', num2str(k)];
    MatrixAppending(strLine, MemberF(:,:,k));
end