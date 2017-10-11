ExampleOrigami := function (d)
  local x, y ;
  repeat
    x:=PseudoRandom(SymmetricGroup(d));
    y:=PseudoRandom(SymmetricGroup(d));
  until IsTransitive(Group(x,y));
  return rec(d:=d, x:=x, y:=y);
end;



#Example
O1:=rec(d:=5, x:=(1,2)(3,4,5), y:=(1,3)(2,4,5));
O2:=rec(d:=5, x:=(1,2,3,4,5), y:=(1,2)(3,4));
O3:=rec(d:=5, x:=(3,5)(1,2,4), y:=(1,2)(3,4,5));
O8:=rec(d:=8, x:=(1,2,3,4)(5,6)(7,8), y:=(1,2,3)(4,5,6,7,8));
O10Small:=rec(d:=10, x:=(1,2)(3,4)(5,6)(7,8)(9,10), y:=(1,2,3,4)(5,6,7,8,9,10));
O10:= rec(d:=10, x:=(1,2,3,4,5)(6,7,8,9,10), y:=(1,2,5,8)(3,4,7,9,10,6) );
