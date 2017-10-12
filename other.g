
#This function calculates the coset graph of the veech group of a given Origami O
#INPUT: An origami
#OUTPUT: The coset Graph as adjiency Matrix
CalcCosetGraph := function(Origami)
	local  Rep, HelpCalc, D, B, A, foundA, foundB, W, NewGlList, SAdjMatrix, TAdjMatrix, number, triangle2; #Rep are now the Edges of the Graph
	SAdjMatrix:=[[]];
	TAdjMatrix:=[[]];
	Rep:= [S*S^-1];
	HelpCalc :=function(GlList) # vielleicht noch Olist
		NewGlList:=[];
		for W in GlList do
			foundA:= false;
			foundB:= false;
			A:= W*T;
			B:= W*S;
			for D in Rep do
				if IsEquivalentViaCentralizer(Origami, ActionOfSl(B*D^-1, Origami)) then
					foundB:= true;
			                SAdjMatrix[Position(Rep, W)][Position(Rep, D)]:= 1;
				fi;
			od;
			for D in Rep do
				if IsEquivalentViaCentralizer(Origami, ActionOfSl(A*D^-1, Origami)) then
				TAdjMatrix[Position(Rep, W)][Position(Rep, D)]:= 1;
					foundA:= true;
				fi;
			od;
			if foundA = false then
				Add(NewGlList, A);
				Add(Rep, A);
				Add(SAdjMatrix, []);
				Add(TAdjMatrix, []);
				TAdjMatrix[Position(Rep, W)][Position(Rep, A)]:= 1;  # = Length(Rep) -1 ?
			fi;

			if foundB = false then
				Add(NewGlList, B);
				Add(Rep, B);
				Add(SAdjMatrix, []);
				Add(TAdjMatrix, []);
			        SAdjMatrix[Position(Rep, W)][Position(Rep, B)]:= 1;  # = Length(Rep) ?
			fi;
		od;
		if Length(NewGlList) > 0 then HelpCalc(NewGlList); fi;
	end;
	HelpCalc([S*S^-1]);
	return [Rep, SAdjMatrix, TAdjMatrix];
end;

#This function calculates the coset Grapg of the Veech group of an given Origami O
#INPUT: An origami
#OUTPUT: The coset Graph as Permutations sigma_S and Sigma_T
CalcCosetGraphPerm := function(Origami)
	local  Rep, HelpCalc, D, B, A, foundA, foundB, W, NewGlList, sigma_S, sigma_T, number, triangle2; #Rep are now the Edges of the Graph
	sigma_S:=[];
	sigma_T:=[];
	Rep:= [S*S^-1];
	HelpCalc :=function(GlList) # vielleicht noch Olist
		NewGlList:=[];
		for W in GlList do
			foundA:= false;
			foundB:= false;
			A:= W*T;
			B:= W*S;
			for D in Rep do
				if IsEquivalentViaCentralizer(Origami, ActionOfSl(B*D^-1, Origami)) then
					foundB:= true;
			                sigma_S[Position(Rep, W)]:=Position(Rep, D);
				fi;
			od;
			for D in Rep do
				if IsEquivalentViaCentralizer(Origami, ActionOfSl(A*D^-1, Origami)) then
					sigma_T[Position(Rep, W)]:=Position(Rep, D);
					foundA:= true;
				fi;
			od;
			if foundA = false then
				Add(NewGlList, A);
				Add(Rep, A);
				sigma_T[Position(Rep, W)]:=Position(Rep, A);  # = Length(Rep) -1 ?
			fi;

			if foundB = false then
				Add(NewGlList, B);
				Add(Rep, B);
			        sigma_S[Position(Rep, W)]:=Position(Rep, B);  # = Length(Rep) ?
			fi;
		od;
		if Length(NewGlList) > 0 then HelpCalc(NewGlList); fi;
	end;
	HelpCalc([S*S^-1]);
	return rec(sigma_S:= PermList(sigma_S), sigma_T:= PermList(sigma_T));
end;


CalcGeomType:=function(Origami)
	local i, j, rep, Rep,Matrix_T, Matrix_S ,TriangleList, triangle,CurrentTriangle , verteces, S_Edges, E, V, T, number, v_tilde, n, current, aditional, CycleStructure;
	Rep:=CalcCosetGraph(Origami)[1];
	Matrix_S:=CalcCosetGraph(Origami)[2];
	Matrix_T:=CalcCosetGraph(Origami)[3];
	verteces:=[];
	TriangleList:=[];
	S_Edges:=[];
	aditional:=0;
	for i in [1..Length(Rep)] do Add( S_Edges, true); od;
	for i in [1.. 3*Length(Rep)] do Add(verteces, true); od;
	i:=1;
	for rep in Rep do
		triangle:=rec(label:= rep, P0:= 3*(i - 1) + 1, P1:= 3*(i - 1) + 2, Pinf:= 3*(i - 1) + 3, S_Edge:= i);
		Add(TriangleList, triangle);
		i:= i + 1;
	od;
	# Now we clue the T-Edges
	j:=1;
	for triangle in TriangleList do
		i:=Position(Matrix_T[j], 1); # Now we have to clue the T-Edge od triangle_j with the T^-1- Edge of triangle_i
		if triangle.Pinf <> TriangleList[i].Pinf then
			verteces[TriangleList[i].Pinf]:= false;
			number:=TriangleList[i].Pinf;
			for CurrentTriangle in TriangleList do
				if CurrentTriangle.Pinf = number then CurrentTriangle.Pinf:= triangle.Pinf; fi;
			od;
		fi;

		if triangle.P1 <> TriangleList[i].P0 then
			verteces[TriangleList[i].P0]:= false;
			number:=TriangleList[i].P0;
			for CurrentTriangle in TriangleList do
				if CurrentTriangle.P0 = number then CurrentTriangle.P0:= triangle.P1; fi;
			od;
		fi;
		j:= j + 1;
	od;
	# Now we clue the S-Edges
	j:=1;
	for triangle in TriangleList do
		i:= Position(Matrix_S[j], 1); #Now we have to clue the S-Edge od triangle_j with the S- Edge of triangle_i
		if triangle.label = TriangleList[i].label then # Now we have to clue the triangle with itself, but we only have to clue the P0- vertice with the P1 vertice, everything else does not change the genium
			aditional:= aditional + 1;
			if triangle.P0 <> triangle.P1 then
				verteces[triangle.P1]:=false;
				number:=triangle.P1;
				for CurrentTriangle in TriangleList do
					if CurrentTriangle.P1 = number then CurrentTriangle.P0:= triangle.P0; fi;
				od;
			fi;
		else
			# we clue the P0 vertice of triangle_i with the P0 vertice of triangle_j
			if triangle.P0 <> TriangleList[i].P0 then
				verteces[TriangleList[i].P0]:= false;
				number:=TriangleList[i].P0;
				for CurrentTriangle in TriangleList do
					if CurrentTriangle.P0 = number then CurrentTriangle.P0:= triangle.P0; fi;
				od;
			fi;
			# we clue the P1 vertice of triangle_i with the P1 vertice of triangle_j
			if triangle.P1 <> TriangleList[i].P1 then
				verteces[TriangleList[i].P1]:= false;
				TriangleList[i].P1:= triangle.P1;
				number:= TriangleList[i].P1;
				for CurrentTriangle in TriangleList do
					if CurrentTriangle.P1 = number then CurrentTriangle.P1 := triangle.P1;fi;
				od;

			fi;
			# we clue the S_Edge of triangle_i with the S_edge of triangle_j
			if triangle.S_Edge <> TriangleList[i].S_Edge then
				S_Edges[TriangleList[i].S_Edge]:=false;
				TriangleList[i].S_Edge:=triangle.S_Edge;
			fi;
		fi;
		j:= j + 1;
	od;
	T:= Length(Rep); # Number of Triangles
	V:=0; # The number of verteces
	for i in verteces do
		if i = true then V:=V+1; fi;
	od;
	E:=T;
	for i in S_Edges do
		if i = true then E:= E + 1; fi;
	od;
	Print("E: ");
	Print(E);
	Print("\n");
	Print("V: ");
	Print(V);
	Print("\n");
	Print("T: ");
	Print(T);
	#	Print((2 -(V - E + T)) / 2);
	for rep in TriangleList do
		Print(rep);
		Print("\n");
	od;
	v_tilde:=0;
	for i in [1..Length(TriangleList)] do
		if verteces[ i * 3] = true then v_tilde:= v_tilde + 1; fi;
	od;
	Print("\n");
	Print("Spitzen: ");
	Print(v_tilde);
	Print("\n");
	Print("Geschlecht ");
	Print((2 - (T + V - E + aditional))/2);
	###### Now we calculate n
	n:=1;
	CycleStructure:= CycleStructurePerm(CalcCosetGraphPerm(Origami).sigma_T);
	for i in [1..Length(CycleStructure)] do
		if IsBound(CycleStructure[i]) = true then n:=LcmInt(n, i + 1); fi;
	od;
	Print("\n");
	Print("n: ");
	Print(n);
end;


#This function Calculates represents of each Orbit of Origamis, of an given degree, under the Sl_2(Z) action.
#INPUT: the degree d of the Origamis
#OUTPUT: A compledte List of Origamis, each contained in exactly one orbit.

CalcOrbit := function(d)
	local S1, S2, sigma_1, sigma_2, OrbitList, H, O, i, j, Rep, rep, actedO, current, currentO, DeleteIndex;
	# First Step: We generate a List of all Origamis as transitive pair in S_d. Here we ignore eqivalent Origamis.
	OrbitList:=[];
	S1 := SymetricGroup(d);
	S2 := SymetricGroup(d);
	for sigma_1 in S1 do
		for sigma_2 in S2 do
			H:=Group(sigma_1, sigma_2);
			if IsTransitive(H,[1..d]) then
				Add(OrbitList, rec(d:=d, x:=sigma_1, y:=sigma_2));
			fi;
		od;
	od;
	Print(OrbitList);
	# Second Step Now we start with the first Element of OrbitList and delete eauch Origami, which is equivalent or on the same Orbit
	i := 2;
	for O in OrbitList do
		Rep:=CalcVeechGroup(O);
		for rep in Rep do
			actedO:= ActionOfSl(rep, O);
			DeleteIndex:=[];
			for current in [i..Length(OrbitList)] do
				currentO:= OrbitList[current];
				if IsEquivalentViaCentralizer(actedO, currentO) then
					Add(DeleteIndex, Position(OrbitList, currentO)); # we wil delete currentO from the List
				fi;
			od;
			j:=0;
			for current in DeleteIndex do
				Remove(OrbitList, current - j);
				j:= j + 1;
			od;
		od;
		i:=i + 1;
	od;
	return OrbitList;
end;


#This function calculates the Stratum of an given Origami
#INPUT: An Origami O
#OUTPUT: The Stratum of the Origami as List of Integers.
CalcStratum:= function(Origami)
	local com, Stratum, CycleStructure, current,i, j;
	com:=Origami.x* Origami.y * Origami.x^(-1) * Origami.y^(-1);
	CycleStructure:= CycleStructurePerm(com);
	Stratum:=[];
	for i in [1..Length(CycleStructure)] do
		if IsBound(CycleStructure[i]) then
			for j in [1..CycleStructure[i]] do
				Add(Stratum, i);
			od;
		fi;
	od;
	return Stratum;
end;

#This function Calculates represents of each Orbit of Origamis, of an given degree and Stratum, under the Sl_2(Z) action.
#INPUT: the degree d of the Origamis, The Stratum of the Origamis as List of integers.
#OUTPUT: A compledte List of Origamis, each contained in exactly one orbit.

CalcOrbit := function(d, Stratum)
	local S1, S2, sigma_1, sigma_2, OrbitList, H, O, i, j, Rep, rep, actedO, current, currentO, DeleteIndex;
	# First Step: We generate a List of all Origamis as transitive pair in S_d. Here we ignore eqivalent Origamis.
	OrbitList:=[];
	S1 := SymetricGroup(d);
	S2 := SymetricGroup(d);
	for sigma_1 in S1 do
		for sigma_2 in S2 do
			O:= rec(d:=d, x:=sigma_1, y:=sigma_2);
			H:=Group(sigma_1, sigma_2);
			if (CalcStratum(O) = Stratum) and (IsTransitive(H,[1..d])) then
				Add(OrbitList, O);
			fi;
		od;
	od;
	Print(OrbitList);
	# Second Step Now we start with the first Element of OrbitList and delete eauch Origami, which is equivalent or on the same Orbit
	i := 2;
	for O in OrbitList do
		Rep:=CalcVeechGroup(O);
		for rep in Rep do
			actedO:= ActionOfSl(rep, O);
			DeleteIndex:=[];
			for current in [i..Length(OrbitList)] do
				currentO:= OrbitList[current];
				if IsEquivalentViaCentralizer(actedO, currentO) then
					Add(DeleteIndex, Position(OrbitList, currentO)); # we wil delete currentO from the List
				fi;
			od;
			j:=0;
			for current in DeleteIndex do
				Remove(OrbitList, current - j);
				j:= j + 1;
			od;
		od;
		i:=i + 1;
	od;
	return OrbitList;
end;
