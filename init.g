LoadPackage("orb");
LoadPackage("images");
LoadPackage("profiling");


#Definition of the free group F_2 in S and T = <S,T>
if not IsBound(F) then
	F:=FreeGroup("S", "T");
	gens:= GeneratorsOfGroup(F);
	S:=gens[1];
	T:=gens[2];
fi;



Read("canonical.g");
Read("action.g");
Read("equivalent.g");
Read("./hash/hash-tuples.gi");
Read("./hash/orbit.g");
Read("origami-list.g");
Read("det_veech_group.g");
Read("examples.g");
Read("profile.g");
