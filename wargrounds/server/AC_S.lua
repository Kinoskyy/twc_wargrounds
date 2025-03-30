function getAdmins()
    local admins = {}
    for _, player in ipairs(getElementsByType('player')) do
        if hasObjectPermissionTo(player, "function.kickPlayer", false) then
            table.insert(admins, player)
        end
    end
    return admins
end

local function removeColorCodes(name)
    if type(name) ~= "string" then return name end
    return name:gsub("#%x%x%x%x%x%x", "")
end

addEvent("suspectSpeed", true)
addEventHandler("suspectSpeed", root, function(speed)
    if not client or not isElement(client) then return end
    local formattedSpeed = string.format("%.2f", speed)
    local playerName = removeColorCodes(getPlayerName(client))
    for k, v in pairs(getAdmins()) do
        outputChatBox(playerName .. " suspect sprint macro " .. formattedSpeed .. " KM/H", v, 255, 0, 0)
    end
end)
