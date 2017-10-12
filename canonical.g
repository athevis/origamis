CycleStructureFromPartition := function(partition)
	local i,  permList, cycleStructure;
  cycleStructure:=[];
  for i in partition do
    if i <> 1 then
      if not IsBound(cycleStructure[i-1]) then
        cycleStructure[i-1]:=1;
      else
        cycleStructure[i-1]:=cycleStructure[i-1]+1;
      fi;
    fi;
  od;
	return cycleStructure;
end;


CanonicalPermFromCycleStructure := function(cycleStructure)
  local currentIndex, l, numberOfCycle, permList, d, i;
  if IsEmpty(cycleStructure) then
    return ();
  fi;
  currentIndex := 1;
  d:=0;
  for i in [1..Length(cycleStructure)] do
    if IsBound(cycleStructure[i]) then
      d:=d+(cycleStructure[i])*(i+1);
    fi;
  od;
  permList:=[2.. d];
  Add(permList, 1);
  for l in [1..Length(cycleStructure) ] do
    if IsBound(cycleStructure[l]) then
      for numberOfCycle in [1.. cycleStructure[l]] do
        permList[currentIndex + l ]:= currentIndex;
        currentIndex:= currentIndex + l + 1;
      od;
    fi;
  od;
  return PermList(permList);
end;


CanonicalPermFromPartition := function(part)
    return CanonicalPermFromCycleStructure(CycleStructureFromPartition(part));
end;


#Calculates a canonical image of a permutation
#Input: a permutation perm
#output: the canonical representation of perm
CanonicalPerm := function(perm)
	local cycleStructure;
	cycleStructure := CycleStructurePerm( perm );
	return CanonicalPermFromCycleStructure(cycleStructure);
end;



CanonicalOrigami := function(Origami)
	local g,C, y, Sd, Cent;
	Sd:=SymmetricGroup(Origami.d);
	C := CanonicalPerm(Origami.x);
	g := RepresentativeActionOp(Sd, Origami.x, C , OnPoints);
	y := Origami.y^g;
	Cent:= Centralizer(Sd,C);
	#y := CanonicalImage(Cent, y, OnPoints);
	y := Minimum( Orbit( Cent, y, OnPoints ) );
	return rec(d:=Origami.d, x:= C, y:= y);
end;
