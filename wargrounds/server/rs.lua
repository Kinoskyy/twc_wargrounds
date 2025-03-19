local playerTimers = {}

function reset(thePlayer)
    if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then
        local playerName = getPlayerName(thePlayer)
        local currentTime = getTickCount()

        if playerTimers[playerName] and currentTime - playerTimers[playerName] < 300000 then
            local timeLeft = math.ceil((300000 - (currentTime - playerTimers[playerName])) / 1000)
            local playerTeam = getPlayerTeam(thePlayer)
            local r, g, b = 255, 255, 255

            if playerTeam then
                r, g, b = getTeamColor(playerTeam)
            end

            local teamColorHex = string.format("#%02X%02X%02X", r, g, b)
            local message = string.format("%s#FFFFFF%d%s", teamColorHex .. "Wait ", timeLeft, teamColorHex .. " seconds to use this command")
            outputChatBox(message, thePlayer, 255, 255, 255, true)
            return
        end

        setElementData(thePlayer, "Ratio", 0)
        setElementData(thePlayer, "Kills", 0)
        setElementData(thePlayer, "Damage", 0)
        setElementData(thePlayer, "Deaths", 0)

        local playerTeam = getPlayerTeam(thePlayer)
        local r, g, b = 255, 255, 255

        if playerTeam then
            r, g, b = getTeamColor(playerTeam)
        end

        outputChatBox("Your statistics have been reset", thePlayer, r, g, b)
        playerTimers[playerName] = currentTime
    end
end
addCommandHandler("rs", reset)