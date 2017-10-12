CalcOrigamiListViaWorkspaces := function(index_x, d)
	local part, numberPartitions, permx, C, Sd, i, conjugacyClassOfx, filename, canonicals_y, partOfCanonicals;
	part := Partitions(d);
	numberPartitions := Length(part);
	permx := CanonicalPermFromPartition(part[index_x]);
	partOfCanonicals := [];
	Sd := SymmetricGroup(d);
	C:=Centralizer(Sd, permx);
	for i in [1..numberPartitions] do
		conjugacyClassOfx := conjugacyClassesOfx[i];
		canonicals_y := List( OrbitsDomain(C, conjugacyClassOfx, OnPoints), Minimum);
		Append(partOfCanonicals, List(canonicals_y, y -> rec(d := d, x := permx, y := y)));
	od;
	filename := Concatenation("outputfiles/origami-list-",String(d),"-",String(index_x));
	PrintTo(filename, partOfCanonicals);
	AppendTo(filename,",");
	return partOfCanonicals;
end;


CreateOrigamiWorkspace := function(d)
	local numberPartitions, C, part, Sd, canonicals_x, canonicals_y, x, i, conjugacyClassOfx;
  part := Partitions(d);
  numberPartitions := Length(part);
  canonicals_x := List(part, x -> CanonicalPermFromPartition(x));
	Sd := SymmetricGroup(d);
  conjugacyClassesOfx := List( canonicals_x, x -> Set(Enumerate(Orb(Sd,x,OnPoints))) );
  #  make entries of conjugacyClassesOfx readonly
	Perform(conjugacyClassesOfx, MakeImmutable);
  # make sure the entries store that they are sorted lists
	Perform(conjugacyClassesOfx, IsSSortedList);
  SaveWorkspace(Concatenation("ConjugacyClasses",String(d),".gapws"));
end;
