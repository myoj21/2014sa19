% Make Member force 

function MemberF = SolveMemberF(KeLocal, TMat, Dis1, Dis2);

MemberF = KeLocal*TMat*[Dis1;Dis2];