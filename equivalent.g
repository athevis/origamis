#This Function determines, wether two given Origamis O and O' are equivalent
#input: two Origamis O and O'
#output: result is true, if O and O' are equivalent, fales else
IsEquivalentNaiv:=function(Origami1, Origami2)
	local G, g;
	if CycleStructurePerm(Origami1.x) <> CycleStructurePerm(Origami2.x) then return false; fi;
	if CycleStructurePerm(Origami1.y) <> CycleStructurePerm(Origami2.y) then return false; fi;

	G:=SymmetricGroup(Origami1.d);
	for g in G do
		if g^-1 * Origami1.x * g = Origami2.x then
			if g^-1 * Origami1.y * g = Origami2.y then return true; fi;
		fi;
	od;
	return false;
end;


#This Function determines, wether two given Origamis O and O' are equivalent
#input: two Origamis O and O'
#output: result is true, if O and O' are equivalent, fales else
IsEquivalentViaCanonicalImage:=function(Origami1, Origami2)
	local G, g, c, newY, CI1, CI2;
	if CycleStructurePerm(Origami1.x) <> CycleStructurePerm(Origami2.x) then return false; fi;
	if CycleStructurePerm(Origami1.y) <> CycleStructurePerm(Origami2.y) then return false; fi;

	G:= SymmetricGroup(Origami1.d);
	CI1:= CanonicalImage(G, [Origami1.x, Origami1.y], OnTuples);
	CI2:= CanonicalImage(G, [Origami2.x, Origami2.y], OnTuples);
	if CI1 = CI2 then return true; fi;
	return false;
end;


#This Function determines, wether two given Origamis O and O' are equivalent
#input: two Origamis O and O'
#output: result is true, if O and O' are equivalent, fales else
IsEquivalentViaCentralizer:=function(Origami1, Origami2)
	local G, g, c, newY;
	if CycleStructurePerm(Origami1.x) <> CycleStructurePerm(Origami2.x) then return false; fi;
	if CycleStructurePerm(Origami1.y) <> CycleStructurePerm(Origami2.y) then return false; fi;

	G:= SymmetricGroup(Origami1.d);
	g:= RepresentativeActionOp(G, Origami1.x, Origami2.x, OnPoints);
	newY:= (Origami1.y)^g;
	for c in Centralizer(G, Origami2.x) do
		if newY^c = Origami2.y then return true; fi;
	od;
	return false;
end;



#This Function determines, wether two given Origamis O and O' are equivalent
#input: two Origamis O and O'
#output: result is true, if O and O' are equivalent, fales else
IsEquivalentViaCanonicalOrigami:=function(Origami1, Origami2)
	local G, g, c, newY, CI1, CI2;
	if CycleStructurePerm(Origami1.x) <> CycleStructurePerm(Origami2.x) then return false; fi;
	if CycleStructurePerm(Origami1.y) <> CycleStructurePerm(Origami2.y) then return false; fi;

	G:= SymmetricGroup(Origami1.d);
	CI1:= CanonicalOrigami(Origami1);
	CI2:= CanonicalOrigami(Origami2);
	if CI1 = CI2 then return true; fi;
	return false;
end;
