local function commandHandler(command, source, args, raw)
    if not source or source == 0 then
        log("This command can not be executed by the console")
        return false
    end
    -- Responds with a message, can contain title
    local function reply(text, title)
        local messageArgs = {text}
        if title then messageArgs = {title, text} end
        TriggerClientEvent("chat:addMessage", source, {
            color = command.color or {255, 255, 255},
            multiline = true,
            args = messageArgs
        })
    end
    local function deny()
        if command.noperm then
            reply(command.noperm)
        end
    end
    if command.prereq then
        if not command.prereq(source, command, args, raw) then
            deny()
            return false
        end
    end
    if command.admin then
        if SETTINGS.use_vrp then
            -- Check if user is a vRP admin
            if vRP then
                local function isVRPAdmin()
                    local user_id = vRP.getUserId({source})
                    if vRP.hasPermission({user_id, "admin.announce"}) then return true end
                    return false
                end
                if not isVRPAdmin() then
                    deny()
                    return false
                end
            else
                reply("Server is configured to use vRP, but vRP is not initialized.")
                return false
            end
        elseif SETTINGS.use_esx then
            -- ESX admin is already handled by the command def
        else
            -- Nothing needs to be done, ACE should already handle this case
        end
    end
    if command.reply then
        if command.title then
            reply(command.reply, command.title)
        else
            reply(command.reply)
        end
        return true
    end
    if #args > 0 or command.noargs then
        local visualName = GetPlayerName(source)
        local visualUsername = GetPlayerName(source)
        local visualId = source
        if SETTINGS.use_framework_name then
            if SETTINGS.use_vrp then
                local user_id = vRP.getUserId({source})
                local loaded = false
                vRP.getUserIdentity({user_id, function(identity)
                    visualName = ("%s %s"):format(identity.firstname, identity.name)
                    visualId = user_id
                    loaded = true
                end})
                while not loaded do Wait(0) end
            elseif SETTINGS.use_esx then
                local function getESXPlayername()
                    local identifier = GetPlayerIdentifiers(source)[1]
                    local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
                    if result[1] ~= nil then
                        local identity = result[1]
                        return true, identity['firstname'], identity['lastname']
                    end
                    return false, "", ""
                end
                local ok, firstName, lastName = getESXPlayername()
                if ok then
                    visualName = ("%s %s"):format(firstName, lastName)
                end
            end
        end
        local message = command.format
        message = message:gsub("#username#", SETTINGS.show_id and ("%s (%s)"):format(visualUsername, visualId) or visualUsername)
        message = message:gsub("#char#", visualName)
        message = message:gsub("#name#", SETTINGS.show_id and ("%s (%s)"):format(visualName, visualId) or visualName)
        message = message:gsub("#id#", visualId)
        message = message:gsub("#message#", table.concat(args, " "))

        if not command.hidden then
            local messageArgs = {message}
            if command.title then
                local title = command.title
                title = title:gsub("#username#", SETTINGS.show_id and ("%s (%s)"):format(visualUsername, visualId) or visualUsername)
                title = title:gsub("#char#", visualName)
                title = title:gsub("#name#", SETTINGS.show_id and ("%s (%s)"):format(visualName, visualId) or visualName)
                title = title:gsub("#id#", visualId)
                title = title:gsub("#message#", table.concat(args, " "))
                messageArgs = {title, message}
            end

            if command.range and command.range ~= -1 then
                -- Local range, send as proximity
                TriggerClientEvent("chat_commands:proximity", -1, source, command.range, {
                    color = command.color or {255, 255, 255},
                    multiline = true,
                    args = messageArgs
                })
            else
                -- Global range
                TriggerClientEvent("chat:addMessage", -1, {
                    color = command.color or {255, 255, 255},
                    multiline = true,
                    args = messageArgs
                })
            end
        end

        if command.cb then
            command.cb(source, message, command, args, raw)
        end
        if SETTINGS.cb then
            SETTINGS.cb(source, message, command, args, raw)
        end
    else
        if command.usage then
            reply(command.usage, "^3Usage")
        end
    end
end

for _, command in next, COMMANDS do
    log(("Registering command /%s from pack %s by %s"):format(command.command, command.pack, command.author))
    local aceLocked = false
    if command.admin then
        if SETTINGS.use_vrp then
            -- Do not ACE lock the command, we use vRP admin checking
        elseif SETTINGS.use_esx then
            -- Do not ACE lock the command, we use ESX admin checking
        else
            aceLocked = true
        end
    end
    if SETTINGS.use_esx and command.admin then
        -- Register command as an essentialmode admin command
        TriggerEvent('es:addGroupCommand', command.command, 'admin', function(source, args, user)
            commandHandler(command, source, args, raw)
        end, function(source, args, user)
            TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', (command.noperm and command.noperm or 'Insufficient Permissions.') } })
        end)
    else
        RegisterCommand(command.command, function(source, args, raw)
            commandHandler(command, source, args, raw)
        end, aceLocked)
    end
    if command.help then
        TriggerClientEvent("chat:addSuggestion", -1, "/" .. command.command, command.help, command.args)
    end
end

if not SETTINGS.fxcheck then
    log("|=====================")
    log("| WARNING!")
    log("|=====================")
    log("| Unsupported FXServer version!")
    log("| Required: FXServer 1226 or newer")
    log("| Current: " .. GetConvar("version", ""))
    log("|=====================")
end
