#Calculates a canonical image of a permutation
#Input: a permutation perm
#output: the canonical representation of perm
CanonicalPerm := function(perm)
	local currentIndex, permList, cycleStructure, l, numberOfCycle;
	currentIndex := 1;
	permList:=[2.. NrMovedPoints(perm)];
	Add(permList, 1);
	cycleStructure := CycleStructurePerm( perm );
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



CalcVeechGroup := function(Origami)
	local  Gen,Rep, HelpCalc, D, M, foundM, W, NewGlList, canonicalOrigamiList, i, canonicalM, newReps;
	Gen:= [];
	Rep:= [S*S^-1];
	canonicalOrigamiList:=[CanonicalOrigami(Origami)];
	HelpCalc := function(GlList)
		NewGlList := [];		
		for W in GlList do 
			newReps := [W*T,W*S];
			for M in newReps do
				foundM := false;
				canonicalM := CanonicalOrigami(ActionOfSl(M, Origami));				
				for i in [1..Length(Rep)] do
					if canonicalOrigamiList[i] = canonicalM then
						D:=Rep[i];
						Add(Gen, M*D^-1);
						foundM := true;
						break;
					fi;
				od;
				if foundM = false then 
					Add(Rep, M);
					Add(canonicalOrigamiList, canonicalM);
					Add(NewGlList, M);
				fi;
			od;
		od;
		if Length(NewGlList) > 0 then HelpCalc(NewGlList); fi;
	end;
	HelpCalc([S*S^-1]);
	return rec(rep:=Rep, gen:=Gen);
end;
