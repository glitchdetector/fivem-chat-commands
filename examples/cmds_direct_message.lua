-- A simple DM / SMS system with a reply feature.
-- Save previous messager for reply command
local PreviousMessager = {}
CommandPack("Direct Messaging", "glitchdetector", {
    -- Add commands here
    -- An SMS command
    {
        command = "sms",
        format = "#message#",
        help = "Send an SMS to a player",
        usage = "/sms [player] [message]",
        args = {{name = "player", help = "ID of receiving player"}, {name = "message", help = "The SMS contents"}},
        cb = function(source, message, _, args)
            local receiver = tonumber(args[1])
            if receiver and GetPlayerName(receiver) then
                PreviousMessager[receiver] = source
                message = message:sub(#args[1]+1)
                TriggerClientEvent("chat:addMessage", source, {
                    args = {(("^*^5(SMS to %s (%s)) ^r^7%s"):format(GetPlayerName(receiver), receiver, message))},
                })
                TriggerClientEvent("chat:addMessage", receiver, {
                    args = {(("^*^5(SMS from %s (%s)) ^r^7%s"):format(GetPlayerName(source), source, message))},
                })
            else
                -- Malformed ID
                TriggerClientEvent("chat:addMessage", source, {
                    args = {"This player does not exist"},
                })
            end
        end,
    },
    -- Reply command
    {
        command = "reply",
        format = "#message#",
        help = "Reply to your last SMS",
        usage = "/reply [message]",
        args = {{name = "message", help = "The SMS contents"}},
        cb = function(source, message, _, args)
            local receiver = PreviousMessager[source]
            if receiver and GetPlayerName(receiver) then
                PreviousMessager[receiver] = source
                TriggerClientEvent("chat:addMessage", source, {
                    args = {(("^*^5(SMS to %s (%s)) ^r^7%s"):format(GetPlayerName(receiver), receiver, message))},
                })
                TriggerClientEvent("chat:addMessage", receiver, {
                    args = {(("^*^5(SMS from %s (%s)) ^r^7%s"):format(GetPlayerName(source), source, message))},
                })
            else
                -- No previous conversation
                TriggerClientEvent("chat:addMessage", source, {
                    args = {"This player does not exist"},
                })
            end
        end,
    },
}, {
    -- Default values, if one is not specified for the command
    hidden = true,
}, {
    -- Aliases
    {"m", "sms"},
    {"r", "reply"},
})
