% Ke Local

function KeLocal = MakeKeLocal(PropE, PropA, Length)

KeLocal = PropE*PropA/Length*[1,-1;-1,1];