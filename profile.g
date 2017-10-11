MyProfileOrigami:= function(Origami)
    local profile;
    ProfileLineByLine("profile.gz");
    CalcVeechGroup(Origami);
    UnprofileLineByLine();
    profile:=ReadLineByLineProfile("profile.gz");
    Exec("rm -r profile");
    OutputAnnotatedCodeCoverageFiles(profile,"profile");
end;


MyProfile:= function(f, args)
    local profile;
    ProfileLineByLine("profile.gz");
    CallFuncList(f,args);
    UnprofileLineByLine();
    profile:=ReadLineByLineProfile("profile.gz");
    Exec("rm -r profile");
    OutputAnnotatedCodeCoverageFiles(profile,"profile");
end;
