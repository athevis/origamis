#This program can determine The veech group of an Origami. 

#A Record defines an Origami O=(sigma_x, sigma_y). The Origami is Stored as pair (sigma_x, sigma_y) in S_d, which tells us how left and right Edges are clued (sigma_x), coversely how upper and lower edges are clued (sigma_y)
#O.x = sigma_x
#O.y = sigma_y
#O.d = degree of the Origami = d

#Example
O1:=rec(d:=5, x:=(1,2)(3,4,5), y:=(1,3)(2,4,5));
O2:=rec(d:=5, x:=(1,2,3,4,5), y:=(1,2)(3,4));
O3:=rec(d:=5, x:=(3,5)(1,2,4), y:=(1,2)(3,4,5));
O8:=rec(d:=8, x:=(1,2,3,4)(5,6)(7,8), y:=(1,2,3)(4,5,6,7,8));
O10Small:=rec(d:=10, x:=(1,2)(3,4)(5,6)(7,8)(9,10), y:=(1,2,3,4)(5,6,7,8,9,10));
O10:= rec(d:=10, x:=(1,2,3,4,5)(6,7,8,9,10), y:=(1,2,5,8)(3,4,7,9,10,6) );

#This function let act S on an Origami (sigma_x, sigma_y)
#input An Origami O
#output the Origmi S.O
ActionOfS:=function(Origami)
	local NewOrigami;
	NewOrigami:=rec(d:=Origami.d, x:=Origami.y^(-1), y:= Origami.x);
	return NewOrigami;
end;

#This function let act T on an Origami (sigma_x, sigma_y)
#input An Origami O
#output the Origmi T.O

ActionOfT:=function(Origami)
	local NewOrigami;
	NewOrigami:=rec(d:=Origami.d, x:=Origami.x, y:= Origami.y * (Origami.x^-1));
	return NewOrigami;
end;

#This function let act T⁻¹ on an Origami (sigma_x, sigma_y)
#input An Origami O
#output the Origmi T⁻¹.O
ActionOfInvT:=function(Origami)
	local NewOrigami;
	NewOrigami:=rec(d:=Origami.d, x:=Origami.x, y:= Origami.y * Origami.x);
	return NewOrigami;
end;

#This function let act S⁻¹ on an Origami (sigma_x, sigma_y)
#input An Origami O
#output the Origmi S⁻¹.O
ActionOfInvS:=function(Origami)
	local NewOrigami;
	NewOrigami:=rec(d:=Origami.d, x:=Origami.y, y:= Origami.x^-1);
	return NewOrigami;
end;

#This Function let act A in Sl_2(Z) on an Origami O
#INPUT: A Word word in S and T and an Origami O
#OUTPUT: The Origami word.O
ActionOfSl:=function(word, Origami)
	local letter;
	for letter in LetterRepAssocWord(word) do
		if letter = 1 then 
			Origami := ActionOfS(Origami);
		elif letter = 2 then
			Origami := ActionOfT(Origami);
		elif letter = -1 then
			Origami := ActionOfInvS(Origami);
		else 
			Origami := ActionOfInvT(Origami);
		fi;
	od;
	return Origami;
end;

#This function generates the Symetric Group S_d
#INPUT: d
#OUTPUT: S_d
SymetricGroup:=function(d)
        local perm, i, list;
	list:=[];
        for i in [1..d-1] do
        	list[i]:=i+1;
        od;
        list[d]:=1;
        perm:=PermList(list);
	return Group((1,2), perm);
end;

#This Function determines, wether two given Origamis O and O' are equivalent
#input: two Origamis O and O'
#output: result is true, if O and O' are equivalent, fales else
IsEquivalentNaiv:=function(Origami1, Origami2)
	local G, g;
	if CycleStructurePerm(Origami1.x) <> CycleStructurePerm(Origami2.x) then return false; fi;
	if CycleStructurePerm(Origami1.y) <> CycleStructurePerm(Origami2.y) then return false; fi;

	G:=SymetricGroup(Origami1.d);
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



#Definition of the free group F_2 in S and T = <S,T>
if not IsBound(F) then
	F:=FreeGroup("S", "T");
	gens:= GeneratorsOfGroup(F);
	S:=gens[1];
	T:=gens[2];
fi;


#This function calculates the veech group of an origami
#INPUT: An origami
#OUTPUT: The veechgroup of Origami as word in S and T

CalcVeechGroupViaEquiv := function(Origami)
	local  Gen,Rep, HelpCalc, D, B, A, foundA, foundB, W, NewGlList;
	Gen:= [];
	Rep:= [S*S^-1];
	HelpCalc :=function(GlList) # vielleicht noch Olist
		NewGlList:=[];		
		for W in GlList do 
			foundA:= false;
			foundB:= false;
			A:=W*T;
			B:=W*S;
			for D in Rep do
				if IsEquivalentViaCentralizer( Origami, ActionOfSl(B*D^-1, Origami)) then
					Add(Gen, B*D^-1);
					foundB:= true;
				fi;
			od;
			for D in Rep do
				if IsEquivalentViaCentralizer(Origami, ActionOfSl(A*D^-1, Origami)) then
					Add(Gen, A*D^-1);
					foundA:= true;
				fi;
			od;
			if foundA = false then 
				Add(Rep, A);
				Add(NewGlList, A);
			fi;

			if foundB = false then 
				Add(Rep, B);
				Add(NewGlList, B);
			fi;
		od;
		if Length(NewGlList) > 0 then HelpCalc(NewGlList); fi;
	end;
	HelpCalc([S*S^-1]);
	return rec(rep:=Rep, gen:=Gen);
end;


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
######################################################################################
              #Der Rest funktioniert noch nicht
###########################################
#This is a helpfunction, which determines the cycle structure of a permutatian.
#INPUT: a permutatian, d
#OUTPUT: a List whith the Cycles of the permutatian

CycleList:= function(perm, d)
  local i,res, visited, help, start, target, current, pos;
  visited:=[1..d];
  res:=[];
  for i in [1..d] do
    res[i]:=[];
  od;
  while Length(visited) <> 0 do
    help:=[];
    target:=[];
    start:= visited[1];
    Remove(visited, Position(visited,start));
    help[1]:=start;
    current:=start^perm;
    if current <> start then
	    while current <> start do
	      Add(help, current);
	      Add(target, current);
	      pos:=Position(visited,current);
	      Remove(visited, pos);
	      current:=current^perm;
	    od;
	    Add(target, current);
	    Add(res[Length(help)], help);
    else 
	    help:=[]; help[1]:=start;
	    Add(res[1], help);
    fi;
  od;
  return res;
end;


#This Function determines, wether two given Origamis O and O' are equivalent
#input: two Origamis O and O'
#output: result is true, if O and O' are equivalent, fales else

IsEquivalent:=function(Origami1, Origami2)
  local List1, List2, Help;
#First Step: check, wether the Permutations are conjugated
  if CycleStructurePerm(Origami1.x) <> CycleStructurePerm(Origami2.x) then return false; fi;
  if CycleStructurePerm(Origami1.y) <> CycleStructurePerm(Origami2.y) then return false; fi;
#Second Step: depermine all c, such that Origami2.x = c⁻¹ * Origami1.x * c   
  List1:= CycleList(Origami1.x, Origami1.d);
  List2:= CycleList(Origami2.x, Origami2.d); 
#This Subfunction determines c and tests wether Origami1 and Origami2 are conjugated	
	Help:=function(CycleList1, CycleList2, cOrigin, cFinal)
		local d, PermList1, PermList2, res, sd, g, i, j ,NewCycleList1, NewCycleList2,NewcOrigin, NewcFinal,c;
		res:= false;
		if Length(CycleList1) = 0 then
			c:= MappingPermListList(cOrigin, cFinal);
			#Print(cOrigin); Print("\n"); Print(cFinal); Print("\n");
			#Print("c = "); Print(c); Print("!!!!!\n");
			return Origami2.y = c^-1 * Origami1.y * c;
		else 
			NewCycleList1:=ShallowCopy(CycleList1);
			NewCycleList2:=ShallowCopy(CycleList2);
			PermList1:=Remove(NewCycleList1);
			PermList2:=Remove(NewCycleList2);
			d:= Length(PermList1);
			if d = 0 then
				return Help(NewCycleList1, NewCycleList2, cOrigin, cFinal);
			elif d = 1 then
				Append(cFinal,PermList1[1]);
				Append(cOrigin,PermList2[1]);
				return Help(NewCycleList1, NewCycleList2, cOrigin , cFinal);
			else
				sd:=SymetricGroup(d);
				for g in sd do
					for j in [1..Length(cOrigin) ] do
						#NewcOrigin:=ShallowCopy(cOrigin);
						NewcFinal:=ShallowCopy(cFinal);
						NewcOrigin:=[];
						CopyListEntries(cOrigin,j , 1, NewcOrigin, 1, 1, Length(cOrigin) - j + 1);
						CopyListEntries(cOrigin, 1, 1, NewcOrigin, Length(cOrigin) - j + 1, j - 1);
						for i in [1..d] do
	                       				Append(NewcOrigin,PermList2[i]);
							Append(NewcFinal,PermList1[i^g]);
						od;
                                		if Help(NewCycleList1, NewCycleList2, NewcOrigin, NewcFinal) = true then res:=true; fi;
					od;				
				od;
			
			fi;
		fi;
		return res;	
	end;
#Now we use Help
	return Help(List1, List2, [], []);
end;

#for debuging
ConO:=function(O, c);
  return rec(d:=O.d, x:= c^-1 * O.x *c, y:= c^-1 * O.y *c);
end;

Matrix_T:=[
     [ 1, 1],
     [ 0, 1]
    ];
Matrix_S:=[
     [ 0, -1],
     [1, 0]
    ];

G:=Group(Matrix_S, Matrix_T);

hom_to_Sl:= GroupHomomorphismByImages( F, G, [S, T], [Matrix_S, Matrix_T] );

help:= function(d, O1)
	local Sd, O2, sigma1, sigma2;
	Sd:= SymetricGroup(d);
	for sigma1 in Sd do
		for sigma2 in Sd do
			O2:= rec(d:=d, x:= sigma1, y:= sigma2);
			if IsEquivalentViaCentralizer(O1, O2) <> IsEquivalent(O1, O2) then Print(IsEquivalentViaCentralizer(O1, O2)); Print(" Origami:  "); Print(O2); Print("\n"); fi;
		od;	
	od;
	return;
end;


CalcOrigamiList := function(d)
	local S1, S2, sigma_1, sigma_2, OrbitList, H;
	OrbitList:=[];
	S1 := SymmetricGroup(d);
	S2 := SymmetricGroup(d);
	for sigma_1 in S1 do
		for sigma_2 in S2 do
			H:=Group(sigma_1, sigma_2);
			if IsTransitive(H,[1..d]) then
				Add(OrbitList, rec(d:=d, x:=sigma_1, y:=sigma_2));
			fi;
		od;
	od;
	return OrbitList;
end;

ToMatrix:=function(list)
	local res, current;
	res:=[];
	for current in list do
		Add(res, ImageElm(hom_to_Sl, current));
	od;
	return res;
end;

ToMatrix2 := list -> List(list, x -> ImageElm(hom_to_Sl, x));

