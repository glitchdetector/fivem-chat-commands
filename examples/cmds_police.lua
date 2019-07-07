-- Example pack that utilizes a check for the police job in both vRP and ESX, no ACE permission since there's no "police" oncept in base FXS
CommandPack("Police Requirement Example", "glitchdetector", {
    -- Add commands here
    -- Check if you are a valid police officer
    {
        command = "polcheck",
        reply = "You are a police officer!",
    },
    -- Speak via police megaphone
    {
        command = "polmega",
        usage = "/polmega [message]",
        help = "Speak loudly through your megaphone",
        args = {{name = "message", help = "Message to send"}},
        format = "^4^*#message#",
        range = 25.0,
    }
}, {
    -- Default values
    prereq = function(source)
        if SETTINGS.use_vrp then
            local user_id = vRP.getUserId({source})
            return vRP.hasPermission({user_id, "police.service"}) -- Most Police jobs in Dunko's vRP uses police.service
        elseif SETTINGS.use_esx then
            local xPlayer = ESX.GetPlayerFromId(source)
            return xPlayer.job.name == 'police' -- No clue if there's a way to check multiple jobs without "or"-ing them all
        end
        return false
    end,
    noperm = "You are not a police officer!",
})
