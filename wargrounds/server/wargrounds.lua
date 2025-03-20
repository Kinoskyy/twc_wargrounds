fn = {}
fn.cHandlers = { starter = 'System', add = 'System', remove = 'System', cheater = 'Unknown', pickups = { 'System', false } }
fn.sSettings = {}
fn.sSettings.pGlitch = { 'fastfire', 'crouchbug', 'quickreload', 'quickstand', 'fastprint', 'fastmove' }
fn.sSettings.pSync = { { 'keysync_mouse_sync_interval', 100 }, { 'player_sync_interval', 100 } }
fn.sSettings.sVersion = 'Wargrounds'; 
fn.sElements = {}
fn.sElements.root = getElementByID('Tactics')
fn.cache = { ['config'] = {} }

addEventHandler('onPlayerChat', root, function(msg, type)
    if type == 0 then
    elseif (type == 2) then
        cancelEvent()
    else
        cancelEvent()
    end
end)

function fn.startGamemodeModifications()
    fn.sElements.root:setData('version', fn.sSettings and fn.sSettings.sVersion or '1.2')
    setGameType('Tactics ' .. fn.sSettings.sVersion)
    setMinuteDuration(999999999)

    if (fn.sSettings.sGlitch) then
        for _, g in pairs(fn.sSettings.sGlitch) do
            setTimer(setGlitchEnabled, 2000, 1, g, true)
        end
    end
    if (fn.sSettings.pSync) then
        for _, s in pairs(fn.sSettings.pSync) do
            setTimer(setServerConfigSetting, 2000, 1, s[1], s[2], true)
        end
    end
end

function fn.onPlayerLogin()
    if (hasObjectPermissionTo(source, 'function.banPlayer', false)) then
        local str = ('Welcome back %s you have succesfully logged in (Admin)'):format(source:getName():gsub('#%x%x%x%x%x%x', ''))
        outputChatBox(str, source, 70, 219, 2)
    else
        local str = ('Welcome back %s you have succesfully logged in'):format(source:getName():gsub('#%x%x%x%x%x%x', ''))
        outputChatBox(str, source, 70, 219, 2)
    end
end

function fn.onPlayerCommand(command)
    if (source:getAccount():isGuest()) then return end
    if (not hasObjectPermissionTo(source, 'function.kickPlayer', true)) then return end
    if (command == 'add') then
        fn.cHandlers.add = source:getName():gsub('#%x%x%x%x%x%x', '')
        setTimer(function() fn.cHandlers.add = 'System' end, 100, 1)
    elseif (command == 'remove') then
        fn.cHandlers.remove = source:getName():gsub('#%x%x%x%x%x%x', '')
        setTimer(function() fn.cHandlers.remove = 'System' end, 100, 1)
    elseif (command == 'zeem') then
        local bSync = getServerConfigSetting('bullet_sync')
        local enabled = bSync ~= '1' and '1' or '0'
        setServerConfigSetting('bullet_sync', enabled, true)
        outputChatBox(('Admin "%s" has set config setting "bullet_sync" to "%s"'):format(source:getName():gsub('#%x%x%x%x%x%x', ''), enabled), root, 70, 219, 2)
    end
end

function pSyncCommand(thePlayer, Command, Arg)
    local source = thePlayer
    if (not hasObjectPermissionTo(thePlayer, 'function.kickPlayer', true)) then return end
    local interval = tonumber(Arg) or 100
    setServerConfigSetting('player_sync_interval', interval, true)
    outputChatBox(('Admin "%s" has set config setting "player_sync_interval" to "%s"'):format(source:getName():gsub('#%x%x%x%x%x%x', ''), interval), root, 70, 219, 2)
end

function kSyncCommand(thePlayer, Command, Arg)
    local source = thePlayer
    if (not hasObjectPermissionTo(thePlayer, 'function.kickPlayer', true)) then return end
    local interval = tonumber(Arg) or 100
    setServerConfigSetting('keysync_mouse_sync_interval', interval, true)
    outputChatBox(('Admin "%s" has set config setting "keysync_mouse_sync_interval" to "%s"'):format(source:getName():gsub('#%x%x%x%x%x%x', ''), interval), root, 70, 219, 2)
end

local glitchesEnabled = false
function cBugCommand(thePlayer)
    if not hasObjectPermissionTo(thePlayer, "function.kickPlayer", true) then return end
    glitchesEnabled = not glitchesEnabled
    local glitches = { "fastfire", "fastmove", "fastsprint", "quickstand", "crouchbug", "quickreload" }
    for k, v in pairs(glitches) do
        setGlitchEnabled(v, glitchesEnabled)
    end
    local playerName = getPlayerName(thePlayer):gsub("#%x%x%x%x%x%x", "")
    outputChatBox('Admin "' .. playerName .. '" has ' .. (glitchesEnabled and "enabled" or "disabled") .. ' glitches', root, 70, 219, 2)
end

local isRoundPaused = false
function pauseCommand(thePlayer)
    if not hasObjectPermissionTo(thePlayer, "function.kickPlayer", true) then
        outputChatBox("No tienes permisos para usar este comando.", thePlayer, 255, 0, 0)
        return
    end
    local playerName = getPlayerName(thePlayer):gsub("#%x%x%x%x%x%x", "")
    isRoundPaused = not isRoundPaused
    outputChatBox('Admin "' .. playerName .. '" has ' .. (isRoundPaused and "paused" or "resume") .. ' the round.', root, 70, 219, 2)
end

addCommandHandler("pause", pauseCommand)
addCommandHandler("psync", pSyncCommand)
addCommandHandler("ksync", kSyncCommand)
addCommandHandler("cbug", cBugCommand)

function fn.onPlayerRoundRespawn()
    local mapInfo = getRoundMapInfo()
    if (mapInfo.modename == 'ctf') then return end
    local str = ('Admin "%s" added %s into the round'):format(fn.cHandlers.add, source:getName():gsub('#%x%x%x%x%x%x', ''))
    outputChatBox_(str, root, 70, 219, 2)
end

function fn.onPlayerRemovedFromRound()
    local mapInfo = getRoundMapInfo()
    if (mapInfo.modename == 'ctf') then return end
    local str = ('Admin "%s" removed %s from the game'):format(fn.cHandlers.remove or 'System', source:getName():gsub('#%x%x%x%x%x%x', ''))
    outputChatBox_(str, root, 70, 219, 2)
end

function fn.onMapStarting(mapInfo)
    setMinuteDuration_(999999998)
    local mapInfo = getRoundMapInfo()
    if (mapInfo.modename == 'ctf') then return end
    local str = ('Admin "%s" started %s map "%s"'):format(fn.cHandlers.starter, firstUpper(mapInfo.modename), (mapInfo.name):match(':(.*)'):sub(2))
    outputChatBox(str, root, 70, 219, 2)
end

addEventHandler('onResourceStart', resourceRoot, fn.startGamemodeModifications)
addEventHandler('onPlayerJoin', root, fn.onPlayerJoin)
addEventHandler('onPlayerQuit', root, fn.onPlayerQuit)
addEventHandler('onPlayerLogin', root, fn.onPlayerLogin)
addEventHandler('onPlayerCommand', root, fn.onPlayerCommand)
addEventHandler('onMapStarting', root, fn.onMapStarting)
addEventHandler('onPlayerRemoveFromRound', root, fn.onPlayerRemovedFromRound)
addEventHandler('onPlayerRoundRespawn', root, fn.onPlayerRoundRespawn)

addEventHandler("onPlayerWeaponpackGot", root, function(weapons)
    local t = getPlayerTeam(source)
    local mapInfo = getRoundMapInfo()
    if (mapInfo.modename == 'ctf') then return end
    if (isPedDead(source)) then return end
    if getElementData(source, "Weapons") then
        if t then
            local r, g, b = getTeamColor(t)
            local hex = RGBToHex(r, g, b)
            if tostring(getElementData(t, "Side")) == "1" then
                for k, v in ipairs(getPlayersInTeam(t)) do
                    if #weapons == 2 then
                        outputChatBox_(getPlayerName(source) .. " #FFFFFFhas selected (" .. hex .. "" .. firstUpper(weapons[1].name) .. " - " .. firstUpper(weapons[2].name) .. "#FFFFFF)", v, r, g, b, true)
                    elseif #weapons == 3 then
                        outputChatBox(getPlayerName(source) .. " #FFFFFFhas selected (" .. hex .. "" .. firstUpper(weapons[1].name) .. " - " .. firstUpper(weapons[2].name) .. " - " .. firstUpper(weapons[3].name) .. "#FFFFFF)", v, r, g, b, true)
                    end
                end
            elseif tostring(getElementData(t, "Side")) == "2" then
                for k, v in ipairs(getPlayersInTeam(t)) do
                    if #weapons == 2 then
                        outputChatBox_(getPlayerName(source) .. " #FFFFFFhas selected (" .. hex .. "" .. firstUpper(weapons[1].name) .. " - " .. firstUpper(weapons[2].name) .. "#FFFFFF)", v, r, g, b, true)
                    elseif #weapons == 3 then
                        outputChatBox_(getPlayerName(source) .. " #FFFFFFhas selected (" .. hex .. "" .. firstUpper(weapons[1].name) .. " - " .. firstUpper(weapons[2].name) .. " - " .. firstUpper(weapons[3].name) .. "#FFFFFF)", v, r, g, b, true)
                    end
                end
            end
        end
    end
end)

function onRoundStart()
    for k, v in ipairs(getElementsByType("player")) do
        local oldDamage = getElementData(v, "Damage") or 0
        local oldKills = getElementData(v, "Kills") or 0
        setElementData(v, "oldDmg", oldDamage)
        setElementData(v, "oldKills", oldKills)
        setElementData(v, "loaded", true)
    end
end

addEventHandler("onRoundStart", getRootElement(), onRoundStart)

addEventHandler("onPlayerWasted", root, function(_, k)
    if isElement(k) and getElementType(k) == "player" then
        triggerClientEvent(k, "showKiller", k, source)
    end
end)

addEventHandler("onPlayerWasted", root, function(ammo, killer, weapon, bodypart)
    local mapInfo = getRoundMapInfo()
    if mapInfo.modename ~= 'ctf' then
        return
    end
    if killer and killer ~= source then
        setElementHealth(killer, 100)
        setPedArmor(killer, 100)
    end
end)

function getAvailableTeams()
    local teams = {}
    for k, team in ipairs(getElementsByType('team')) do
        if tonumber(getElementData(team, 'Side')) then
            table.insert(teams, team)
        end
    end
    return teams
end

setTimer(function()
    local teams = getAvailableTeams()
    local str = ('%s %s - %s %s'):format(getTeamName(teams[1]), getElementData(teams[1], 'Score'), getElementData(teams[2], 'Score'), getTeamName(teams[2]))
    setGameType(str)
end, 1000, 0)
