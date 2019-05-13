-- Commands that give the player some information, such as Discord invites etc. (must be configured)
CommandPack("Information Commands", "glitchdetector", {
    -- Add commands here
    -- Simple /discord command that replies with the current discord invite
    {
        command = "discord",
        title = "Discord Link",
        reply = "https://discord.gg/mynewfxserver",
        help = "Get the discord invite link",
    },
    -- Simple /teamspeak command that replies with the teamspeak IP
    {
        command = "teamspeak",
        title = "TeamSpeak IP",
        reply = "e621.teamspeak.leet",
        help = "Get the teamspeak IP",
    },
    -- Simple /forum command that replies with the forum URL
    {
        command = "forum",
        title = "Forum Link",
        reply = "https://www.mynewfxserver.com",
        help = "Check out our forum!",
    },
}, {
    -- Default values, in this case the info text and color in chat
    color = {0, 0, 200},
})
