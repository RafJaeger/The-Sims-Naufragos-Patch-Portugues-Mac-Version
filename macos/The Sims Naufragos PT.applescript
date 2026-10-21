property languageName : "Portuguese"
property bundleIdentifier : "org.patchportuguese.naufragos"

on run
    set gamePath to my savedGamePath()
    if gamePath is not missing value and my isGameBundle(gamePath) then
        my launchGame(gamePath)
        return
    end if

    set gamePath to my commonGamePath()
    if gamePath is missing value then
        try
            set selectedApplication to choose application with prompt "Selecione o aplicativo The Sims Castaway Stories.app"
            set gamePath to POSIX path of (selectedApplication as alias)
        on error number -128
            return
        end try
    end if

    if my isGameBundle(gamePath) is false then
        display dialog "Selecione o aplicativo The Sims Castaway Stories.app." buttons {"OK"} default button "OK" with title "The Sims Naufragos PT"
        return
    end if

    my saveGamePath(gamePath)
    my launchGame(gamePath)
end run

on commonGamePath()
    set launcherPath to POSIX path of (path to me)
    set launcherDirectory to do shell script "/usr/bin/dirname " & quoted form of launcherPath
    set homePath to POSIX path of (path to home folder)
    set candidates to {launcherDirectory & "/The Sims Castaway Stories.app", launcherDirectory & "/The Sims Castaway Stories.localized/The Sims Castaway Stories.app", "/Applications/The Sims Castaway Stories.localized/The Sims Castaway Stories.app", "/Applications/The Sims Castaway Stories.app", homePath & "Applications/The Sims Castaway Stories.localized/The Sims Castaway Stories.app", homePath & "Applications/The Sims Castaway Stories.app"}
    repeat with candidate in candidates
        set candidatePath to contents of candidate
        if my isGameBundle(candidatePath) then return candidatePath
    end repeat
    return missing value
end commonGamePath

on isGameBundle(gamePath)
    if gamePath is missing value then return false
    if gamePath does not end with "/The Sims Castaway Stories.app" then return false
    try
        set infoPath to gamePath & "/Contents/Info.plist"
        set executableName to do shell script "/usr/libexec/PlistBuddy -c " & quoted form of "Print :CFBundleExecutable" & " " & quoted form of infoPath
        return executableName is "The Sims Castaway Stories"
    on error
        return false
    end try
end isGameBundle

on savedGamePath()
    try
        set storedPath to do shell script "/usr/bin/defaults read " & bundleIdentifier & " GamePath"
        if storedPath is not "" then return storedPath
    end try
    return missing value
end savedGamePath

on saveGamePath(gamePath)
    try
        do shell script "/usr/bin/defaults write " & bundleIdentifier & " GamePath -string " & quoted form of gamePath
    end try
end saveGamePath

on launchGame(gamePath)
    try
        do shell script "/usr/bin/open " & quoted form of gamePath & " --args " & quoted form of ("-l:" & languageName)
    on error errorMessage
        display dialog "Não foi possível iniciar o The Sims Castaway Stories:" & return & return & errorMessage buttons {"OK"} default button "OK" with title "The Sims Naufragos PT"
    end try
end launchGame
