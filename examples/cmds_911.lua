-- Simple 911 script, sends message to online dispatch, if not using a framework it just sends it to everyone
CommandPack("Information Commands", "glitchdetector", {
    -- Add commands here
    -- /911 command with dispatch code
    {
        command = "911",
        format = "^2^*Call by #name#: ^r^7#message#",
        help = "Calls 911 dispatch",
        usage = "/911 [message]",
        args = {{name = "message", help = "Message to send"}},
        cb = function(source, message, command, _)
            if SETTINGS.use_vrp then
                local users = vRP.getUsersByPermission({"police.pc"})
                local alerted = 0
                for _, user in next, users do
                    alerted = alerted + 1
                    TriggerClientEvent("chat:addMessage", user, {args = {command.title, message}, color = command.color})
                end
                TriggerClientEvent("chat:addMessage", source, {args = {command.title, (alerted > 0 and "Your message has been sent" or "No available dispatch")}, color = command.color})
            elseif SETTINGS.use_esx then
	            local xPlayers = ESX.GetPlayers()
                local alerted = 0
                for i=1, #xPlayers, 1 do
             		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
             		if xPlayer.job.name == 'police' or xPlayer.job.name == 'ambulance' then
                        alerted = alerted + 1
            			TriggerClientEvent("chat:addMessage", xPlayers[i], {args = {command.title, message}, color = command.color})
                    end
                end
                TriggerClientEvent("chat:addMessage", source, {args = {command.title, (alerted > 0 and "Your message has been sent" or "No available dispatch")}, color = command.color})
            else
                TriggerClientEvent("chat:addMessage", -1, {args = {command.title, message}, color = command.color})
            end
        end,
    },
}, {
    -- Default values, in this case the info text and color in chat
    hidden = true,
    title = "[911 Dispatch]",
    color = {200, 0, 0},
}, {
    -- Aliases
    {"dispatch", "911"},
    {"999", "911"},
    {"112", "911"},
})
