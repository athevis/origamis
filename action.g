
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



ActionOfF2ViaCanonical := function(o, g)
	return CanonicalOrigami(ActionOfSl(g,o));
end;
