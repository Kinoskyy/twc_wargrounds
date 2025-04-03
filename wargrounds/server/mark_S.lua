local teamMarkers = {}
local firstBloodOccurred = false
local firstBloodSoundPlayed = false

function createTeamMarker(startX, startY, startZ, hitX, hitY, hitZ, team)
    local player = client
    if not player then return end
    if getElementInterior(player) == 3 then return end
    local playerName = removeColorCoding(getPlayerName(player))
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

function playSoundToAll(soundFile)
    for _, player in ipairs(getElementsByType("player")) do
        triggerClientEvent(player, "playSoundForClient", resourceRoot, soundFile)
    end
end

function onRoundStartHandler()
    firstBloodOccurred = false
    firstBloodSoundPlayed = false
end
addEventHandler("onRoundStart", root, onRoundStartHandler)

function onPlayerWasted(ammo, killer, weapon, bodypart)
    if not firstBloodOccurred and killer and killer ~= source and getElementType(killer) == "player" then
        firstBloodOccurred = true
        
        if not firstBloodSoundPlayed then
            playSoundToAll("audio/first_blood.mp3")
            firstBloodSoundPlayed = true

            local killerName = removeColorCoding(getPlayerName(killer))
            local victimName = removeColorCoding(getPlayerName(source))
            local attackerTeam = getPlayerTeam(killer)
            local victimTeam = getPlayerTeam(source)
            local rAttacker, gAttacker, bAttacker = 255, 255, 255
            local rVictim, gVictim, bVictim = 255, 255, 255
            
            if attackerTeam then
                rAttacker, gAttacker, bAttacker = getTeamColor(attackerTeam)
            end
            if victimTeam then
                rVictim, gVictim, bVictim = getTeamColor(victimTeam)
            end
            local message = "#"..string.format("%02X%02X%02X", rAttacker, gAttacker, bAttacker).."First Blood! "..killerName.." has killed ".."#"..string.format("%02X%02X%02X", rVictim, gVictim, bVictim)..victimName
            outputChatBox(message, root, 255, 255, 255, true)
        end
    end
end
addEventHandler("onPlayerWasted", root, onPlayerWasted)
function removeColorCoding(name)
    return type(name) == 'string' and string.gsub(name, '#%x%x%x%x%x%x', '') or name
end
