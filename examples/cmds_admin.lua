-- A simple announcement command locked behind administrator access.
CommandPack("Administrator Commands Example", "glitchdetector", {
    -- Add commands here
    -- Administrator Announcement
    {
        command = "announce",
        format = "#message#",
        title = "ADMINISTRATOR ANNOUNCEMENT",
        help = "Administrator Announcement",
        usage = "/announce [announcement]",
        args = {{name = "announcement", help = "The message to announce"}},
        color = {255, 0, 0},
    },
}, {
    -- Default values, if one is not specified for the command
    admin = true,
    noperm = "You do not have permission to use this command.",
})
