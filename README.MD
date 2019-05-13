# FiveM Chat Command System
#### A custom system made to allow easy installation of chat command packs that allows advanced customized behavior, and allows quick and easy modification for server owners.

This system is designed to be one universal method of creating and using simple interaction commands, and to replace old and copy-pasted methods released in the past.

It provides server owners with a simple way of installing and configuring their commands.

## Features
* Framework compatiblity (vRP & ESX)
* Automatic name formatting based on server frameworks
* Easy configuration
* Simple drag-and-drop installation
* Universal bridge between chat commands and frameworks
* Potentially powerful API, yet also simple to use.

## Resource Installation
* Download the repository
* Put the chat_commands folder in your resources directory
* Add `start chat_commands` to your server config
* Configure `settings.lua` to your liking
    * If you are using ESX or vRP, set the `use_esx` or `use_vrp` field to true!

## Command Pack Installation
* Download the command pack, they usually come as `.lua` files
* Drag and drop the pack file into the `chat_commands/commands` folder
* You should now see that the pack is loaded when the server is started

## Updating
* By enabling `check_updates` in `settings.lua`, the resource will automatically check for updates
* If an update is found, you will be given the option to update.
* To update, use `chat_commands autoupdate` in the console.
* Your resource files will be automatically updated to their newest version.
* This will not overwrite your `settings.lua` file or your command packs.

## Note
#### Warning! This resource depends on a feature only available since FXServer version `1226`!
There are a few example command packs in this repository download, more may be available on the FiveM Forums.

There should be enough comments etc. to get started on creating your own commands, even if you're not an experienced programmer.

All commands can only be ran by players, and will be blocked in the console.

## Settings
There are a couple settings you can configure for your server.
These can be found in the `settings.lua` file.

| Setting | Required | Type     | Description                                                                         |
|---------|----------|----------|-------------------------------------------------------------------------------------|
| show_id | No       | boolean  | makes the players name also include the players ID                                  |
| logging | No       | boolean  | enables print output to the console (and chat during commands)                      |
| use_esx | No       | boolean  | compatibility with ESX                                                              |
| use_vrp | No       | boolean  | compatibility with vRP (f.ex Dunko's vRP) (does not support vRP 2!)                 |
| cb      | No       | function | Global callback function, can be used to log every command, or do other fancy stuff |
| use_framework_name | No       | boolean | automatically format names using framework systems, such as character identity |
| check_updates | No       | boolean | check for updates on startup (recommended) |

## Credits
Version check system by [BlueTheFurry](https://github.com/Bluethefurry)

[GitHub Download](https://github.com/Bluethefurry/FiveM-Resource-Version-Check-Thing)

## Creating a command pack
Creating a command pack can be very easy, as there is very little that is required to make a command

To create a new command pack, create a new file with a `.lua` extension.
In this file, add the following code:
```lua
CommandPack("PACK_NAME", "AUTHOR_NAME", {
    -- Add commands here
}, {
    -- Default values
}
```
And replace the `PACK_NAME` and `AUTHOR_NAME` fields.

Commands are defined as a table containing command parameters.

You can also add the parameters to the default values table, these parameters will be given to all commands (in the pack) that are not already using said parameter.

The following parameters are available per command.

| Parameter | Required | Type     | Description                                                                                   |
|-----------|----------|----------|-----------------------------------------------------------------------------------------------|
| command   | Yes      | string   | the name of the command as used in chat, without the /                                        |
| format    | Yes (unless using `reply`) | string   | how the message appears (with custom formatting)                                              |
| title     |          | string   | same as format, but appears as the message sender                                             |
| color     |          | table    | table with RGB, used with title (default is {255, 255, 255})                                  |
| help      |          | string   | help text for the command, shown under the chat input                                         |
| usage     |          | string   | shown when no text is sent with the command                                                   |
| range     |          | number   | maximum distance for receiving players (-1 or not specified means global range)               |
| hidden    |          | boolean  | if true, the message is not shown in chat                                                     |
| cb        |          | function | callback function with (source, message, command, args, raw) parameters                       |
| prereq    |          | function | function with (source, command, args, raw), returns wether the command can be executed or not |
| noperm    |          | string   | message that is shown if the prereq fails                                                     |
| admin     |          | boolean  | if true, only administrators can use this command, compatible with ESX and vRP, uses ACE by default |
| reply     |          | string   | forced reply to command, no other parts of the command is executed (for simple info commands) |

### Format Parameter
The `format` parameter allows for specific formatting, where key elements are replaced based on server settings.

The following keywords are available:

| Keyword | Description |
|---|---|
| `#name#` | Replaced with the players name, if IDs are enabled, then the ID is appended aswell. If framework names are enabled, this is the framework specific name. |
| `#char#` | Same as `#name#`, but ignores the ID setting. |
| `#id#` | Replaced with the players server ID. Normally the players source ID, but if vRP is enabled then this is the players vRP ID. |
| `#time#` | Replaced with the current timestamp of the server. |
| `#username#` | Same as `#name#`, but does not use framework name. In cases where only the username should be shown. |

## Example command pack
This example pack will add some simple roleplay chat commands, these are just examples. Do not use these for your server.
```lua
CommandPack("Example Pack", "glitchdetector", {
    -- Simple OOC command, using the only two required parameters
    {
        command = "ooc",
        format = "^9[[[ OOC #name# #message# ]]]",
    },
    -- A /me command with range and help information
    {
        command = "me",
        format = "^6* #name# #message#",
        help = "Personal action",
        usage = "/me [action]",
        args = {{name = "action", help = "The action you're performing"}},
        range = 50.0,
    },
    -- Admin only announcement command (can only be used by ACE administrators), the administrator name is not shown
    {
        command = "adminge"
        format = "#message#",
        title = "ADMINISTRATOR ANNOUNCEMENT",
        color = {255, 0, 0},
        admin = true,
    },
    -- Example command that relays the message to something else, like discord (actual discord code not included)
    {
         command = "report",
         format = "**#name# reports an issue:** #message#",
         help = "Report an issue",
         hidden = true, -- Prevents the message from being shown in chat
         cb = function(source, message)
             TriggerEvent("SendMessageToDiscord", message)
         end,
     },
}, {
    -- Default values, if one is not specified for the command
    -- We don't need to specify any default values here for this example
})
```

## Disclaimer
Please refrain from remixing this resource.

It is intended to be a universal solution, if there are missing features, please submit a PR on GitHub with improvements.

You may include this as part of pack downloads, as long as it is not modified.

## License
[Attribution-NoDerivs 3.0 Unported (CC BY-ND 3.0)](https://creativecommons.org/licenses/by-nd/3.0/)
