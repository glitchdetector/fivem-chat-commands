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
                log("Or do /" .. GetCurrentResourceName() .. " autoupdate")
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

RegisterCommand(GetCurrentResourceName(), function(_, args)
    if args[1] == "autoupdate" then
        log("###############################")
        log("Updating resource")
        log("###############################")
        local updatePath = "/glitchdetector/fivem-chat-commands" -- your git user/repo path
        PerformHttpRequest("https://raw.githubusercontent.com"..updatePath.."/master/autoupdate", function(err, responseText, headers)
            local function updateFile(fileName)
                local _l = false
                PerformHttpRequest("https://raw.githubusercontent.com"..updatePath.."/master/chat_commands/" .. fileName, function(err, responseText, headers)
                    if err ~= 200 then
                        log("Failed to update file " .. fileName .. ": " .. err)
                    else
                        log("Downloading file " .. fileName)
                        SaveResourceFile(GetCurrentResourceName(), fileName, responseText, -1)
                    end
                    _l = true
                end)
                while not _l do Wait(0) end
            end
            for fileName in string.gmatch(responseText, "%S+") do
                updateFile(fileName)
            end
            log("###############################")
            log("Please restart the resource")
            log("###############################")
        end, "GET")
    else
        log("Did you mean to do /" .. GetCurrentResourceName() .. " autoupdate?")
    end
end, true)
