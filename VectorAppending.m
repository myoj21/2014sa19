% Oneline print

function VectorAppending(ch, Dis)

[wVe] = fopen('output.txt', 'at');  % 파일에 이어쓰기
[RowOfDis ColOfDis] = size(Dis);

cxy = 'x';
cnum = 1;
for k=1:1:RowOfDis
    charCnum = num2str(cnum);
    str = [ch, charCnum, cxy, '  =  '];
    if (cxy == 'x')
        cxy = 'y';
    else
            cxy = 'x';
            cnum = cnum + 1;
    end
    fprintf(wVe, '%s %-10.6f \n', str, Dis(k));
end
fprintf(wVe, '\n');
fclose(wVe);