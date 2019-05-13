local FloatingText = {}
local FloatingTextDuration = 5000
local FloatingTextSize = 1.0
local FloatingTextColor = {255, 255, 255, 255}
local FloatingTextFont = 4

RegisterNetEvent("chat_commands:showFloatingText")
AddEventHandler("chat_commands:showFloatingText", function(target, text)
    table.insert(FloatingText, {target = GetPlayerFromServerId(target), text = text, life = GetGameTimer() + FloatingTextDuration})
end)

local function DrawText3D(text, x, y, z)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)
    local s = FloatingTextSize
    local scale = ((1 / dist) * 2) * s
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetDrawOrigin(x, y, z, 0)
        SetTextScale(0.0 * scale, 1.1 * scale)
        SetTextFont(FloatingTextFont)
        SetTextProportional(1)
        SetTextColour(FloatingTextColor[1], FloatingTextColor[2], FloatingTextColor[3], FloatingTextColor[4])
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(0.0, 0.0)
        ClearDrawOrigin()
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        for n, text in next, FloatingText do
            if NetworkIsPlayerActive(text.target) then
                local ply = GetPlayerPed(text.target)
                local pos = GetEntityCoords(ply)
                DrawText3D(text.text, pos.x, pos.y, pos.z + 2.0)
            end
            if text.life < GetGameTimer() then table.remove(FloatingText, n) end
        end
    end
end)