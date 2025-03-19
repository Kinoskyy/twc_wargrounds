function getAdmins()
    local admins = {}
    for _, player in ipairs(getElementsByType('player')) do
        if hasObjectPermissionTo(player, "function.kickPlayer", false) then
            table.insert(admins, player)
        end
    end
    return admins
end

addEvent("suspectSpeed", true)
addEventHandler("suspectSpeed", root, function(speed)
    if not client or not isElement(client) then return end
    local formattedSpeed = string.format("%.2f", speed)
    for k, v in pairs(getAdmins()) do
        outputChatBox(getPlayerName(client) .. " Suspect sprint macro " .. formattedSpeed .. " km/h", v, 255, 0, 0)
    end
end)