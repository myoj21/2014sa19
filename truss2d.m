% 2D Truss
clear all; clc;

[ior] = fopen('input.txt', 'rt');  % 파일 읽기
[iow] = fopen('output.txt', 'wt');  % 쓰기파일 만들기

% 첫줄은 제목줄. 읽어서 그대로 다시 출력
fseek(ior, 0, 'bof');
firstString = fgets(ior);
fprintf(iow, firstString);

[MandN, count] = fscanf(ior, '%d', 4); % 두번째줄 값 4개를 읽어서 벡터로 저장
NoOfEle = MandN(1,1); % 총 엘리먼트 수
NoOfNode = MandN(2,1);  % 총 노드수
GenerationLevel = MandN(3,1);
PlotterControl = MandN(4,1);
fprintf(iow, '%s %5d \n', 'Number of Elements:', NoOfEle);
fprintf(iow, '%s %5d \n', 'Number of Nodes:', NoOfNode);
fprintf(iow, '%s %5d \n', 'Generation Level:', GenerationLevel);
fprintf(iow, '%s %5d \n', 'Plotter Control:', PlotterControl);

[PMAT, count] = fscanf(ior, '%e', 3); % 세번째줄
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
    [NROTA, count]   = fscanf(ior, '%f', 3);
    [NMOMENT, count]   = fscanf(ior, '%f', 3);
    
    % fixity
    NoFix(1,k) = NFIX(2,1); % k점의 x
    NoFix(2,k) = NFIX(3,1); % k점의 y
    NoFix(3,k) = NFIX(4,1); % k점의 z
    % coordinate
    Coord(1,k) = NCOORD(1,1); % k점의 x
    Coord(2,k) = NCOORD(2,1); % k점의 y
    Coord(3,k) = NCOORD(3,1); % k점의 z
    % force
    Force(1,k) = NFORCE(1,1); % k점의 x
    Force(2,k) = NFORCE(2,1); % k점의 y
    Force(3,k) = NFORCE(3,1); % k점의 z
      % rotation
    Rota(1,k) = NROTA(1,1); % k 비틀림
    Rota(2,k) = NROTA(2,1); % k 점의 y방향 로테이션
    Rota(3,k) = NROTA(3,1); % k 점의 z방향 로테이션
     % momnet
    Moment(1,k) = NMOMENT(1,1); % k 점의 x방향 토션
    Moment(2,k) = NMOMENT(2,1); % k 점의 y방향 로테이션
    Moment(3,k) = NMOMENT(3,1); % k 점의 z방향 로테이션
end

fprintf(iow, '\n');
fprintf(iow, 'NODE    FIXITY    X-COORD  Y-COORD  Z-COORD   X-LOAD  Y-LOAD   Z-LOAD   TORSD   Y-ROTA  Z-ROTA  TORSF   Y-MOME   Z-MOME \n');
for k=1:1:NoOfNode
    fprintf(iow, '%-8d %-2d %-2d %-2d %-8.4f %-8.4f %-8.4f %-8.4f %-8.4f %-8.4f %-8.4f %-8.4f %-8.4f%-8.4f %-8.4f %-8.4f \n', k, NoFix(1,k), NoFix(2,k), NoFix(3,k), Coord(1,k), Coord(2,k), Coord(3,k), Force(1,k), Force(2,k), Force(3,k), Rota(1,k), Rota(2,k), Rota(3,k), Moment(1,k), Moment(2,k), Moment(3,k)) ;
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

% Element matrix 만들기
for k=1:1:NoOfEle
    [KeMat(:,:,k) TMat(:,:,k) KeLocal(:,:,k)] = MakeEleMat(Coord(1,Node(1,k)), Coord(2,Node(1,k)), Coord(1,Node(2,k)), Coord(2,Node(2,k)), PropertyE, PropertyI, PropertyA);
    % 첫번째 노드의 x좌표, 첫번째 노드의 y좌표, 두번째 노드의 x좌표, 두번째 노드의 y좌표, E, A
    strLine = ['ELEMENT STIFFNESS MATRIX FOR ELEMENT ', num2str(k)];
    MatrixAppending(strLine, KeMat(:,:,k));
end
%%%%%%%%%%%%%%%%%%%%
% Global matrix를 만들기
GlobalMat = zeros(NoOfNode*3);
for k=1:1:NoOfEle
    tEleGlobalMat(:,:,k)=MakeEleGlobalMat(KeMat(:,:,k), Node(1,k), Node(2,k), NoOfNode);
    % Element matrix, connectivity1, connectivity2, 총 노드수
    GlobalMat = GlobalMat + tEleGlobalMat(:,:,k);
end
MatrixAppending('GLOBAL STIFFNESS MATRIX', GlobalMat);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reduced Global Matrix 만들기
[ReGlobalMat FixVectorLocation RowOfFVL] = MakeReGlobalMat(GlobalMat, NoFix);
% FixVectorLocation: displacement를 모르는 값의 위치를 하나의 벡터로 나타낸것
% RowOfFVL: FidVectorLocation의 행의 갯수
MatrixAppending('REDUCED GLOBAL STIFFNESS MATRIX', ReGlobalMat);

% Reduced Global Matrix에 맞는 Force 벡터 만들기
ReFAMVector = MakeFAMVector(Force,Moment, FixVectorLocation, RowOfFVL);

% Displacement 구하기
Dis = SolveDis(ReGlobalMat, ReFAMVector, NoOfNode, FixVectorLocation, RowOfFVL);
VectorAppending('d', Dis);

% 전체 외력 구하기
Fext = GlobalMat*Dis;
VectorAppending('F', Fext);

% Member force 구하기
for k=1:1:NoOfEle
    MemberF(:,:,k) = SolveMemberF(KeLocal(:,:,k), TMat(:,:,k), Dis(Node(1,k)*3-2:Node(1,k)*3), Dis(Node(2,k)*3-2:Node(2,k)*3));
    % Local Ke, T matrix, 1번 노드점에 해당하는 x,y좌표를 하나의 벡터로, 2번 노드점에 해당하는 x,y좌표를 하나의 벡터로
    strLine = ['MEMBER FORCE ', num2str(k)];
    MatrixAppending(strLine, MemberF(:,:,k));
end