#This program can determine The veech group of an Origami.

#A Record defines an Origami O=(sigma_x, sigma_y). The Origami is Stored as pair (sigma_x, sigma_y) in S_d, which tells us how left and right Edges are clued (sigma_x), coversely how upper and lower edges are clued (sigma_y)
#O.x = sigma_x
#O.y = sigma_y
#O.d = degree of the Origami = d




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


######################################################################################
              #Der Rest funktioniert noch nicht
###########################################

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



ToMatrix:=function(list)
	local res, current;
	res:=[];
	for current in list do
		Add(res, ImageElm(hom_to_Sl, current));
	od;
	return res;
end;

ToMatrix2 := list -> List(list, x -> ImageElm(hom_to_Sl, x));
