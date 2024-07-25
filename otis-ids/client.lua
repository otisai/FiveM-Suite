-- client.lua
-- Local Variables
local displayIds = false
local displayStartTime = 0

-- Register the '/ids' command. Can change here if '/ids' is already taken.
RegisterCommand('ids', function()
    displayIds = true
    displayStartTime = GetGameTimer()
end, false)

-- Add a suggestion when matching text is typed into chat.
TriggerEvent('chat:addSuggestion', '/ids', 'Display player IDs and names above heads.')

-- Execute this when /ids is used
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if displayIds then
            local currentTime = GetGameTimer()
            if currentTime - displayStartTime > Config.DisplayDuration then
                displayIds = false
            else
                for _, player in ipairs(GetActivePlayers()) do
                    local playerPed = GetPlayerPed(player) -- Get the player
                    local playerCoords = GetEntityCoords(playerPed) -- Get the player's coordinates for DrawText3D
                    local playerId = GetPlayerServerId(player) -- Get the player's server ID
                    local playerName = GetPlayerName(player) -- Get the player's name

                    DrawText3D(playerCoords.x, playerCoords.y, playerCoords.z + 1.05, ('[%s] %s'):format(playerId, playerName))
                end
            end
        end
    end
end)

-- @HELPER - Displays text in a 3D space.
-- @param x - The X coordinate
-- @param y - The Y coordinate.
-- @param z - The Z coordinate.
-- @param text - The string to be displayed.
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    
    SetTextScale(Config.TextScale, Config.TextScale) -- Config
    SetTextFont(Config.TextFont) -- Config
    SetTextProportional(1) -- Nullstub
    SetTextColour(Config.TextColor.r, Config.TextColor.g, Config.TextColor.b, Config.TextColor.a) -- Config
    SetTextEntry("STRING") -- Displaying a string
    SetTextCentre(1) -- Center text
    SetTextOutline() -- Add an outline
    AddTextComponentString(text) -- Set text as string
    DrawText(_x, _y) -- Draw text
end
