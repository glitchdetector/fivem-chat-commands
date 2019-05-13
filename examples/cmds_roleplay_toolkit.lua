-- An essential roleplay command kit. No configuration required.
CommandPack("Roleplay Toolkit", "glitchdetector", {
    -- Add commands here
    -- Global Out of Character chat
    {
        command = "ooc",
        format = "^*^2[[[ OOC #username# #message# ]]]",
        help = "Global out of character chat",
        usage = "/ooc [message]",
        args = {{name = "message", help = "An out of character message"}},
    },
    -- Global in-character tweet
    {
        command = "tweet",
        format = "^*^5[#char# @#username#] ^r^7#message#",
        help = "Twitter message",
        usage = "/tweet [message]",
        args = {{name = "message", help = "Tweet message"}},
    },
    -- Local Out of Character chat
    {
        command = "looc",
        format = "^*^2[ Local OOC #username# #message# ]",
        help = "Local out of character chat",
        usage = "/looc [message]",
        args = {{name = "message", help = "An out of character message"}},
        range = 50.0,
    },
    -- A /me command with range and help information
    {
        command = "me",
        format = "^*^6* #name# #message#",
        help = "Personal action",
        usage = "/me [action]",
        args = {{name = "action", help = "The action you're performing"}},
        range = 50.0,
        cb = function(source, _, _, args)
            local message = "* " .. table.concat(args, " ") .. " *"
            TriggerClientEvent("chat_commands:showFloatingText", -1, source, message)
        end,
    },
}, {
    -- Default values, if one is not specified for the command
}, {
    -- Aliases
    {"twt", "tweet"},
    {"b", "looc"},
    {"do", "me"},
})
