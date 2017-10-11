MyProfile:= function(Origami)
    local profile;
    ProfileLineByLine("profile.gz");
    CalcVeechGroup(Origami);
    UnprofileLineByLine();
    profile:=ReadLineByLineProfile("profile.gz");
    Exec("rm -r profile");
    OutputAnnotatedCodeCoverageFiles(profile,"profile");
end;
