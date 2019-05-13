function log(text)
    if SETTINGS.logging then
        print("^3[Chat Commands] ^7" .. text .. "^7")
    end
end

function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

ESX = nil
vRP = nil
vRPclient = nil

-- vRP compatibility
if SETTINGS.use_vrp then
    log("Enabling vRP compatibility")
    local Proxy = module("vrp", "lib/Proxy")
    local Tunnel = module("vrp", "lib/Tunnel")
    vRP = Proxy.getInterface("vRP")
    vRPclient = Tunnel.getInterface("vRP","chat_commands")
    log("vRP compatibility enabled")
end

-- ESX compatibility
if SETTINGS.use_esx then
    log("Enabling ESX compatibility")
    while not ESX do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
    log("ESX compatibility enabled")
end

COMMANDS = {}

local function AddCommand(command)
    if not command.command then return "Missing command parameter" end
    if not command.format and not command.reply then return "Missing format parameter" end
    if command.reply and (command.cb or command.hidden or command.usage) then log("Warning! Using reply will stop the command from executing fully!") end
    log(("Added /%s"):format(command.command))
    table.insert(COMMANDS, command)
    return nil
end

local function AddAlias(alias, commandName)
    for _, command in next, COMMANDS do
        if command.command == commandName then
            local aliasCommand = shallowcopy(command)
            aliasCommand.command = alias
            table.insert(COMMANDS, aliasCommand)
            log(("Added alias /%s for /%s"):format(alias, commandName))
            return true
        end
    end
    log(("Could not create alias /%s for /%s: %s"):format(alias, commandName, "Command does not exist"))
    return false
end

function CommandPack(packName, packAuthor, commands, defaults, aliases)
    log(("== Loading command pack %s by %s =="):format(packName, packAuthor))
    for _, command in next, commands do
        command.author = packAuthor
        command.pack = packName
        if defaults then
            for default, value in next, defaults do
                if not command[default] then
                    command[default] = value
                end
            end
        end
        local result = AddCommand(command)
        if result then
            log(("Could not add /%s: %s"):format(command.command, result))
        end
    end
    if aliases then
        for _, alias in next, aliases do
            if alias[1] and alias[2] then
                AddAlias(alias[1], alias[2])
            else
                log("Malformed alias")
            end
        end
    end
    log(("== Pack loaded with %s command%s =="):format(#commands, #commands == 1 and "" or "s"))
end

log("Starting chat command loading process")
