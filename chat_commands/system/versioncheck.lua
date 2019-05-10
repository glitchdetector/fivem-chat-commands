if SETTINGS.check_updates then
    log("Checking for updates...")
    Citizen.CreateThread( function()
        local updatePath = "/glitchdetector/fivem-chat-commands" -- your git user/repo path
        local resourceName = "FiveM Chat Command System ("..GetCurrentResourceName()..")" -- the resource name
        function checkVersion(err, responseText, headers)
            local curVersion = LoadResourceFile(GetCurrentResourceName(), "version") -- make sure the "version" file actually exists in your resource root!
            if not responseText then
                log("Update check failed, where did the remote repository go?")
            elseif curVersion ~= responseText and tonumber(curVersion) < tonumber(responseText) then
                log("###############################")
                log(""..resourceName.." is outdated.")
                log("Available version: " .. responseText)
                log("Current Version: " .. curVersion)
                log("Please update it from https://github.com"..updatePath.."")
                log("###############################")
            elseif tonumber(curVersion) > tonumber(responseText) then
                log("You somehow skipped a few versions of "..resourceName.." or the git went offline, if it's still online i advise you to update ( or downgrade? )")
            else
                log(""..resourceName.." is up to date, have fun!")
            end
        end
        PerformHttpRequest("https://raw.githubusercontent.com"..updatePath.."/master/chat_commands/version", checkVersion, "GET")
    end)
end
