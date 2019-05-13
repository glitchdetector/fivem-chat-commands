-- Dependencies:
-- https://forum.fivem.net/t/release-fivem-to-discord/62618
-- A command that sends a report to your Discord using @flatracer’s FiveM to Discord resource:
CommandPack("Report Pack", "glitchdetector", {
    -- Add commands here
    -- Report command, sends a message to Discord
    {
        command = "report",
        format = "#message#",
        help = "Report an issue to the staff team",
        usage = "/report [issue]",
        args = {{name = "issue", help = "Your issue"}},
        hidden = true, -- Prevents the message from being shown in chat
        cb = function(source, message)
            -- Sends a message to discord using the FiveM to Discord resource
            TriggerEvent('DiscordBot:ToDiscord', 'system', ('%s (%s) reports an issue'):format(GetPlayerName(source), source), message, 'https://wiki.fivem.net/w/images/d/db/FiveM-Wiki.png', true)
        end,
    },
}, {
    -- Default values
})
