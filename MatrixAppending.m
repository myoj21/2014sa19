% matrix appending
% matrix를 출력파일에 출력하기

function MatrixAppending(StringLine, Mat);
% 설명라인(StringLine), matrix(Mat)

[wMat] = fopen('output.txt', 'at');  % 파일에 이어쓰기
fprintf(wMat, '%s \n', StringLine);

[RowOfMat, ColOfMat] = size(Mat);
for k=1:1:RowOfMat
    for m=1:1:ColOfMat
        if (abs(Mat(k,m)) < 1.0e-10)
            Mat(k,m) = 0;
        end
        fprintf(wMat, '%.4e \t\t\t', Mat(k,m));
    end
    fprintf(wMat, '\n');
end
fprintf(wMat, '\n');
fclose(wMat);