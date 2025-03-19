local teamMarkers = {}
function createTeamMarker(startX, startY, startZ, hitX, hitY, hitZ, team)
    local player = client
    if not player then return end
    if getElementInterior(player) == 3 then return end
    local playerName = getPlayerName(player)
    local r, g, b = getTeamColor(team)
    local marker = createMarker(hitX, hitY, hitZ + 3, "arrow", 1, r, g, b, 150)
    if not marker then return end
    local blip = createBlip(hitX, hitY, hitZ, 0, 2, r, g, b, 255, 0, 99999.0)
    if not blip then
        destroyElement(marker)
        return
    end
    setElementVisibleTo(blip, getRootElement(), false)
    for _, teamPlayer in ipairs(getPlayersInTeam(team)) do
        setElementVisibleTo(blip, teamPlayer, true)
    end
    setElementVisibleTo(marker, getRootElement(), false)
    for _, teamPlayer in ipairs(getPlayersInTeam(team)) do
        setElementVisibleTo(marker, teamPlayer, true)
    end
    teamMarkers[marker] = { marker = marker, blip = blip }
    setTimer(destroyTeamMarker, 10000, 1, marker, playerName, team, r, g, b)
    for _, teamPlayer in ipairs(getPlayersInTeam(team)) do
        outputChatBox(playerName .. " has indicated an objective.", teamPlayer, r, g, b)
    end
end
addEvent("createTeamMarker", true)
addEventHandler("createTeamMarker", resourceRoot, createTeamMarker)
function destroyTeamMarker(marker, playerName, team, r, g, b)
    if isElement(marker) then
        destroyElement(marker)
        if teamMarkers[marker] and isElement(teamMarkers[marker].blip) then
            destroyElement(teamMarkers[marker].blip)
        end
        teamMarkers[marker] = nil
    end
end