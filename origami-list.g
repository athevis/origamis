CalcOrigamiList := function(d)
	local C, part, Sd, canonicals, canonicals_x, canonicals_y, x;
  part := Partitions(d);
  canonicals := [];
  canonicals_x := List(part, x -> CanonicalPermFromCycleStructure(CycleStructureFromPartition(x)));
	Sd := SymmetricGroup(d);
	for x in canonicals_x do
    C:=Centralizer(Sd, x);
    canonicals_y := List( OrbitsDomain(C, Sd, OnPoints), Minimum);
    Append(canonicals, List(canonicals_y, y -> rec(d := d, x := x, y := y)));
	od;
	return canonicals;
end;


CalcOrigamiListForx := function(permx, d)
  local Sd, C, canonicals_y, partOfCanonicals;
  partOfCanonicals:=[];
  Sd := SymmetricGroup(d);
  C:=Centralizer(Sd, permx);
  canonicals_y := List( OrbitsDomain(C, Sd, OnPoints), Minimum);
	Append(partOfCanonicals, List(canonicals_y, y -> rec(d := d, x := permx, y := y)));
	return partOfCanonicals;
end;


CalcOrigamiListWithSubroutine := function(d)
	local C, part, Sd, canonicals, canonicals_x, canonicals_y, x;
  part := Partitions(d);
  canonicals := [];
  canonicals_x := List(part, x -> CanonicalPermFromCycleStructure(CycleStructureFromPartition(x)));
	Sd := SymmetricGroup(d);
	for x in canonicals_x do
		Append(canonicals, CalcOrigamiListForx(x, d));
	od;
	return canonicals;
end;


CalcOrigamiListExperiment := function(d)
	local C, part, Sd, canonicals, canonicals_x, canonicals_y, x, i, conjugacyClassesOfx, conjugacyClassOfx;
  part := Partitions(d);
  canonicals := [];
  canonicals_x := List(part, x -> CanonicalPermFromCycleStructure(CycleStructureFromPartition(x)));
	Sd := SymmetricGroup(d);
  conjugacyClassesOfx := List( canonicals_x, x -> Set(Enumerate(Orb(Sd,x,OnPoints))) );
  #  make entries of conjugacyClassesOfx readonly
	Perform(conjugacyClassesOfx, MakeImmutable);
  # make sure the entries store that they are sorted lists
	Perform(conjugacyClassesOfx, IsSSortedList);
  for x in canonicals_x do
		C:=Centralizer(Sd, x);
    for i in [1..Length(canonicals_x)] do
      conjugacyClassOfx := conjugacyClassesOfx[i];
      canonicals_y := List( OrbitsDomain(C, conjugacyClassOfx, OnPoints), Minimum);
      Append(canonicals, List(canonicals_y, y -> rec(d := d, x := x, y := y)));
    od;
	od;
	return canonicals;
end;
