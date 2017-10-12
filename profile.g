MyProfileOrigami:= function(Origami)
    local profile;
    ProfileLineByLine("profile.gz");
    CalcVeechGroup(Origami);
    UnprofileLineByLine();
    profile:=ReadLineByLineProfile("profile.gz");
    Exec("rm -r profile");
    OutputAnnotatedCodeCoverageFiles(profile,"profile");
end;


MyProfile:= function(f, args, profileDirectoryName)
    local profile, profileFileName;
    profileFileName := Concatenation(profileDirectoryName, ".gz");
    ProfileLineByLine(profileFileName);
    CallFuncList(f,args);
    UnprofileLineByLine();
    profile:=ReadLineByLineProfile(profileFileName);
    Exec(Concatenation("rm -r ", profileDirectoryName));
    OutputAnnotatedCodeCoverageFiles(profile, profileDirectoryName);
end;
