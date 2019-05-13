--[[
    Command parameters:
     - command: the name of the command as used in chat, without the /
     - format: how the message appears
        #name#: is replaced with the players name (and ID depending on settings)
        #message#: is replaced with the message sent by the player
        #time#: is replaced with the current timestamp
     - title (optional): same as format, but appears as the message sender
     - color (optional): table with RGB, used with title (default is {255, 255, 255})
     - help (optional): help text for the command
     - usage (optional): shown when no text is sent with the command
     - range (optional): maximum distance for receiving players (-1 or not specified means global range)

    Advanced parameters:
     - hidden (optional): if true, the message is not shown in chat
     - cb (optional): callback function with (source, message, command, args, raw) parameters
     - prereq (optional): function with (source, command, args, raw), returns wether the command can be executed or not
     - noperm (optional) message that is shown if the prereq fails
     - admin (optional): if true, only ACE administrators can use this

    Extra notes:
     - You do not need to use any of the formatted parameters, such as #name#, #message# etc.
     - If show_id is turned on in settings, the players SOURCE ID will appear with the name automatically
]]

-- This is just an example pack, do not use this for a server.

CommandPack("Example Pack", "glitchdetector", {
    -- Simple OOC command, using the only two required parameters
    {
        command = "ex_ooc",
        format = "^9[[[ OOC #name# #message# ]]]",
    },
    -- A /me command with range and help information
    {
        command = "ex_me",
        format = "^6* #name# #message#",
        help = "Personal action",
        usage = "/me [action]",
        args = {{name = "action", help = "The action you're performing"}},
        range = 50.0,
    },
    -- Admin only announcement command (can only be used by ACE administrators), the administrator name is not shown
    {
        command = "ex_adminge",
        format = "#message#",
        title = "ADMINISTRATOR ANNOUNCEMENT",
        color = {255, 0, 0},
        admin = true,
    },
}, {
    -- Default values, if one is not specified for the command
    -- We don't need to specify any default values here for this example
})
