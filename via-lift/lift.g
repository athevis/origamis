A:=[[-3,5],[-2,3]]; # A is the matrix, you want to lift

# Generators of Sl
S:= [[0, -1],[1, 0]];
T:= [[1,1],[0,1]];


#Definition of the free group F_2 = <x,y>
F:=FreeGroup("x", "y");
gens:= GeneratorsOfGroup(F);
x:=gens[1];
y:=gens[2];

#Definition of some group homomorphisms

LambdaS:= GroupHomomorphismByImages( F, F, [x, y], [y, x^(-1)] );
LambdaT:= GroupHomomorphismByImages( F, F, [x, y], [x, x*y] );
LambdaI:= GroupHomomorphismByImages( F, F, [x, y], [x^(-1), y^(-1)] );

# Appends from left k times -T and one time S to some sigma
AppendNegativ:= function(sigma, k) 
 local n;
 for n in [1..k] do
  sigma :=CompositionMapping( LambdaS, LambdaT , LambdaS, LambdaT, LambdaS, sigma);
  od;
return sigma;
end;

#Appends from left k times T and one times S to some sigma
AppendPositiv:= function(sigma, k) 
local n;
for n in [1..k]do
 sigma:= CompositionMapping(LambdaT, sigma);
od;
return sigma;
end;

#Appends from left T^k to some sigma
AppendT:= function(sigma, k)
    if k > 0 then
     sigma:= AppendPositiv(sigma, k);
     elif k < 0 then
       sigma:= AppendNegativ(sigma, -k);
  fi;
    return sigma;
end;

# Calculates the next matrix in the Algorithm
CalcMatrix:=function(C)                      
 local B,k;                                   
 k:=(C[2][2] - (C[2][2] mod C[2][1]))/C[2][1];
 B:=[[0,0],[0,0]];                            
 B[1][1]:= - C[1][1] * k + C[1][2];         # a_(n + 1) = - a_n * k  + b_n
 B[1][2]:= -C[1][1];                        # b_(n + 1) = -a_n
 B[2][1]:=C[2][2] mod C[2][1];              # c_(n + 1) = d_n mod c_n
 B[2][2]:= - C[2][1];                        # d_(n + 1) = c_n
 return(B);
 
end;

#Calculates the the lift of A
CalcLift:=function(A)
  local k, sign, GammaA; # the k_n from the Algorithm, sign tracks the sign of the decomposition, Here the result wil be stored;
  GammaA:= GroupHomomorphismByImages( F, F, [x, y], [x, y] );
  sign:= 1;
  while A[2][1] <> 0 do
    sign:= sign * (-1);
    k:=(A[2][2] - (A[2][2] mod A[2][1]))/A[2][1]; #A_2,2 div A_2,1    
    GammaA:=AppendT(GammaA, k);
    if k < 0 then if k mod 2 = 1 then sign := sign* (-1); fi; fi;  #one "-" for each T^-1
    GammaA:=CompositionMapping(LambdaS, GammaA);
    A:=CalcMatrix(A);
  od;
  if A[1][1] = -1 
    then sign:=sign*(-1); GammaA:= AppendT(GammaA,-A[1][2]); 
    else GammaA:= AppendT(GammaA, A[1][2]); 
  fi;
  if sign = -1 then GammaA:=CompositionMapping(LambdaI, GammaA); fi;
  return GammaA;
end;

GammaA:= CalcLift(A);

Print("x -> ");Print(ImageElm( GammaA, x ));Print("\n");Print("y -> ");Print(ImageElm( GammaA, y ));Print("\n");Print("\n");

