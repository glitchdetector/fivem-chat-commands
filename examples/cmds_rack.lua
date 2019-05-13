-- Implementation of:
-- https://forum.fivem.net/t/release-unrack-and-rack-simple-reply-script/108735
-- Simple /rack /unrack reply script
CommandPack("Rifle Racking / Unracking", "glitchdetector", {
    -- Add commands here
    -- Unrack your rifle
    {
        command = "unrack",
        format = "^*^6* #name# unracks rifle from their car!",
        help = "Unrack rifle from your car",
        cb = function(source, _, _, args)
            local message = "* unracks rifle from their car *"
            TriggerClientEvent("chat_commands:showFloatingText", -1, source, message)
        end,
    },
    -- Rack your rifle
    {
        command = "rack",
        format = "^*^6* #name# racks rifle back into their car!",
        help = "Unrack rifle from your car",
        cb = function(source, _, _, args)
            local message = "* racks rifle back into their car *"
            TriggerClientEvent("chat_commands:showFloatingText", -1, source, message)
        end,
    },
}, {
    -- Default values
    noargs = true, -- Doesn't take any arguments
    range = 50.0,
}, {
    -- Aliases
    {"grab", "unrack"},
    {"away", "rack"},
})
