resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

name 'Chat Command System'
author 'glitchdetector'
contact 'glitchdetector@gmail.com'
version '1.0.0'

description 'A configurable and extendable chat command system, designed for easy drag-and-drop usage.'
usage [[
    By default, an example command pack is installed. You most likely want to delete this pack.
    Command packs like these can simply be dragged and dropped into the "commands" folder.

    Certain settings can be configured in the settings.lua file
]]

-- vRP compatibility
server_script '@vrp/lib/utils.lua'

-- ESX compatibility
server_script '@mysql-async/lib/MySQL.lua'

client_script 'system/cl_proximity.lua'

shared_script 'settings.lua'

client_script 'modules/cl_*.lua'
server_script 'modules/sv_*.lua'
shared_script 'modules/sh_*.lua'

server_script 'system/sv_pre.lua'
server_script "commands/*.lua"

server_script 'system/sv_fxcheck_*.lua'
server_script 'system/sv_chat_commands.lua'

server_script 'system/versioncheck.lua'
