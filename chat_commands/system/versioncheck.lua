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
                log("(This will not overwrite your settings.lua file)")
                log("(This will not remove your command packs)")
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
                local ok = false
                local _l = false
                PerformHttpRequest("https://raw.githubusercontent.com"..updatePath.."/master/chat_commands/" .. fileName, function(err, responseText, headers)
                    if err ~= 200 then
                        log("Failed to download file " .. fileName .. ": " .. err)
                    else
                        if LoadResourceFile(GetCurrentResourceName(), fileName) ~= responseText then
                            log("Downloading file " .. fileName)
                            SaveResourceFile(GetCurrentResourceName(), fileName, responseText, -1)

                            if not LoadResourceFile(GetCurrentResourceName(), fileName) then
                                log("Failed to save file " .. fileName.. ". Does the directory exist?")
                            else
                                ok = true
                            end
                        end
                    end
                    _l = true
                end)
                while not _l do Wait(0) end
                return ok
            end
            local files = 0
            for fileName in string.gmatch(responseText, "%S+") do
                if updateFile(fileName) then
                    files = files + 1
                end
            end
            if files > 0 then
                log("###############################")
                log("Updated " .. files .. " files")
            else
                log("No changes were made")
            end
            log("###############################")
            if SETTINGS.use_esx then
                -- ESX command def is so wonky it will duplicate commands if we reload lol
                log("Please restart the server")
            else
                log("Please /refresh then /restart " .. GetCurrentResourceName())
            end
            log("###############################")
        end, "GET")
    else
        log("Did you mean to do /" .. GetCurrentResourceName() .. " autoupdate?")
    end
end, true)
