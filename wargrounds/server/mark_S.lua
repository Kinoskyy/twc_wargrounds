local globalMute = {state = {}}
local messages = {
    ["ez"] = {"#FF69B4 I love you ^^ <3"},
    ["ezz"] = {"#FF69B4 I love you ^^ <3"},
    ["gg"] = {"#22FF00 Good Game"},
    ["gl"] = {"#22FF00 Good Luck"},
    ["bg"] = {"#FF0000 Bad Game"},
    ["bl"] = {"#FF0000 Bad Luck"},
    ["ok"] = {"#4A1F00 ok nerd"},
    ["smd"] = {"#22FF00 suck my dick >_<"},
    ["ggwp"] = {"#C4A20C Well played"},
    ["lol"] = {"#FFA500 Laughing out loud :D"},
    ["omg"] = {"#FFA500 Oh my God!"},
    ["brb"] = {"#00CED1 Be right back"},
    ["idk"] = {"#00CED1 I don't know"},
    ["thanks"] = {"#C71585 Thanks!"},
    ["gtg"] = {"#00BFFF Got to go"},
    ["smile"] = {"#FFFF00 :)"},
    ["grin"] = {"#FFFF00 :D"},
    ["sad"] = {"#FF0000 :("},
    ["love"] = {"#FF1493 <3"},
    ["wink"] = {"#FF69B4 ;)"},
    ["happy"] = {"#22FF00 :happy:"},
    ["shy"] = {"#FF69B4 <.<"},
    ["surprised"] = {"#FF0000 o_O"},
    ["bored"] = {"#4A4A4A --"},
    ["angry"] = {"#FF0000 :angry:"},
    ["laugh"] = {"#FFFF00 XD"},
    ["cute"] = {"#FF69B4 :3"},
    ["dance"] = {"#FF69B4 :dancing:"},
    ["dancing"] = {"#FF69B4 :dancing:"},
    ["thx"] = {"#C71585 Thanks!"},
    ['uwu'] = { '#FF69B4 I love dicks! >.<'}
}

function removeColorCodes(text)
    return text:gsub('#%x%x%x%x%x%x', '')
end

function formatChatMessage(player, message, isTeamChat)
    local teamColor = {255, 255, 255}
    if getPlayerTeam(player) then
        teamColor = {getTeamColor(getPlayerTeam(player))}
    end
    
    local teamColorHex = string.format("#%02X%02X%02X", teamColor[1], teamColor[2], teamColor[3])
    local playerName = removeColorCodes(getPlayerName(player))
    local playerID = tostring(getElementID(player))
    
    if isTeamChat then
        return teamColorHex.."(TEAM) "..playerName.." ("..playerID.."):#FFFFFF "..message
    else
        return teamColorHex..playerName.." ("..playerID.."):#FFFFFF "..message
    end
end

addEventHandler("onPlayerChat", root, function(msg, msgType)
    local serial = getPlayerSerial(source)
    
    if globalMute.state[serial] and msgType ~= 2 then
        cancelEvent()
        return
    end
    
    if messages[msg:lower()] and msgType == 0 then
        outputChatBox_(formatChatMessage(source, messages[msg:lower()][1]), root, 255, 255, 255, true)
        cancelEvent()
        return
    end
    
    if msgType == 0 then
        outputChatBox_(formatChatMessage(source, msg), root, 255, 255, 255, true)
        cancelEvent()
    elseif msgType == 2 then
        local team = getPlayerTeam(source)
        if team then
            for _, player in ipairs(getPlayersInTeam(team)) do
                outputChatBox_(formatChatMessage(source, msg, true), player, 255, 255, 255, true)
            end
        end
        cancelEvent()
    end
end)

addCommandHandler("gmute", function(player, cmd, targetID)
    if not hasObjectPermissionTo(player, "function.kickPlayer", false) then return end
    if not targetID then return end
    local target = getPlayerByID(targetID)
    if not target then return end
    local targetSerial = getPlayerSerial(target)
    local adminName = removeColorCodes(getPlayerName(player))
    local targetName = removeColorCodes(getPlayerName(target))
    
    globalMute.state[targetSerial] = not globalMute.state[targetSerial]
    local action = globalMute.state[targetSerial] and "muted" or "unmuted"
    
    outputChatBox_(
        "Admin \""..adminName.."\" has global "..action.." \""..targetName.."\"", root, 70, 219, 2, true)
end)
function getPlayerByID(id)
    for _, player in ipairs(getElementsByType("player")) do
        if tostring(getElementID(player)) == tostring(id) then
            return player
        end
    end
    return false
end
