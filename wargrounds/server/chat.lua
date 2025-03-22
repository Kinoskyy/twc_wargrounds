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

addEventHandler("onPlayerChat", root, function(msg, tipo)
	local ser = getPlayerSerial(source)
        
	if globalMute.state[ser] then
		return
	end

	local teamColor = {255, 255, 255}
	if getPlayerTeam(source) then
		teamColor = {getTeamColor(getPlayerTeam(source))}
	end
        
	local teamColorHex = string.format("#%02X%02X%02X", teamColor[1], teamColor[2], teamColor[3])

	if messages[msg] and tipo == 0 then
		outputChatBox_(teamColorHex .. getPlayerName(source) .. " (" .. tostring(getElementID(source)) .. "):#FFFFFF " .. messages[msg][1], root, 255, 255, 255, true)
		return
	end
	if tipo == 0 then
		outputChatBox_(teamColorHex .. getPlayerName(source) .. " (" .. tostring(getElementID(source)) .. "):#FFFFFF " .. msg, root, 255, 255, 255, true)
	elseif tipo == 2 then
		local team = getPlayerTeam(source)
		if team then
			for _, v in ipairs(getPlayersInTeam(team)) do
				outputChatBox_(teamColorHex .. "(TEAM) " .. getPlayerName(source) .. " (" .. tostring(getElementID(source)) .. "):#FFFFFF " .. msg, v, 255, 255, 255, true)
			end
		end
	end
end)

addCommandHandler("gmute", function(p, _, id)
	if hasObjectPermissionTo(p, "function.kickPlayer", false) then
		for _, v in ipairs(getElementsByType("player")) do
			if getElementID(v) == tonumber(id) then
				local ser = getPlayerSerial(v)
				local name = getPlayerName(p)
				local muted = globalMute.state[ser] ~= true and {true, "muted"} or {false, "unmuted"}
				outputChatBox_("Admin \"" .. string.gsub(name, "#%x%x%x%x%x%x", "") .. "\" global " .. muted[2] .. " \"" .. string.gsub(getPlayerName(v), "#%x%x%x%x%x%x", "") .. "\"", root, 70, 219, 2)
				globalMute.state[ser] = muted[1]
			end
		end
	end
end)
