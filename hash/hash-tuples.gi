hashForPermutations := function(p)
    local l;
    l:=LARGEST_MOVED_POINT_PERM(p);
    if IsPerm4Rep(p) then
        # is it a proper 4byte perm?
        if l>65536 then
            return HashKeyBag(p,255,0,4*l);
        else
            # the permutation does not require 4 bytes. Trim in two
            # byte representation (we need to do this to get consistent
            # hash keys, regardless of representation.)
            TRIM_PERM(p,l);
        fi;
    fi;
    # now we have a Perm2Rep:
    return HashKeyBag(p,255,0,2*l);
end;

hashFor2TupleOfPermutations := function( origami )
    return hashForPermutations( origami.x ) + hashForPermutations( origami.y );
end;

hashFor2TupleOfPermutations2ArgWrapper := function( origami, data )
    return hashFor2TupleOfPermutations(origami);
end;

hashFor2TupleOfPermutations2ArgModulus := function( origami, hashTableLength )
    return hashFor2TupleOfPermutations(origami) mod hashTableLength + 1;
end;
