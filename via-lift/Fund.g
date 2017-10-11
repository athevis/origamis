


FundGroup:= function(d, sigma_x, sigma_y)  
  local IniList_x, IniList_y, HelpFund, k, rep;
  IniList_x:=[];
  IniList_y:=[];
  rep:=[];
  for k in [1..d] do
    Add(IniList_x, false);
    Add(IniList_y, false);
  od;
#######################################
#Definition of an inner function
HelpFund:= function(n, List_x, List_y, word)
    local NewList_x, NewList_y;
    if n = 1 then Add(rep, word);
    else
      if List_x[n] = false then
        NewList_x:= ShallowCopy(List_x);
        NewList_x[n]:=true;
        HelpFund(n^sigma_x, NewList_x, List_y, word * x);
      fi;
      if List_y[n] = false then
        NewList_y:= ShallowCopy(List_y);
        NewList_y[n]:=true;
        HelpFund(n^sigma_y, List_x, NewList_y, word * y);
      fi;
    fi;
 end;
########################################

  HelpFund(1^sigma_x, IniList_x, IniList_y, x);
  HelpFund(1^sigma_y, IniList_x, IniList_y, y);
  return(rep);
end;



MainStep:=function(d, sigma_x, sigma_y, i, gamma)
	local k, CurrentEdge;
        CurrentEdge:= i;
	for k in LetterRepAssocWord(gamma) do
		if k = 1 then     # then the current position is x
			CurrentEdge:= CurrentEdge^sigma_x;
		elif k = 2 then   # the the current position is y
			CurrentEdge:= CurrentEdge^sigma_y;
		elif k = -1 then
			CurrentEdge:=CurrentEdge^(sigma_x^(-1));
		else
			CurrentEdge:=CurrentEdge^(sigma_y^(-1));
		fi;
	od;
	if CurrentEdge = i then
		return true;
	else
		return false;
	fi;
end;



MatrixInVeechGroup:=function(A, d, sigma_x, sigma_y)
	local Gamma_A, h, tilde_h, i, rep;
	Gamma_A:=CalcLift(A);
	rep := FundGroup(d, sigma_x, sigma_y); return true;
	for h in rep do
		tilde_h:=Image(Gamma_A,h);
		for i in [1 .. d] do
			if MainStep(d, sigma_x, sigma_y, i, tilde_h) = false then
				return false;
			fi;
		od;
	od;
	return true;
end;
