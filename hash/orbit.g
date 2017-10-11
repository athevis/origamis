createOrbit := function(origami)
return Orb(
    F, # `gens`
    CanonicalOrigami(origami), # `point`
    ActionOfF2ViaCanonical, # `op`. OnTuples means that an element of `gens` is applied
    # to both components of the tuple `point` simultaneously. The action
    # in each component is just the conjugation action.
    #
    # `options` record specifying our hash function and everything related
    rec(
        eqfunc := EQ,       # standard equality tester, nothing special
        # hashfunc is the hash function used if the table didn't grow yet
        hashfunc := rec(
            func := hashFor2TupleOfPermutations2ArgModulus,
            data := 10000019  # initial length of hashTable
        ),
        hashlen := 10000019,  # initial length of hashTable. This needs to be repeated here for some reason..
    )
);
end;


# orb := Orb(
#     SymmetricGroup(25), # `gens`
#     [(1,2,3,4),(4,5)(6,7)], # `point`
#     OnTuples, # `op`. OnTuples means that an element of `gens` is applied
#     # to both components of the tuple `point` simultaneously. The action
#     # in each component is just the conjugation action.
#     #
#     # `options` record specifying our hash function and everything related
#     rec(
#         eqfunc := EQ,       # standard equality tester, nothing special
#         # hashfunc is the hash function used if the table didn't grow yet
#         hashfunc := rec(
#             func := hashFor2TupleOfPermutations2ArgModulus,
#             data := 100003  # initial length of hashTable
#         ),
#         hashlen := 100003,  # initial length of hashTable. This needs to be repeated here for some reason..
#         ## If at some point the table can not hold all points anymore, the
#         # hash table is increased in length.
#         #
#         # hfbig is used as a hash function once the table has grown
#         hfbig := hashFor2TupleOfPermutations2ArgWrapper,
#         hfdbig := [] # dummy parameter, hfbig doesn't need any additional info
#     )
# );
